Template.room.onRendered ->
  #Scroll the msglog All the way to the end
  elem = document.getElementById('msgLog')
  elem.scrollTop = elem.scrollHeight

Template.room.helpers
  user: ->
    Meteor.user()
  peopleInRoom: ->
    Rooms.findOne _id: Meteor.user().Room.inRoomID
  messageCount: ->
    Messages.find rID: Meteor.user().Room.inRoomID

Template.room.events
  'click #invite': ->
    roomID = Meteor.user().Room.inRoomID
    invitee = $('#invite_user').val()
    inviteeID = Meteor.users.findOne( username: invitee, _id: 1)?._id
    Meteor.call 'UpdateRoomAddInvitee', roomID, inviteeID
    roomprinc (room_princ) ->
      Principal.lookupUser invitee, (princ) ->
        Principal.add_access princ, room_princ, ->
          $('#invite_user').val ''
  'click #sendMessage': ->
    msg = $('#messageTextArea').val()
    title = $('#roomtitle').text()
    creator = $('#roomcreator').text()
    roomprinc (room_princ) ->
      Meteor.call "CreateMessage",
        roomprinc: room_princ._id
        roomTitle: title
        message: msg
      $('#messageTextArea').val ''
  'keypress #messageTextArea': (evt) ->
    if evt.keyCode is 13
      if evt.shiftKey is true
        # new line
        true
      else
        msg = $('#messageTextArea').val()
        title = $('#roomtitle').text()
        roomprinc (room_princ) ->
          Meteor.call "CreateMessage",
            roomprinc: room_princ._id
            roomTitle: title
            message: msg
          $('#messageTextArea').val ''
      false
  'click #exitRoom': (evt) ->
    roomID = $(evt.target).attr('roomId')
    if msg_handle
      msg_handle.stop()
    Meteor.call 'UpdateUserRoomInfoToOutside', roomID