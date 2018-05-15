$(document).on("turbolinks:load", function () {
    if ($(".registrations.new, .quantity_surveyors.edit, .contractors.edit").length === 0) return;

    let input = $("#phone_number_input");
    input.intlTelInput({
        initialCountry: "gh",
        utilsScript: "/assets/libphonenumber/utils.js"
    });

    $("form").submit(function() {
        let intlNumber = input.intlTelInput("getNumber");
        $("#quantity_surveyor_phone_number").val(intlNumber);
        $("#contractor_phone_number").val(intlNumber);
    });
});