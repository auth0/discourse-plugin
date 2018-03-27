(function () {
  var ApplicationRoute = require('discourse/routes/application').default;
  ApplicationRoute.reopen({
    actions: {
      showLogin: function() {
        if (!Discourse.SiteSettings.auth0_client_id || Discourse.SiteSettings.auth0_connection !== '') {
          return this._super();
        }
        window.location.href = "/auth/auth0";
      },
      showCreateAccount: function () {
        if (!Discourse.SiteSettings.auth0_client_id || Discourse.SiteSettings.auth0_connection !== '') {
          return this._super();
        }

        var createAccountController = Discourse.__container__.lookup('controller:createAccount');

        if (createAccountController && createAccountController.accountEmail) {
          this._super();
        } else {
          window.location.href = "/auth/auth0";
        }
      }
    }
  });

})();