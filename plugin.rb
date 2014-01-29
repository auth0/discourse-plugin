# name: existing_site_oauth2
# about: Authenticate with discourse via ExistingSite's Oauth
# version: 0.2.0
# authors: Michael Kirk

require 'auth/oauth2_authenticator'

class Auth0Authenticator < ::Auth::OAuth2Authenticator

  CLIENT_ID = 'YOUR-CLIENT-ID'
  CLIENT_SECRET = 'YOUR-CLIENT-SECRET'
  DOMAIN = 'YOUR-ACCOUNT.auth0.com'

  def register_middleware(omniauth)
    omniauth.provider :auth0,
        CLIENT_ID,
        CLIENT_SECRET,
        DOMAIN,
        args: { :connection => 'fo prueba' }
  end
end

require 'omniauth-oauth2'
class Auth0 < OmniAuth::Strategies::OAuth2
  PASSTHROUGHS = %w[
    connection
    redirect_uri
  ]

  option :name, "auth0"
  option :domain, nil
  option :provider_ignores_state, true

  args [:client_id, :client_secret, :domain, :provider_ignores_state]

  def initialize(app, *args, &block)
    super
    @options.provider_ignores_state = args[3] unless args[3].nil?

    @options.client_options.site          = "https://#{options[:domain]}"
    @options.client_options.authorize_url = "https://#{options[:domain]}/authorize"
    @options.client_options.token_url     = "https://#{options[:domain]}/oauth/token"
    @options.client_options.userinfo_url  = "https://#{options[:domain]}/userinfo"
  end

  def authorize_params
    super.tap do |param|
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
      :image => raw_info["picture"]
    }
  end

  def raw_info
    @raw_info ||= access_token.get(options.client_options.userinfo_url).parsed
  end
end

register_asset "javascripts/auth0_widget.js"

auth_provider :title => 'Auth0',
    :message => 'Log in via Auth0',
    :frame_width => 920,
    :frame_height => 800,
    :authenticator => Auth0Authenticator.new('auth0', trusted: true)
