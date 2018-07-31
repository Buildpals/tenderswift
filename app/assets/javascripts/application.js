// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.

//= require rails-ujs
//= require turbolinks


// Boostrap 4 gem requirements
//= require jquery3
//= require popper
//= require bootstrap-sprockets


// Broadcast channels
//= require_tree ./channels

// Autosize textarea
//= require autosize

// Jquery Are You Sure
//= require jquery.are-you-sure
//= require ays-beforeunload-shim

// Cocoon
//= require cocoon

// Trix
//= require trix

// IntlTelInput
//= require intlTelInput
//= require libphonenumber/utils

//= require compare_bids
//= require registrations
//= require request_for_tenders/build
//= require request_for_tenders
//= require tenders
//= require bids
//= require purchase_tender
//= require contractors
//= require pdf
//= require pdf_viewer


$(document).on("turbolinks:load", function () {
  $('[data-toggle="tooltip"]').tooltip()
})