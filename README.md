Discourse + Auth0
=================

This is a [Discourse](http://discourse.org) plugin to do Single Sign On using Auth0.

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

-  Create an account on [Auth0](http://auth0.com) and open the application settings.

-  Install Discourse. [You can use this guide to install Discourse on any platform](https://github.com/discourse/discourse/blob/master/docs/INSTALL-digital-ocean.md)

-  Edit your `containers/app.yml` to include this under `hooks > after_code > exec > cmd`:

        - git clone https://github.com/auth0/discourse-plugin.git auth0

-  Follow the rest of the tutorial

-  Login as an administrator using a discourse account (not auth0 yet)

-  Configure your settings as shown in this image

<img src="http://blog.auth0.com.s3.amazonaws.com/ss-2014-02-03T14-32-49.png">̇</img>

Enjoy!

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

### Give admin rights to an email

```
$ RAILS_ENV=production bundle exec rails c
$ u = User.find_by_email('the-email-you-want-to-make-admin@whatever.com')
$ u.admin = true
$ u.save!
```
## Issue Reporting

If you have found a bug or if you have a feature request, please report them at this repository issues section. Please do not report security vulnerabilities on the public GitHub issue tracker. The [Responsible Disclosure Program](https://auth0.com/whitehat) details the procedure for disclosing security issues.

## License

MIT - 2014 - AUTH0, INC.
