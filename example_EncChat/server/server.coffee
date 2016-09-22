#//////// Server only logic //////////
Meteor.startup ->
  Meteor.publish 'oneUser', ->
    Meteor.users.find @userId, fields: {}

Rooms.allow
  insert: (userId, doc) ->
    true
  update: (userId, doc, fields, modifier) ->
    doc.createdByID is userId
  remove: (userId, doc) ->
    doc.createdByID is userId
Messages.allow
  insert: (userId, doc) ->
    room = Rooms.findOne(_id: doc.rID)
    room.createdByID is userId or _.contains(room.invitedID, userId)
  update: (userId, doc, fields, modifier) ->
    true
  remove: (userId, doc) ->
    false

filter = (userID) ->
# create a list of all the rooms this user has access to
  rooms = Rooms.find $or: [
    createdByID: userID
    invitedID: userID
  ]
  .fetch()
  rooms.map (room)->
    rID: room._id

if search_loaded()
  Messages.publish_search_filter 'search-messages-of-userid', filter

# publish
Meteor.publish 'rooms', ->
  Rooms.find $or: [
    invitedID: @userId
    createdByID: @userId
  ]
Meteor.publish 'messages', (roomID) ->
  Messages.find rID: roomID
Meteor.publish 'allUsers', ->
  Meteor.users.find {}, fields: {}

# accounts
Accounts.onCreateUser (options, user) ->
  user.Room =
    'inRoom': false
    'inRoomID': ''
    'inRoomTitle': ''
  user.Online = true
  # We still want the default hook's 'profile' behavior.
  if options.profile
    user.profile = options.profile
  user

Meteor.methods
  UpdateUserRoomInfoToInside: (roomID, roomTitle) ->
    roomCreator = Rooms.findOne(_id: roomID)?.createdByID
    roomCreator = Meteor.users.findOne(_id: roomCreator)?.username
    Meteor.users.update _id: @userId(),
      $set: Room:
        'inRoom': true
        'inRoomID': roomID
        'inRoomTitle': roomTitle
        'inRoomCreator': roomCreator
    Rooms.update _id: roomID,
      $push:
        peopleID: @userId()
        peopleUsername: Meteor.user().username
  UpdateUserRoomInfoToOutside: (roomID) ->
    Meteor.users.update _id: @userId(),
      $set:
        Room:
          'inRoomID': ''
          'inRoomTitle': ''
          'inRoom': false
    Rooms.update _id: roomID,
      $pull:
        peopleID: @userId()
        peopleUsername: Meteor.user().username
  CreateRoom: ({roomTitle, roomprinc, peopleID, peopleUsername, invitedID})->
    Rooms.insert
      roomTitle: roomTitle
      peopleID: peopleID
      peopleUsername: peopleUsername
      invitedID: invitedID
      createdByID: @userId()
      roomprinc: roomprinc
  CreateMessage: ({roomprinc, roomTitle, message})->
    Messages.insert
      rID: Meteor.user().Room.inRoomID
      roomprinc: roomprinc
      roomTitle: roomTitle
      message: message
      userID: @userId()
      username: Meteor.user().username
      time: getFormattedDate()

  UpdateRoomAddInvitee: (roomID, inviteeID)->
    Rooms.update { _id: roomID }, $push: invitedID: inviteeID
  DeleteRoom: (roomID) ->
    Rooms.remove _id: roomID
    Messages.remove rID: roomID
    return
  UpdateOnlineFalse: ->
    Meteor.users.update _id: @userId(), $set: Online: false
    return
  UpdateOnlineTrue: ->
    Meteor.users.update _id: @userId(), $set: Online: true
    return
