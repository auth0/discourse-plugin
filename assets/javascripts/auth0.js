(function () {

  function appendScript(src) {
    var new_script = document.createElement('script');
    new_script.setAttribute('src',src);
    document.head.appendChild(new_script);
  }

  //With WIDGET
  appendScript('//d19p4zemcycm7a.cloudfront.net/w2/auth0-widget-2.4.min.js');

  Discourse.ApplicationRoute.reopen({
    actions: {
      showLogin: function() {
        var widget = new Auth0Widget({
          domain:         'YOUR-ACCOUNT.auth0.com',
          clientID:       'YOUR-AUTH0-CLIENT-ID',
          callbackURL:    'https://<YOUR DISCOURSE DOMAIN>/auth/auth0/callback'
        });

        widget.signin();

        this.controllerFor('login').resetForm();
      }
    }
  });

  //HEADLESS one connection
  // appendScript('//d19p4zemcycm7a.cloudfront.net/w2/auth0-1.2.2.min.js');
  // Discourse.ApplicationRoute.reopen({
  //   actions: {
  //     showLogin: function() {
  //       var widget = new Auth0({
  //         domain:         'YOUR-ACCOUNT.auth0.com',
  //         clientID:       'YOUR-CLIENT-ID',
  //         callbackURL:    'http://localhost:4000/auth/auth0/callback'
  //       });

  //       widget.signin({connection: 'myad'});
  //     }
  //   }
  // });

})();