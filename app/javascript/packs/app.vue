<template>
    <div id="app">

        <div class="row">
            <div class="form-group col-sm-6">
                <label for="name">Name</label>
                <input type="text" class="form-control" id="name"
                       placeholder="e.g. Construction of 2 story building"
                       v-model="request.name">
                <p class="text-muted">
                    Example: Purchases of office supplies; Construction of sawmill;
                    Railroad engineering works;
                  </p>
            </div>
            <div class="form-group col-sm-6">
                <div class="row">
                    <div class="col-sm-6">
                        <label for="deadline_date">Deadline</label>
                        <input type="date" class="form-control" id="deadline_date"
                               v-model="request.deadline_date">
                    </div>
                    <div class="col-sm-6">
                        <label for="deadline_time">&nbsp;</label>
                        <input type="time" class="form-control" id="deadline_time"
                               v-model="request.deadline_time">
                    </div>
                    <div class="col-sm-12">
                        <p class="text-muted">
                            Deadline for suppliers to submit their bids.
                            Timezone: Accra, Africa (UTC+00:00)
                          </p>
                    </div>
                </div>
            </div>

            <div class="form-group col-sm-6">
                <label for="country">Country</label>
                <input type="text" class="form-control" id="country"
                       v-model="request.country">
            </div>

            <div class="form-group col-sm-6">
                <label for="city">City</label>
                <input type="text" class="form-control" id="city"
                       v-model="request.city">
            </div>

            <div class="form-group col-sm-12">
                <label for="description">Description</label>
                <textarea id="description" class="form-control" rows="8"
                          v-model="request.description"></textarea>
            </div>
        </div>

        <div class="row">
            <div class="col-sm-12 page-header">
                <h4>Add Bill Of Quantities</h4>
            </div>
            <div class="col-sm-5 text-center">
                <a href='/bill_of_quantities' class='btn btn-sm btn-primary'>
                    Create Bill Of Quantities
                  </a>
            </div>
            <div class="col-sm-7">
                <p class="text-muted">
                    Create a bill of quantities online.
                    It's faster than you can ever create it in Excel.
                    In addition all the submitted tenders from contractors will be automatically compared
                    and the best one will be highlighted.
                  </p>
            </div>
        </div>

        <div class="row">
            <div class="col-sm-12 page-header">
                <h4>
                    Add Questionnaire
                    <small>(Optional)</small>
                </h4>
            </div>
            <div class="col-sm-5 text-center">
                <button type="button" class="btn btn-sm btn-primary" data-toggle="modal"
                        data-target="#questionnaire">
                    Create Questionnaire
                  </button>
            </div>
            <div class="col-sm-7">
                <p class="text-muted">
                    Create a set of questions that all contractors are required to answer.
                    Their answers will be automatically comparable.
                  </p>
            </div>
        </div>

        <div class="row">
            <div class="col-sm-12 page-header">
                <h4>Attach documents</h4>
            </div>
            <div class="form-group col-sm-5 text-center">
                <a href="#" id="upload_widget_opener" class="btn btn-sm btn-primary">Upload documents</a>
            </div>
            <div class="col-sm-7">
                <h5>Added Documents</h5>
                <div class="row">
                    <div class="col-sm-9">
                        <div class="label label-warning">
                            Project of Construction of Communication Tower.pdf
                          </div>
                    </div>
                    <div class="col-sm-3">
                        <div class="label label-warning">Replace</div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-9">
                        <div class="label label-warning">
                            Specification of Materials.pdf
                          </div>
                    </div>
                    <div class="col-sm-3">
                        <div class="label label-warning">Replace</div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-9">
                        <div class="label label-warning">
                            Network Plans.pdf
                          </div>
                    </div>
                    <div class="col-sm-3">
                        <div class="label label-warning">Replace</div>
                    </div>
                </div>

            </div>
        </div>

        <div class="row">
            <div class="col-sm-12 page-header">
                <h4>Enter contacts of the participants</h4>
            </div>

            <div class="col-sm-12 form-horizontal">
                <div class="form-group">
                    <div class="col-sm-5">
                        <input type="email" class="form-control" id="email" placeholder="email"
                               v-model="request.newParticipant.email">
                    </div>
                    <div class="col-sm-4">
                        <input type="phone" class="form-control" id="phone_number" placeholder="phone number"
                               v-model="request.newParticipant.phoneNumber">
                    </div>
                    <div class="col-sm-2">
                        <button class="btn btn-default" type="button"
                                v-on:click="addParticipant(request, request.newParticipant)">Add participant
            </button>
                    </div>
                </div>
                <br>
            </div>


            <div class="col-sm-12">
                <h5>Participants</h5>
                <ul class="list-group">
                    <li class="list-group-item" v-for="participant in request.participants">
                        <button type="button" class="btn btn-link btn-xs btn-default"
                                v-on:click="removeParticipant(request.participants, participant)">
                            <span aria-hidden="true" class="glyphicon glyphicon-remove"></span>
                        </button>

                        {{participant.email}} -
            {{participant.phoneNumber}}
          </li>
                </ul>
            </div>
        </div>

        <div class="row">
            <div class="col-sm-12 page-header">
                <h4>Please choose publishing settings for the request</h4>
            </div>

            <div class="col-sm-12 text-center">
                <label class="radio-inline">
                    <input type="radio" name="publishing_setting" id="publishing_setting1" value="public"
                           v-model="request.publishing_setting">
                    Public request
                  </label>
                <label class="radio-inline">
                    <input type="radio" name="publishing_setting" id="publishing_setting2" value="restricted_public"
                           v-model="request.publishing_setting">
                    Restricted public request
                  </label>
                <label class="radio-inline">
                    <input type="radio" name="publishing_setting" id="publishing_setting3" value="private"
                           v-model="request.publishing_setting">
                    Private request
                  </label>
            </div>
        </div>

        <div class="row">
            <div class="col-sm-12 page-header">
                <h4>A little bit more</h4>
            </div>
            <div class="form-group col-sm-4">
                <label for="preferred_currency">Preferred Currency*</label>
                <select class="form-control" id="preferred_currency" v-model="request.preferred_currency">
                    <option value="USD">USD - United States dollar</option>
                    <option value="GHS">GHS - Ghanaian Cedi</option>
                </select>
            </div>
            <div class="form-group col-sm-6">
                <label for="expected_budget">Expected Budget*</label>
                <input type="number" class="form-control" id="expected_budget" v-model="request.expected_budget">
            </div>
        </div>

        <br>
        <br>

        <div class="row">
            <div class="col-md-12">
                <a href='/show' class='btn btn-success btn-lg pull-right'>Submit</a>
            </div>
        </div>
    </div>
</template>

<script>
    export default {
        data: function () {
            return {
                request: {
                    name: "White County G4 Communication Tower",
                    country: "Ghana",
                    city: "Accra",
                    deadline_date: '2017-08-20',
                    deadline_time: '12:00:00',
                    description: "This RFP is soliciting proposals from qualified contractors, preferably located within the aforementioned region, with demonstrated, relevant experience for all permitting, site development, preparation, erection and installation of small footprint, self supporting, guyed communication towers and related wireless communication equipment. Quotes should include the cost of purchase and installation of the related wireless radio communication equipment. Proposals must include guyed tower with the capability of accommodating the placement of four (4) single vertical antenna (tenant) spaces for communication equipment which includes the placement of four (4) 11’ microwave dishes. The entire project must be built to completion and billed no later than July 31. Successful proposals must acknowledge.'",
                    newParticipant: {email: "", phoneNumber: ""},
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
                                            {
                                                item: "A",
                                                description: "Supporting wires",
                                                unit: "pcs",
                                                quantity: 12.00,
                                                edit: false
                                            },
                                            {
                                                item: "B",
                                                description: "Fiber Optic Cable OP890",
                                                unit: "m",
                                                quantity: 560.00,
                                                edit: false
                                            },
                                            {
                                                item: "C",
                                                description: "Guyed Tower Sections (5m)",
                                                unit: "pcs",
                                                quantity: 7.00,
                                                edit: false
                                            },
                                            {
                                                item: "D",
                                                description: "Cable Protection Tube KP",
                                                unit: "m",
                                                quantity: 420.00,
                                                edit: false
                                            }
                                        ]
                                    },
                                    {
                                        sectionName: "Works",
                                        items: [
                                            {
                                                item: "A",
                                                description: "Tower Installation",
                                                unit: "set",
                                                quantity: 1.00,
                                                edit: false
                                            },
                                            {
                                                item: "B",
                                                description: "Antennas Installation",
                                                unit: "set",
                                                quantity: 1.00,
                                                edit: false
                                            },
                                            {
                                                item: "C",
                                                description: "Installation and Connection of Cables",
                                                unit: "set",
                                                quantity: 1.00,
                                                edit: false
                                            },
                                            {
                                                item: "D",
                                                description: "Measurements",
                                                unit: "set",
                                                quantity: 1.00,
                                                edit: false
                                            }
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
                                            {
                                                item: "A",
                                                description: "Supporting wires",
                                                unit: "pcs",
                                                quantity: 12.00,
                                                edit: false
                                            },
                                            {
                                                item: "B",
                                                description: "Fiber Optic Cable OP890",
                                                unit: "m",
                                                quantity: 560.00,
                                                edit: false
                                            },
                                            {
                                                item: "C",
                                                description: "Guyed Tower Sections (5m)",
                                                unit: "pcs",
                                                quantity: 7.00,
                                                edit: false
                                            },
                                            {
                                                item: "D",
                                                description: "Cable Protection Tube KP",
                                                unit: "m",
                                                quantity: 420.00,
                                                edit: false
                                            }
                                        ]
                                    },
                                    {
                                        sectionName: "Works",
                                        items: [
                                            {
                                                item: "A",
                                                description: "Tower Installation",
                                                unit: "set",
                                                quantity: 1.00,
                                                edit: false
                                            },
                                            {
                                                item: "B",
                                                description: "Antennas Installation",
                                                unit: "set",
                                                quantity: 1.00,
                                                edit: false
                                            },
                                            {
                                                item: "C",
                                                description: "Installation and Connection of Cables",
                                                unit: "set",
                                                quantity: 1.00,
                                                edit: false
                                            },
                                            {
                                                item: "D",
                                                description: "Measurements",
                                                unit: "set",
                                                quantity: 1.00,
                                                edit: false
                                            }
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
                                            {
                                                item: "A",
                                                description: "Supporting wires",
                                                unit: "pcs",
                                                quantity: 12.00,
                                                edit: false
                                            },
                                            {
                                                item: "B",
                                                description: "Fiber Optic Cable OP890",
                                                unit: "m",
                                                quantity: 560.00,
                                                edit: false
                                            },
                                            {
                                                item: "C",
                                                description: "Guyed Tower Sections (5m)",
                                                unit: "pcs",
                                                quantity: 7.00,
                                                edit: false
                                            },
                                            {
                                                item: "D",
                                                description: "Cable Protection Tube KP",
                                                unit: "m",
                                                quantity: 420.00,
                                                edit: false
                                            }
                                        ]
                                    },
                                    {
                                        sectionName: "Works",
                                        items: [
                                            {
                                                item: "A",
                                                description: "Tower Installation",
                                                unit: "set",
                                                quantity: 1.00,
                                                edit: false
                                            },
                                            {
                                                item: "B",
                                                description: "Antennas Installation",
                                                unit: "set",
                                                quantity: 1.00,
                                                edit: false
                                            },
                                            {
                                                item: "C",
                                                description: "Installation and Connection of Cables",
                                                unit: "set",
                                                quantity: 1.00,
                                                edit: false
                                            },
                                            {
                                                item: "D",
                                                description: "Measurements",
                                                unit: "set",
                                                quantity: 1.00,
                                                edit: false
                                            }
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
            }
        },
        methods: {
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
    }
</script>

<style scoped>
    p {
        font-size: 2em;
        text-align: center;
    }
</style>
