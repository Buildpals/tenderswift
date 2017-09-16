//= require cable
//= require_self
//= require_tree .

this.App = {};

App.cable = ActionCable.createConsumer();

App.messages = App.cable.subscriptions.create('MessagesChannel', {  
  received: function(data) {
    //console.log(data);
    //check if the participant is part of the participants of the request for tender
    return $('#new-broadcast-messages').append(
      '<br/>'+
      '<div class="card">'+
      '   <div class="card-body">'+
      '    <h4 class="card-title"><span class="fa fa-bullhorn"></span></h4>'+
      '    <h6 class="card-subtitle mb-2 text-muted">All Participants</h6>'+
      '    <p class="card-text">'+data.message.content+'</p>'+
      '    <small class="float-right">'+
      '          <span class="fa fa-time"></span>'+data.formatted_date+
      '    </small>'+
      '   </div>'+
      '</div>'
    );
  },

  renderMessage: function(data) {
    return true;
  }
});