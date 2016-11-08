import { withPluginApi } from 'discourse/lib/plugin-api';
import LoginController from 'discourse/controllers/login';
import ApplicationRoute from 'discourse/routes/application';

export default {
  name: 'auth0',
  initialize() {

     withPluginApi('0.1', api => {
       var ss = api.container.lookup('site-settings:main')

       if (!ss.auth0_client_id) {
         return;
       }

       var client_id = ss.auth0_client_id;
       var domain = ss.auth0_domain;
       var callback_url = ss.auth0_callback_url;
       var connection = ss.auth0_connection;
       var passwordless = ss.auth0_passwordless;
       var passwordless_method = ss.auth0_passwordless_method;

       if (passwordless) {
         var lock = new Auth0LockPasswordless(client_id, domain);
         var method = passwordless_method || 'magiclink';
       } else {
         var lock = new Auth0Lock(client_id, domain);
         var method = 'show';
       }

       LoginController.reopen({
         authenticationComplete: function () {
           if (lock) {
             lock.hide();
           }
           return this._super.apply(this, arguments);
         }
       });

       ApplicationRoute.reopen({
         actions: {
           showLogin: function() {
             if (connection !== '') {
               return this._super();
             }

             lock[method]({
               popup:        false,
               responseType: 'code',
               callbackURL:  callback_url
             });

             this.controllerFor('login').resetForm();
           },
           showCreateAccount: function () {
             if (connection !== '') {
               return this._super();
             }

             var createAccountController = Discourse.__container__.lookup('controller:createAccount');

             if (createAccountController && createAccountController.accountEmail) {
               if (lock) {
                 lock.hide();
                 Discourse.Route.showModal(this, 'createAccount');
               } else {
                 this._super();
               }
             } else {
               lock[method]({
                 mode:         'signup',
                 popup:        false,
                 responseType: 'code',
                 callbackURL:  callback_url
               });
             }
           }
         }
       });

     });
  }
}
