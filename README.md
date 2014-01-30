Discourse + Auth0
========

This is a [discourse](https://discourse.org) plugin to authenticate with Auth0.

## What do I get by using Auth0?

* Support for Active Directory / LDAP
  * No matter if Discourse is on the cloud or on-prem, it will work transparently
* Support for other enterprise logins like SAML Protocol, Windows Azure AD, Salesforce, etc. All supported here: https://docs.auth0.com/identityproviders.
* Support for social providers without having to add OmniAuth strategies by hand. Just turn on/off social providers (see #)
* Support for Single Sign On with other Discourse instances and any other application in your account.


Auth0 is an authentication broker that support social identity providers but also enterprise identity providers like __Active Directory__, __Google Apps__, __Office 365__ and __Windows Azure AD__.

## Installation

1. Create an account on [Auth0](http://auth0.com) and register a new Rails application.

2. Run in your discourse root folder:

  ```
  $ git clone git@github.com:auth0/discourse-plugin.git plugins/auth0
  ```

3. Modify __plugin.rb__ and __assets/javascripts/auth0.js__ with your Auth0's:

<img src="https://docs.google.com/drawings/d/1-wQhQ8hu24C-a-TXNPjVEYiXt_78cTV7uOTgKlr-pbE/pub?w=681&amp;h=699">

4. Enjoy!

### Adding Active Directory / LDAP

![](https://www.dropbox.com/s/d1br7nejmv0a0l8/ad-connection.gif?dl=1)

### Adding Social Providers

![](https://www.dropbox.com/s/oaidgrsriy51a4e/social-connections.gif?dl=1)

### Single Sign On Between multiple Discourse forums

![](https://www.dropbox.com/s/kdlzaww1egqfgvo/sso-discourse.gif?dl=1)

## But, I want to use the default discourse login mechanism + AD through Auth0

Fine, put the settings as explained in the above section and also put the name of the auth0 connection you want to use in AUTH0_CONNECTION.

## TODO

I couldn't make plugin settings works for this plugin.
Any contributions are accepted.

## License

MIT - 2014 - AUTH10 LLC
