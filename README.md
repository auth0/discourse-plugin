Discourse + Auth0
=================

This is a [Discourse](http://discourse.org) plugin to do Single Sign On using Auth0.

### Demo: https://auth0.com/forum/

![discourse login](https://dl.dropboxusercontent.com/u/21665105/discourse-login.gif)

## What do I get by using Auth0?

* Support for Active Directory / LDAP (see [animated gif](#adding-active-directory--ldap))
  * No matter if Discourse is on the cloud or on-prem, it will work transparently
  * Support for Kerberos too (configured by IP ranges)
* Support for other enterprise logins like SAML Protocol, Windows Azure AD, Google Apps, Salesforce, etc. All supported here: https://docs.auth0.com/identityproviders.
* Support for social providers without having to add OmniAuth strategies by hand. Just turn on/off social providers (see [animated gif](#adding-social-providers))
* Support for Single Sign On with other Discourse instances and any other application in your account (see [animated gif](#single-sign-on-between-multiple-discourse-forums).

## Installation

-  Create an account on [Auth0](https://auth0.com) and open the application settings.

-  Install Discourse. [You can use this guide to install Discourse on any platform](https://github.com/discourse/discourse/blob/master/docs/INSTALL-cloud.md)

-  Edit your `containers/app.yml` to include this under `hooks > after_code > exec > cmd`:

        - git clone https://github.com/auth0/discourse-plugin.git auth0

-  Follow the rest of the tutorial

-  Login as an administrator using a discourse account (not auth0 yet)

-  Configure your settings as shown in this image

<img src="http://blog.auth0.com.s3.amazonaws.com/ss-2014-02-03T14-32-49.png">̇</img>

Enjoy!

## Email verification

In order to login to discourse the email of the user should be verified either at the Auth0 service level or in Discourse itself.

Some Social Providers already verify the email but others not. If the user hasn't verified the email it will receive two emails the first one from Auth0 and the second one from Discourse. This can be confusing for the end-user, a simple fix is to only allow verified users to sign in to Discourse by using an Auth0 Rule like this:

```javascript
function (user, context, callback) {
  if (!user.email_verified && context.clientID === 'introduce-discourse-client-id') {
    return callback(new UnauthorizedError('Please verify your email and sign in again.'));
  }
  return callback(null, user, context);
}
```

----

#### Adding Active Directory / LDAP

![active directory config](https://dl.dropboxusercontent.com/u/21665105/ad-connection.gif)

#### Adding Social Providers

![social providers config](https://dl.dropboxusercontent.com/u/21665105/social-connections.gif)

#### Single Sign On Between multiple Discourse forums

![single sign on](https://dl.dropboxusercontent.com/u/21665105/sso-discourse.gif)

#### Single Sign On with Windows Authentication

![windows auth](https://s3.amazonaws.com/blog.auth0.com/login_discourse_kerberos-2.gif)

### Give admin rights to an email

```
$ RAILS_ENV=production bundle exec rails c
$ u = User.find_by_email('the-email-you-want-to-make-admin@whatever.com')
$ u.admin = true
$ u.save!
```
## What is Auth0?

Auth0 helps you to:

* Add authentication with [multiple authentication sources](https://docs.auth0.com/identityproviders), either social like **Google, Facebook, Microsoft Account, LinkedIn, GitHub, Twitter, Box, Salesforce, amont others**, or enterprise identity systems like **Windows Azure AD, Google Apps, Active Directory, ADFS or any SAML Identity Provider**.
* Add authentication through more traditional **[username/password databases](https://docs.auth0.com/mysql-connection-tutorial)**.
* Add support for **[linking different user accounts](https://docs.auth0.com/link-accounts)** with the same user.
* Support for generating signed [Json Web Tokens](https://docs.auth0.com/jwt) to call your APIs and **flow the user identity** securely.
* Analytics of how, when and where users are logging in.
* Pull data from other sources and add it to the user profile, through [JavaScript rules](https://docs.auth0.com/rules).

## Create a free Auth0 Account

1. Go to [Auth0](https://auth0.com) and click Sign Up.
2. Use Google, GitHub or Microsoft Account to login.

## Issue Reporting

If you have found a bug or if you have a feature request, please report them at this repository issues section. Please do not report security vulnerabilities on the public GitHub issue tracker. The [Responsible Disclosure Program](https://auth0.com/whitehat) details the procedure for disclosing security issues.

## Author

[Auth0](https://auth0.com)

## License

This project is licensed under the MIT license. See the [LICENSE](LICENSE.txt) file for more info.
