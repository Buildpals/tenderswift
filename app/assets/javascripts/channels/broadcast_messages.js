//= require cable
//= require_self
//= require_tree .

this.App = {};

App.cable = ActionCable.createConsumer();

App.messages = App.cable.subscriptions.create('BroadcastMessagesChannel', {  
  received: function(data) {
    console.log(data);
    var current_request_id = parseInt($(".hidden-request-id").text());
    if(current_request_id === parseInt(data.request_for_tender_id)){
          //check if the participant is part of the participants of the request for tender
        return $('.new-broadcast-messages').append(
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
      }
      else{ return true }
    }
});