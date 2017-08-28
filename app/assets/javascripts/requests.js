function initAutosize() {
    var textarea = $('textarea#description');
    autosize(textarea);
    autosize.update(textarea);
}

$(document).on("turbolinks:load", function () {
    if ($(".requests.show").length === 0) return;

    Vue.component('message', {
        template: '#message-template',
        props: ['message']
    });

    window.app = new Vue({
        components: {
            message: 'message'
        },
        el: '#app',
        data: {
            requestForTender: {},
            newParticipant: {},
            showSavingSpinner: false
        },
        mounted: function () {
            var self = this;
            $.ajax({
                url: window.location.href + '.json',
                method: 'GET',
                success: function (data) {
                    self.requestForTender = data;
                    initAutosize();
                },
                error: function (error) {
                    console.error(error);
                }
            });
        },
        methods: {
            saveRequestForTender: function () {
                var self = this;
                console.log("Saving requestForTender...");
                $('#spinner').show();

                return $.ajax({
                    url: window.location.href + '.json',
                    method: 'PUT',
                    data: {
                        request: self.requestForTender
                    }})
                    .done(function (data) {
                        console.log("Saved requestForTender");
                        $('#spinner').hide();
                        console.log(data);
                        self.requestForTender = data;
                    }).fail(function (error) {
                        $('#spinner').hide();
                        console.error(error);
                    });
            },
            addParticipant: function (participant) {
                if (!participant.email && !participant.phone_number) return;
                var self = this;

                console.log("Adding participant...", participant);

                self.requestForTender.participants_attributes = [
                    {
                        email: participant.email,
                        phone_number: participant.phone_number,
                    }
                ];

                self.saveRequestForTender().done(function () {
                    console.log("Added participant", participant);
                    participant.email = "";
                    participant.phone_number = "";
                });
            },
            removeParticipant: function (participant) {
                var self = this;

                console.log("Removing participant...", participant);

                self.requestForTender.participants_attributes = [
                    {
                        id: participant.id,
                        email: participant.email,
                        phone_number: participant.phone_number,
                        _destroy: true
                    }
                ];

                self.saveRequestForTender().done(function () {
                    console.log("Removed participant")
                });
            },
            submitRequestForTender: function () {
                var self = this;

                console.log("Submitting requestForTender...");

                self.requestForTender.submitted = true;

                self.saveRequestForTender().done(function () {
                    console.log("Submitted requestForTender");
                });
            },
            moment: function() {
                return moment();
            }
        },
        filters: {
            capitalize: function (value) {
                if (!value) return '';
                value = value.toString();
                return value.charAt(0).toUpperCase() + value.slice(1)
            },
            moment: function (date) {
                return moment(date).format('MMM D, YYYY h:mm a');
            }
        }
    });


});