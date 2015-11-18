// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on('ready page:load', function(event) {
  // apply non-idempotent transformations to the body

  $('div.workout-summary').on('mouseover', function(){
    $('div.quick-actions', this).removeClass('hidden');
  }).on('mouseout', function(){
    $('div.quick-actions', this).addClass('hidden');
  });

});
