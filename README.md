This is a [discourse](https://discourse.org) plugin to authenticate with Auth0.

Auth0 is an authentication broker that support social identity providers but also enterprise identity providers like __Active Directory__, __Google Apps__, __Office 365__ and __Windows Azure AD__.

## Installation

Create an account on [Auth0](http://auth0.com) and register a new Rails application.

Run in your discourse root folder:

```
$ git clone git@github.com:auth0/discourse-plugin.git plugins/auth0
```

Modify __plugin.rb__ and __assets/javascripts/auth0.js__ with your Auth0's `AUTH0_CLIENT_ID`, `AUTH0_CLIENT_SECRET`, `AUTH0_DOMAIN` and `AUTH0_CALLBACK` explained in the comments.

## But, I want to use the default discourse login mechanism + AD through Auth0

Fine, put the settings as explained in the above section and also put the name of the auth0 connection you want to use in AUTH0_CONNECTION.

## TODO

I couldn't make plugin settings works for this plugin.
Any contributions are accepted.

## License

MIT - 2014 - AUTH10 LLC