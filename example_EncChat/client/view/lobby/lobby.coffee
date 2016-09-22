#LOBBY TEMPLATE

Template.lobby.onRendered ->
  room = Rooms.find {}
  room.forEach (room) ->
    $(".tooltip-#{room._id}").tooltip trigger: 'click'
    #DELETE BUTTON SHOW
    if room.createdByID is Meteor.userId()
      $("#delete-#{room._id}").show()
    else
      $("#delete-#{room._id}").hide()

Template.lobby.helpers
  rooms: ->
    Rooms.find roomTitle: $ne: ''

  usersOnline: ->
    Meteor.users.find Online: true

CreateRoom = ->
  roomtitle = $('#roomTitleName').val().trim()
  if roomtitle.length != 0 and roomtitle.length >= 4 and roomtitle.length <= 16
    Principal.create 'room', roomtitle, Principal.user(), (rp) ->
      Meteor.call 'createRoom',
        roomTitle: roomtitle
        peopleID: []
        peopleUsername: []
        invitedID: []
        roomprinc: rp._id
      $('#createRoomErroMsg').text ''
      $('#roomTitleName').val ''
  else
    $('#createRoomErroMsg').text 'Please Fill in Field (Must contain at LEAST 4 and at MOST 16 Characters'

Template.lobby.events
  'click #createRoomBtn': (evt) ->
    CreateRoom()
    false
  'keypress #roomTitleName': (evt) ->
    if evt.keyCode is 13
      CreateRoom()
      false
  'click .joinRoom': (evt) ->
    joinRoom evt
  'click .deleteRoom': (evt) ->
    roomID = $(evt.target).attr('roomId')
    $('#deleteAlert-' + roomID).show 'slow'
  'click .cancelDelete': (evt) ->
    roomID = $(evt.target).attr('roomId')
    $('#deleteAlert-' + roomID).hide 'slow'
    #UPDATE USER WHEN JOINED ROOM
    #Meteor.call('UpdateUserRoomInfoToInside', roomID, roomTitle);
  'click .deleteConfirm': (evt) ->
    roomID = $(evt.target).attr('roomId')
    #DELETE ROOM
    Meteor.call 'DeleteRoom', roomID
