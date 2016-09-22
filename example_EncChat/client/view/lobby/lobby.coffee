#LOBBY TEMPLATE

Template.lobby.onRendered ->
  room = Rooms.find({})
  room.forEach (room) ->
    $('.tooltip-' + room._id).tooltip trigger: 'click'
    #DELETE BUTTON SHOW
    if room.createdByID == Meteor.userId()
      $('#delete-' + room._id).show()
    else
      $('#delete-' + room._id).hide()

Template.lobby.helpers
  rooms: ->
    Rooms.find roomTitle: $ne: ''

  usersOnline: ->
    Meteor.users.find Online: true

CreateRoom = ->
  roomtitle = $('#roomTitleName').val().trim()
  if roomtitle.length != 0 and roomtitle.length >= 4 and roomtitle.length <= 16
    Principal.create 'room', roomtitle, Principal.user(), (rp) ->
      Rooms.insert
        roomTitle: roomtitle
        peopleID: []
        peopleUsername: []
        invitedID: []
        createdByID: Meteor.userId()
        roomprinc: rp._id
      $('#createRoomErroMsg').text ''
      $('#roomTitleName').val ''
      return
  else
    $('#createRoomErroMsg').text 'Please Fill in Field (Must contain at LEAST 4 and at MOST 16 Characters'
  return

Template.lobby.events
  'click #createRoomBtn': (evt) ->
    CreateRoom()
    false
  'keypress #roomTitleName': (evt) ->
    if evt.keyCode == 13
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
