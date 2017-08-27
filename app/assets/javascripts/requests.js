$(document).on("turbolinks:load", function () {
    if ($(".requests.show").length === 0) return;

    Vue.component('message', {
        template: '#message-template',
        props: ['message']
    });

    var vm = new Vue({
        components: {
            message: 'message'
        },
        el: '#app',
        data: {
            request: {},
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
                    self.request = data;
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
            saveRequest: function (request) {
                console.log("Saving request", request);
                console.log(self.showSavingSpinner);
                self.showSavingSpinner = true;

                $.ajax({
                    url: "/requests/" + request.id + ".json",
                    method: 'PUT',
                    data: {
                        authenticity_token: window._token,
                        request: request
                    },
                    success: function (data) {
                        console.log("Request updated", data);
                        self.showSavingSpinner = false;
                    },
                    error: function (error) {
                        console.error(error);
                        self.error = error;
                        self.showSavingSpinner = false;
                    }
                });
            },
            filteredMessages: function (messages, filterVariable) {
                return messages;
            },
            addParticipant: function (request, participant) {
                if (!participant.email && !participant.phoneNumber) return;
                console.log("Adding participant", participant);
                request.participants.unshift({email: participant.email, phoneNumber: participant.phoneNumber});
                request.newParticipant.email = "";
                request.newParticipant.phoneNumber = "";
            },
            removeParticipant: function (participants, participant) {
                console.log("Removing participant", participant);
                var index = participants.indexOf(participant);
                if (index > -1) {
                    participants.splice(index, 1);
                }
            },

            addPage: function (billOfQuantities) {
                console.log("Adding new page");
                var emptyPage = {
                    title: 'Sheet1',
                    sections: [
                        {
                            sectionName: 'Section1',
                            items: [
                                {item: "", description: "", unit: "", quantity: "", edit: true}
                            ]
                        }
                    ]
                };
                billOfQuantities.pages.push(emptyPage);
                billOfQuantities.newPage = "";
            },
            removePage: function (billOfQuantities, page) {
                var goAhead = confirm("Do you really want to delete this entire page?");
                if (goAhead != true) return;

                console.log("Removing page", page);
                var index = billOfQuantities.pages.indexOf(page);
                if (index > -1) {
                    billOfQuantities.pages.splice(index, 1);
                }
            },

            addSection: function (page) {
                if (!page.newSection) return;
                console.log("Adding new section");
                var emptySection = {
                    sectionName: page.newSection,
                    items: [
                        {item: "", description: "", unit: "", quantity: "", edit: true}
                    ]
                };
                page.sections.push(emptySection);
                page.newSection = "";
            },
            removeSection: function (page, section) {
                var goAhead = confirm("Do you really want to delete this entire section?");
                if (goAhead != true) return;

                console.log("Removing section", section);
                var index = page.sections.indexOf(section);
                if (index > -1) {
                    page.sections.splice(index, 1);
                }
            },

            addItem: function (section) {
                console.log("Adding new item");
                var emptyItem = {item: "", description: "", unit: "", quantity: "", edit: true};
                section.items.push(emptyItem);
            },
            removeItem: function (section, item) {
                console.log("Removing item", item);
                var index = section.items.indexOf(item);
                if (index > -1) {
                    section.items.splice(index, 1);
                }
            },

            deleteBillOfQuantities: function (billOfQuantities) {
                var goAhead = confirm("Do you really want to delete the entire bill of quantities?");
                if (goAhead != true) return;

                console.log("Deleting bill of quantities", billOfQuantities);
                billOfQuantities = null;
            },

            toggleEdit: function (ev, item) {
                console.log("toggling")
                // item.$set('edit', !item.edit);
                item.edit = !item.edit;

                // Focus input field
                if (item.edit) {
                    Vue.nextTick(function () {
                        console.log(ev);
                        ev.$refs.itemId.focus()
                    })
                }
            },
            saveEdit: function (ev, number) {
                //save your changes
                this.toggleEdit(ev, number);
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