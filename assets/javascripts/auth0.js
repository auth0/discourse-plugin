/* global Auth0Widget */
(function () {
  function appendScript(src, callback) {
    var new_script = document.createElement('script');
    new_script.setAttribute('src',src);
    new_script.onload = callback;
    document.head.appendChild(new_script);
  }

  var widget;

  appendScript('//cdn.auth0.com/w2/auth0-widget-2.5.js', function () {
    var checkInterval = setInterval(function () {
      if (!Discourse.SiteSettings) return;
      clearInterval(checkInterval);

      if (!Discourse.SiteSettings.auth0_client_id) return;
      widget = new Auth0Widget({
        domain:      Discourse.SiteSettings.auth0_domain,
        clientID:    Discourse.SiteSettings.auth0_client_id,
        callbackURL: Discourse.SiteSettings.auth0_callback_url
      });
    }, 300);
  });

  Discourse.ApplicationRoute.reopen({
    actions: {
      showLogin: function() {
        if (!Discourse.SiteSettings.auth0_client_id || Discourse.SiteSettings.auth0_connection !== '') {
          return this._super();
        }
        widget.signin({
          popup: true
        });
        this.controllerFor('login').resetForm();
      },
      showCreateAccount: function () {
        if (widget) widget._hideSignIn();
        this._super();
      }
    }
  });

})();
