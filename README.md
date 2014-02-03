Discourse + Auth0
========

This is a [discourse](https://discourse.org) plugin to do Single Sign On using [Auth0](https://www.auth0.com).

### Demo: https://ask.auth0.com

![discourse login](https://dl.dropboxusercontent.com/u/21665105/discourse-login.gif)

## What do I get by using Auth0?

* Support for Active Directory / LDAP (see [animated gif](#adding-active-directory--ldap))
  * No matter if Discourse is on the cloud or on-prem, it will work transparently
  * Support for Kerberos too (configured by IP ranges)
* Support for other enterprise logins like SAML Protocol, Windows Azure AD, Google Apps, Salesforce, etc. All supported here: https://docs.auth0.com/identityproviders.
* Support for social providers without having to add OmniAuth strategies by hand. Just turn on/off social providers (see [animated gif](#adding-social-providers))
* Support for Single Sign On with other Discourse instances and any other application in your account (see [animated gif](#single-sign-on-between-multiple-discourse-forums).

## Installation

1. Create an account on [Auth0](http://auth0.com) and register a new Rails application.

2. Run in your discourse root folder:

	git clone git@github.com:auth0/discourse-plugin.git plugins/auth0

3. Login as an adminstrator to your discourse setting using one of the pre-existing auth plugins.

4. Configure the Auth0 plugin in the admin section

<img src="http://blog.auth0.com.s3.amazonaws.com/ss-2014-02-03T14-32-49.png">̇</img>
5. Enjoy!

----

#### Adding Active Directory / LDAP

![active directory config](https://dl.dropboxusercontent.com/u/21665105/ad-connection.gif)

#### Adding Social Providers

![social providers config](https://dl.dropboxusercontent.com/u/21665105/social-connections.gif)

#### Single Sign On Between multiple Discourse forums

![single sign on](https://dl.dropboxusercontent.com/u/21665105/sso-discourse.gif)

#### Single Sign On with Windows Authentication

![windows auth](https://s3.amazonaws.com/blog.auth0.com/login_discourse_kerberos-2.gif)

### Using Discourse Login Dialog instead of Auth0

You can keep using Discourse Login dialog and integrate only a specific connection from Auth0. It will show up as another button like the social providers.

Go to admin site settings for Auth0 and change the `auth0_connection` with the connection name you want to use from Auth0.

![](https://s3.amazonaws.com/blog.auth0.com/login_discourse_ad.gif)

## TODO

* Add a plugin UI on the Admin section ot configure the secrets, etc.
* Add support for using Discourse Login user/password input to call Auth0 on AD/LDAP connections using [auth0.js](https://github.com/auth0/auth0.js)

## License

MIT - 2014 - AUTH10 LLC
