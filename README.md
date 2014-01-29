This is a [discourse](https://discourse.org) plugin to authenticate with Auth0.

Auth0 is an authentication broker that support social identity providers but also enterprise identity providers like __Active Directory__, __Google Apps__, __Office 365__ and __Windows Azure AD__.

## Installation

Create an account on [Auth0](http://auth0.com) and register a new Rails application.

Run in your discourse root folder:

```
$ git clone git@github.com:auth0/discourse-plugin.git plugins/auth0
```

Modify `plugin.rb` and `assets/javascripts/auth0.js` with your Auth0's `client_id`, `client_secret` and `domain`.

Our client side asset will override the Discourse login popup, all the authentication flow happens on the same browser tab, so you have to do an small modification in this file `/app/controllers/users/omniauth_callbacks_controller.rb` in the complete route instead of:

```ruby
    respond_to do |format|
      format.html
      format.json { render json: @data.to_client_hash }
    end
```

redirect to home as follows:

```ruby
    redirect_to "/"
```

## License

MIT - 2014 - AUTH10 LLC