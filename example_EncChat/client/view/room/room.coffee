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

getFormattedDate = ->
  date = new Date
  str = date.getFullYear() + '-' + date.getMonth() + 1 + '-' + date.getDate() + ' ' + date.getHours() + ':' + date.getMinutes() + ':' + date.getSeconds()
  str


Template.room.events
  'click #invite': (evt) ->
    roomID = Meteor.user().Room.inRoomID
    invitee = $('#invite_user').val()
    inviteeID = Meteor.users.findOne({ username: invitee }, _id: 1)['_id']
    Rooms.update { _id: roomID }, $push: invitedID: inviteeID
    roomprinc (room_princ) ->
      Principal.lookupUser invitee, (princ) ->
        Principal.add_access princ, room_princ, ->
          $('#invite_user').val ''
  'click #sendMessage': (evt) ->
    msg = $('#messageTextArea').val()
    title = $('#roomtitle').text()
    creator = $('#roomcreator').text()
    roomprinc (room_princ) ->
      Messages.insert
        rID: Meteor.user().Room.inRoomID
        roomprinc: room_princ._id
        roomTitle: title
        message: msg
        userID: Meteor.userId()
        username: Meteor.user().username
        time: getFormattedDate()
      $('#messageTextArea').val ''
  'keypress #messageTextArea': (evt) ->
    if evt.keyCode is 13
      if evt.shiftKey is true
# new line
        true
      else
        msg = $('#messageTextArea').val()
        title = $('#roomtitle').text()
        creator = $('#roomcreator').text()
        #why do we need room creator here?
        roomprinc (room_princ) ->
          Messages.insert
            rID: Meteor.user().Room.inRoomID
            roomprinc: room_princ._id
            roomTitle: title
            message: msg
            userID: Meteor.userId()
            username: Meteor.user().username
            time: getFormattedDate()
          $('#messageTextArea').val ''
      false
  'click #exitRoom': (evt) ->
    roomID = $(evt.target).attr('roomId')
    if msg_handle
      msg_handle.stop()
    Meteor.call 'UpdateUserRoomInfoToOutside', roomID