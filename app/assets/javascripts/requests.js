$(document).on("turbolinks:load", function () {
    if ($(".requests.show").length === 0) return;

    Vue.component('message', {
        template: '#message-template',
        props: [ 'message' ]
    });

    var vm = new Vue({
        components: {
            message: 'message'
        },
        el: '#app',
        data: {
            request: {},
            error: {}
        },
        data2: {
            request: {
                name: "White County G4 Communication Tower",
                country: "Ghana",
                city: "Accra",
                deadline_date: '2017-08-20',
                deadline_time: '12:00:00',
                description: "This RFP is soliciting proposals from qualified contractors, preferably located within the aforementioned region, with demonstrated, relevant experience for all permitting, site development, preparation, erection and installation of small footprint, self supporting, guyed communication towers and related wireless communication equipment. Quotes should include the cost of purchase and installation of the related wireless radio communication equipment. Proposals must include guyed tower with the capability of accommodating the placement of four (4) single vertical antenna (tenant) spaces for communication equipment which includes the placement of four (4) 11’ microwave dishes. The entire project must be built to completion and billed no later than July 31. Successful proposals must acknowledge.'",
                newParticipant: { email: "", phoneNumber: "" },
                participants: [],
                billOfQuantities: {
                    name: "White County G4 Communication Tower",
                    pages: [
                        {
                            id: 1,
                            title: "Sub-Structure",
                            sections: [
                                {
                                    sectionName: "Materials",
                                    items: [
                                        { item: "A", description: "Supporting wires", unit: "pcs", quantity: 12.00, edit: false },
                                        { item: "B", description: "Fiber Optic Cable OP890", unit: "m", quantity: 560.00, edit: false },
                                        { item: "C", description: "Guyed Tower Sections (5m)", unit: "pcs", quantity: 7.00, edit: false },
                                        { item: "D", description: "Cable Protection Tube KP", unit: "m", quantity: 420.00, edit: false }
                                    ]
                                },
                                {
                                    sectionName: "Works",
                                    items: [
                                        { item: "A", description: "Tower Installation", unit: "set", quantity: 1.00, edit: false },
                                        { item: "B", description: "Antennas Installation", unit: "set", quantity: 1.00, edit: false },
                                        { item: "C", description: "Installation and Connection of Cables", unit: "set", quantity: 1.00, edit: false },
                                        { item: "D", description: "Measurements", unit: "set", quantity: 1.00, edit: false }
                                    ]
                                }
                            ]
                        },
                        {
                            id: 2,
                            title: "External Works",
                            sections: [
                                {
                                    sectionName: "Materials",
                                    items: [
                                        { item: "A", description: "Supporting wires", unit: "pcs", quantity: 12.00, edit: false },
                                        { item: "B", description: "Fiber Optic Cable OP890", unit: "m", quantity: 560.00, edit: false },
                                        { item: "C", description: "Guyed Tower Sections (5m)", unit: "pcs", quantity: 7.00, edit: false },
                                        { item: "D", description: "Cable Protection Tube KP", unit: "m", quantity: 420.00, edit: false }
                                    ]
                                },
                                {
                                    sectionName: "Works",
                                    items: [
                                        { item: "A", description: "Tower Installation", unit: "set", quantity: 1.00, edit: false },
                                        { item: "B", description: "Antennas Installation", unit: "set", quantity: 1.00, edit: false },
                                        { item: "C", description: "Installation and Connection of Cables", unit: "set", quantity: 1.00, edit: false },
                                        { item: "D", description: "Measurements", unit: "set", quantity: 1.00, edit: false }
                                    ]
                                }
                            ]
                        },
                        {
                            id: 3,
                            title: "Ground Floor",
                            sections: [
                                {
                                    sectionName: "Materials",
                                    items: [
                                        { item: "A", description: "Supporting wires", unit: "pcs", quantity: 12.00, edit: false },
                                        { item: "B", description: "Fiber Optic Cable OP890", unit: "m", quantity: 560.00, edit: false },
                                        { item: "C", description: "Guyed Tower Sections (5m)", unit: "pcs", quantity: 7.00, edit: false },
                                        { item: "D", description: "Cable Protection Tube KP", unit: "m", quantity: 420.00, edit: false }
                                    ]
                                },
                                {
                                    sectionName: "Works",
                                    items: [
                                        { item: "A", description: "Tower Installation", unit: "set", quantity: 1.00, edit: false },
                                        { item: "B", description: "Antennas Installation", unit: "set", quantity: 1.00, edit: false },
                                        { item: "C", description: "Installation and Connection of Cables", unit: "set", quantity: 1.00, edit: false },
                                        { item: "D", description: "Measurements", unit: "set", quantity: 1.00, edit: false }
                                    ]
                                }
                            ]
                        }
                    ]
                },
                publishing_setting: 'public',
                allow_alternative_bids: false,
                sealed_bids: false,
                preferred_currency: 'USD',
                expected_budget: 10000,
                messages: [
                    {
                        id: 1,
                        to: 'all',
                        from: 'me',
                        timestamp: 'Oct 07, 2017 14:5',
                        content: 'The bid total should not include VAT'
                    },
                    {
                        id: 2,
                        to: 'Bob Schmith Comply Ltd',
                        from: 'me',
                        timestamp: 'Aug 14, 2017 08:28',
                        content: 'No. The dishes have to be properly certified and comply with the network standards.'
                    },
                    {
                        id: 3,
                        to: 'me',
                        from: 'Bob Schmith Comply Ltd',
                        timestamp: 'Aug 14, 2017 08:27',
                        content: 'No. The dishes have to be properly certified and comply with the network standards.'
                    },
                    {
                        id: 4,
                        to: 'Morgan Cooper Morgan Supply Star Ltd.',
                        from: 'me',
                        timestamp: 'Aug 14, 2017 08:28',
                        content: 'Do you have any limitations regarding the manufacturer of the 4 microwave dishes?'
                    },
                    {
                        id: 4,
                        to: 'me',
                        from: 'Morgan Cooper Morgan Supply Star Ltd.',
                        timestamp: ' Aug 14, 2017 08:27',
                        content: 'Is it possible to see the site to get a better overview?'
                    }
                ]
            }
        },
        mounted: function () {
            var self = this;
            var requestId = $('#app').data('request_id');
            $.ajax({
                url: '/requests/'+ requestId + '.json',
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
            filteredMessages: function(messages, filterVariable) {
                return messages;
            },
            addParticipant: function(request, participant) {
                if (!participant.email && !participant.phoneNumber) return;
                console.log("Adding participant", participant);
                request.participants.unshift({ email: participant.email, phoneNumber: participant.phoneNumber });
                request.newParticipant.email = "";
                request.newParticipant.phoneNumber = "";
            },
            removeParticipant: function(participants, participant) {
                console.log("Removing participant", participant);
                var index = participants.indexOf(participant);
                if (index > -1) {
                    participants.splice(index, 1);
                }
            },

            addPage: function(billOfQuantities) {
                console.log("Adding new page");
                var emptyPage = {
                    title: 'Sheet1',
                    sections : [
                        {
                            sectionName: 'Section1',
                            items: [
                                { item: "", description: "", unit: "", quantity: "", edit: true }
                            ]
                        }
                    ]
                };
                billOfQuantities.pages.push( emptyPage );
                billOfQuantities.newPage = "";
            },
            removePage: function(billOfQuantities, page) {
                var goAhead = confirm("Do you really want to delete this entire page?");
                if (goAhead != true) return;

                console.log("Removing page", page);
                var index = billOfQuantities.pages.indexOf(page);
                if (index > -1) {
                    billOfQuantities.pages.splice(index, 1);
                }
            },

            addSection: function(page) {
                if (!page.newSection) return;
                console.log("Adding new section");
                var emptySection = { sectionName: page.newSection,
                    items: [
                        { item: "", description: "", unit: "", quantity: "", edit: true }
                    ]
                };
                page.sections.push( emptySection );
                page.newSection = "";
            },
            removeSection: function(page, section) {
                var goAhead = confirm("Do you really want to delete this entire section?");
                if (goAhead != true) return;

                console.log("Removing section", section);
                var index = page.sections.indexOf(section);
                if (index > -1) {
                    page.sections.splice(index, 1);
                }
            },

            addItem: function(section) {
                console.log("Adding new item");
                var emptyItem = { item: "", description: "", unit: "", quantity: "", edit: true };
                section.items.push( emptyItem );
            },
            removeItem: function(section, item) {
                console.log("Removing item", item);
                var index = section.items.indexOf(item);
                if (index > -1) {
                    section.items.splice(index, 1);
                }
            },

            deleteBillOfQuantities: function(billOfQuantities) {
                var goAhead = confirm("Do you really want to delete the entire bill of quantities?");
                if (goAhead != true) return;

                console.log("Deleting bill of quantities", billOfQuantities);
                billOfQuantities = null;
            },

            toggleEdit: function(ev, item){
                console.log("toggling")
                // item.$set('edit', !item.edit);
                item.edit = !item.edit;

                // Focus input field
                if(item.edit){
                    Vue.nextTick(function() {
                        console.log(ev);
                        ev.$refs.itemId.focus()
                    })
                }
            },
            saveEdit: function(ev, number){
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