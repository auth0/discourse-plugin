/* global Auth0Widget */
(function () {
  function appendScript(src, callback) {
    var new_script = document.createElement('script');
    new_script.setAttribute('src',src);
    new_script.onload = callback;
    document.head.appendChild(new_script);
  }
  
  function signinWithSSO() {
    widget.getClient().getSSOData(function(err, ssodata) {
      // if there is an SSO session, auto-login
      if (ssodata.sso) {
        widget.getClient().login({connection: ssodata.lastUsedConnection.name});
      }
    });
  }

  var widget;

  appendScript('//d19p4zemcycm7a.cloudfront.net/w2/auth0-widget-2.4.min.js', function () {
    var checkInterval = setInterval(function () {
      if (!Discourse.SiteSettings) return;
      clearInterval(checkInterval);

      if (!Discourse.SiteSettings.auth0_client_id) return;
      widget = new Auth0Widget({
        domain:      Discourse.SiteSettings.auth0_domain,
        clientID:    Discourse.SiteSettings.auth0_client_id,
        callbackURL: Discourse.SiteSettings.auth0_callback_url
      });

      var currentUser = Discourse.User.current();
      if (currentUser == null || undefined == currentUser) {
         signinWithSSO();
      }

    }, 300);
  });

  Discourse.ApplicationRoute.reopen({
    actions: {
      showLogin: function() {
        if (!Discourse.SiteSettings.auth0_client_id || Discourse.SiteSettings.auth0_connection !== '') {
          return this._super();
        }
        widget.signin();
        this.controllerFor('login').resetForm();
      }
    }
  });

  Discourse.UserRoute.reopen({
    actions: {
      logout: function() {
        Discourse.User.logout().then(function() {
           // Reloading will refresh unbound properties
           Discourse.KeyValueStore.abandonLocal();
           // logout from SSO
           widget.getClient().logout({returnTo: "http://" + Discourse.BaseUrl});
        });
      }
    }
  });
  
})();
