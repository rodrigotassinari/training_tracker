// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .

// https://github.com/rails/turbolinks#events
$(document).on('ready', function(event) {
  // initialize persistent state
  Turbolinks.enableProgressBar();
});
$(document).on('ready page:load', function(event) {
  // apply non-idempotent transformations to the body
});
$(document).on('page:partial-load', function(event) {
  // apply non-idempotent transformations to the nodes in event.data
});
$(document).on('page:change', function(event) {
  // idempotent function
});
$(document).on('page:after-remove', function(event) {
  // delete all references to the nodes in event.data to prevent memory leaks
});
