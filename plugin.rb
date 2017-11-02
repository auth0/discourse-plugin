# name: auth0
# about: Authenticate with auth0
# version: 2.1.1
# authors: Jose Romaniello

require 'auth/oauth2_authenticator'

require File.dirname(__FILE__) + '/../../app/models/oauth2_user_info'

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
      email: email
    }

    result.user = oauth2_user_info.try(:user)
    result.email_valid = data[:email] && data[:email_verified]

    if !result.user && !email.blank? && result.email_valid
      if result.user = User.find_by_email(email)
        Oauth2UserInfo.create(uid: oauth2_uid,
                              provider: 'Auth0',
                              name: name,
                              email: email,
                              user_id: result.user.id)
      end
    end

    result
  end

  def register_middleware(omniauth)
    omniauth.provider :auth0,
                      SiteSetting.auth0_client_id,
                      SiteSetting.auth0_client_secret,
                      SiteSetting.auth0_domain,
                      setup: lambda { |env|
                        strategy = env['omniauth.strategy']
                        strategy.options[:provider_ignores_state] = true
                      }
  end
end

require 'omniauth-oauth2'
class OmniAuth::Strategies::Auth0 < OmniAuth::Strategies::OAuth2
  option :name, 'auth0'

  args %i[
    client_id
    client_secret
    domain
  ]

  def client
    options.client_options.site = domain_url
    options.client_options.authorize_url = '/authorize'
    options.client_options.token_url = '/oauth/token'
    options.client_options.userinfo_url = '/userinfo'
    super
  end

  uid { raw_info['sub'] }

  credentials do
    hash = { 'token' => access_token.token }
    hash['expires'] = true
    if access_token.params
      hash['id_token'] = access_token.params['id_token']
      hash['token_type'] = access_token.params['token_type']
      hash['refresh_token'] = access_token.refresh_token
    end
    hash
  end

  extra do
    {
      raw_info: raw_info
    }
  end

  info do
    {
      name: raw_info['name'],
      nickname: raw_info['nickname'],
      email: raw_info['email'],
      email_verified: raw_info['email_verified'],
      image: raw_info['picture'],
      first_name: raw_info['given_name'],
      last_name: raw_info['family_name'],
      location: raw_info['locale']
    }
  end

  def authorize_params
    params = super
    params['auth0Client'] = client_info
    params
  end

  def request_phase
    if no_client_id?
      fail!(:missing_client_id)
    elsif no_client_secret?
      fail!(:missing_client_secret)
    elsif no_domain?
      fail!(:missing_domain)
    else
      super
    end
  end

  private

  def raw_info
    userinfo_url = options.client_options.userinfo_url
    @raw_info ||= access_token.get(userinfo_url).parsed
  end

  def no_client_id?
    ['', nil].include?(options.client_id)
  end

  def no_client_secret?
    ['', nil].include?(options.client_secret)
  end

  def no_domain?
    ['', nil].include?(options.domain)
  end

  def domain_url
    domain_url = URI(options.domain)
    domain_url = URI("https://#{domain_url}") if domain_url.scheme.nil?
    domain_url.to_s
  end

  def client_info
    client_info = JSON.dump(
      name: 'omniauth-auth0',
      version: '2.0.0'
    )
    Base64.urlsafe_encode64(client_info)
  end
end

register_asset 'javascripts/auth0.js'

auth_provider title: 'Auth0',
              message: 'Log in via Auth0',
              frame_width: 920,
              frame_height: 800,
              authenticator: Auth0Authenticator.new('auth0', trusted: true)
