$(document).on("turbolinks:load", function () {
    if ($(".registrations.new, .quantity_surveyors.edit").length === 0) return;


    // $('#new_quantity_surveyor').parsley().on('field:validated', function() {
    //     var ok = $('.parsley-error').length === 0;
    //     $('.bs-callout-info').toggleClass('hidden', !ok);
    //     $('.bs-callout-warning').toggleClass('hidden', ok);
    // });

    let input = $("#phone_number_input");
    input.intlTelInput({
        initialCountry: "gh",
        utilsScript: "/assets/libphonenumber/utils.js"
    });

    $("form").submit(function() {
        let intlNumber = input.intlTelInput("getNumber");
        $("#quantity_surveyor_phone_number").val(intlNumber);
    });
});