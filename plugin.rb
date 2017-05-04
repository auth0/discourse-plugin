# name: auth0
# about: Authenticate with auth0
# version: 2.1.0
# authors: Jose Romaniello

require 'auth/oauth2_authenticator'

require File.dirname(__FILE__) + "/../../app/models/oauth2_user_info"

class Auth0Authenticator < ::Auth::OAuth2Authenticator

  def after_authenticate(auth_token)
    return super(auth_token) if SiteSetting.auth0_connection != ''

    result = Auth::Result.new

    oauth2_uid = auth_token[:uid]
    data = auth_token[:info]
    result.email = email = data[:email]
    result.name = name = data[:name]

    oauth2_user_info = Oauth2UserInfo.where(uid: oauth2_uid, provider: 'Auth0').first

    result.extra_data = {
      uid: oauth2_uid,
      provider: 'Auth0',
      name: name,
      email: email,
    }

    result.user = oauth2_user_info.try(:user)
    result.email_valid = data[:email] && data[:email_verified]

    if !result.user && !email.blank? && result.email_valid
      if result.user = User.find_by_email(email)
        Oauth2UserInfo.create({ uid: oauth2_uid,
                        provider: 'Auth0',
                        name: name,
                        email: email,
                        user_id: result.user.id })
      end
    end

    result
  end

  def register_middleware(omniauth)
    omniauth.provider :auth0,
          :setup => lambda { |env|
            strategy = env["omniauth.strategy"]
            strategy.options[:client_id] = SiteSetting.auth0_client_id
            strategy.options[:client_secret] = SiteSetting.auth0_client_secret
            strategy.options[:connection] = SiteSetting.auth0_connection

            domain = SiteSetting.auth0_domain

            strategy.options[:domain] = domain
            strategy.options[:client_options].site          = "https://#{domain}"
            strategy.options[:client_options].authorize_url = "https://#{domain}/authorize"
            strategy.options[:client_options].token_url     = "https://#{domain}/oauth/token"
            strategy.options[:client_options].userinfo_url  = "https://#{domain}/userinfo"
          }

  end
end

require 'omniauth-oauth2'
class OmniAuth::Strategies::Auth0 < OmniAuth::Strategies::OAuth2
  PASSTHROUGHS = %w[
    connection
    redirect_uri
  ]

  option :name, "auth0"
  option :domain, nil
  option :provider_ignores_state, true
  option :connection, ""

  def authorize_params
    super.tap do |param|
      param[:connection] = options.connection
      PASSTHROUGHS.each do |p|
        param[p.to_sym] = request.params[p] if request.params[p]
      end
    end
  end

  uid { raw_info["user_id"] }

  extra do
    { :raw_info => raw_info }
  end

  info do
    {
      :name => raw_info["name"],
      :email => raw_info["email"],
      :nickname => raw_info["nickname"],
      :first_name => raw_info["given_name"],
      :last_name => raw_info["family_name"],
      :location => raw_info["locale"],
      :image => raw_info["picture"],
      :email_verified => raw_info["email_verified"]
    }
  end

  def raw_info
    @raw_info ||= access_token.get(options.client_options.userinfo_url).parsed
  end
end

register_asset "javascripts/auth0.js"

auth_provider :title => 'Auth0',
    :message => 'Log in via Auth0',
    :frame_width => 920,
    :frame_height => 800,
    :authenticator => Auth0Authenticator.new('auth0', trusted: true)
