// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require turbolinks
//= require jquery.ui.all
//= require jquery.validate
//= require jquery.embedly
//= require tag-it
//= require bootstrap
//= require bootstrap-multiselect
//= require underscore
//= require js-routes
//= require backbone
//= require backbone.marionette
//= require backbone_rails_sync
//= require backbone_datalink
//= require backbone/cakeside
//= require backbone-model-file-upload
//= require_tree .

var initialize = function(){
  $('.tooltip-item').tooltip();
  $(window).scroll(function(){
    if ($(window).scrollTop() >= ($(document).height() - $(window).height())*0.8){
      $('.more-button').trigger('click');
    }
  });
};
$(document).ready(initialize);
$(document).on("page:load", initialize);
