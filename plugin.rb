# name: auth0
# about: Authenticate with auth0
# version: 1.0.0
# authors: Jose Romaniello

require 'auth/oauth2_authenticator'

require File.dirname(__FILE__) + "/../../app/models/oauth2_user_info"

class Auth0Authenticator < ::Auth::OAuth2Authenticator

  def after_authenticate(auth_token)
    return super(auth_token) if SiteSetting.auth0_connection != ''

    puts "hi! #{Oauth2UserInfo.class.name}"

    result = Auth::Result.new

    oauth2_provider = auth_token[:provider]
    oauth2_uid = auth_token[:uid]
    data = auth_token[:info]
    result.email = email = data[:email]
    result.name = name = data[:name]

    oauth2_user_info = Oauth2UserInfo.where(uid: oauth2_uid, provider: oauth2_provider).first


    if !oauth2_user_info && @opts[:trusted]

      user = User.find_by_email(email)

      if !data[:email_verified] && user
        raise "There is a registered user with this email already."
      end

      if !user && SiteSetting.auth0_connection == ''
        user = User.new()
        user.email = email
        user.username = data[:nickname].gsub(/[^\w*]/, '_')
        user.name = data[:name]
        user.active = true
        saved = user.save

        unless saved
          Rails.logger.info "Error saving #{user.inspect}: #{user.errors.inspect}"
          raise "error saving the user: #{user.errors.inspect}"
        end
      end

      oauth2_user_info = Oauth2UserInfo.create(uid: oauth2_uid,
                                               provider: oauth2_provider,
                                               name: name,
                                               email: email,
                                               user_id: user.id)
    end

    result.user = oauth2_user_info.try(:user)
    result.email_valid = @opts[:trusted]

    result.extra_data = {
      uid: oauth2_uid,
      provider: oauth2_provider
    }

    result
  end

  def register_middleware(omniauth)
    omniauth.provider :auth0,
        SiteSetting.auth0_client_id,
        SiteSetting.auth0_client_secret,
        SiteSetting.auth0_domain
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
      param[:connection] = AUTH0_CONNECTION
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
# Monkeypatch complete method to redirect back to root.
after_initialize do
  class Users::OmniauthCallbacksController < ApplicationController
    def complete
      return super() if SiteSetting.auth0_connection != ''

      auth = request.env["omniauth.auth"]
      auth[:session] = session

      authenticator = self.class.find_authenticator(params[:provider])

      @data = authenticator.after_authenticate(auth)
      @data.authenticator_name = authenticator.name

      if @data.user
        user_found(@data.user)
      elsif SiteSetting.invite_only?
        @data.requires_invite = true
      else
        session[:authentication] = @data.session_data
      end

      redirect_to "/"
    end
  end
end

auth_provider :title => 'Auth0',
    :message => 'Log in via Auth0',
    :frame_width => 920,
    :frame_height => 800,
    :authenticator => Auth0Authenticator.new('auth0', trusted: true)
