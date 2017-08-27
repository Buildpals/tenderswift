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
            request: {},
            newParticipant: {},
            error: {},
            showSavingSpinner: false
        },
        mounted: function () {
            var self = this;
            var requestId = $('#app').data('request_id');
            $.ajax({
                url: '/requests/' + requestId + '.json',
                method: 'GET',
                success: function (data) {
                    console.log(data);
                    self.request = { data };
                    var textarea = $('textarea#description');
                    autosize(textarea);
                    autosize.update(textarea);
                },
                error: function (error) {
                    console.log(error);
                    self.error = error;
                }
            });
        },
        methods: {
            saveRequest: function () {
                console.log("Saving request...");
                $('#spinner').show();
                $("#request-form").trigger('submit.rails');
            },
            addParticipant: function (request, participant) {
                if (!participant.email && !participant.phone_number) return;

                console.log("Adding participant", participant);
                $('#spinner').show();

                $.ajax({
                    url: '/participants.json',
                    method: 'POST',
                    data: {
                        participant: {
                            email: participant.email,
                            phone_number: participant.phone_number,
                            request_id: request.id
                        }
                    },
                    success: function (data) {
                        console.log(data);

                        request.participants.unshift(data);

                        participant.email = "";
                        participant.phone_number = "";
                    },
                    error: function (error) {
                        console.log(error);
                        self.error = error;
                    }
                });
            },
            removeParticipant: function (participants, participant) {
                console.log("Removing participant", participant);
                var index = participants.indexOf(participant);
                if (index > -1) {
                    participants.splice(index, 1);
                }
            }
        },
        filters: {
            capitalize: function (value) {
                if (!value) return '';
                value = value.toString();
                return value.charAt(0).toUpperCase() + value.slice(1)
            }
        }
    });


});