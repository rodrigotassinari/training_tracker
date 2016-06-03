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
//= require inputmask.min
//= require jquery.inputmask.min
//= require inputmask.extensions.min
//= require inputmask.date.extensions.min
//= require inputmask.numeric.extensions.min
//= require inputmask.app
//= require_tree .

// https://github.com/turbolinks/turbolinks#full-list-of-events
$(document).on('turbolinks:load', function(event) {
  // initialize persistent state, turbolinks equivalent of jquery ready
  // fires once after the initial page load, and again after every Turbolinks visit.
});
$(document).on('turbolinks:before-cache', function(event) {
  // event if you need to prepare the document before Turbolinks caches it
  // fires before Turbolinks saves the current page to cache.
  $('.alert-dismissible').alert('close'); // closes flash alerts
});
