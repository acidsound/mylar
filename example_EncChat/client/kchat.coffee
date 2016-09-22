debug = false

@roomprinc = (cb) ->
  u = Meteor.user()
  if u and u.Room and u.Room.inRoom
    room = u.Room
    Principal.lookup [ new PrincAttr('room', room.inRoomTitle) ], room.inRoomCreator, (room_princ) ->
      cb room_princ
      return
  else
    throw new Error('no user,room or in room ')
  return

@joinRoom = (evt) ->
  roomID = $(evt.target).attr('roomId')
  msg_handle = Meteor.subscribe('messages', roomID, ->
    roomTitle = $(evt.target).attr('roomTitle')
    #TODO: display creator to users
    roomCreatorID = Rooms.findOne(
      _id: roomID
      roomTitle: roomTitle)['createdByID']
    creator = Meteor.users.findOne(_id: roomCreatorID)['username']
    if debug
      console.log 'join room ' + roomTitle + ' with creator ' + creator
    #UPDATE USER WHEN JOINED ROOM
    Meteor.call 'UpdateUserRoomInfoToInside', roomID, roomTitle
    return
  )
  return

#FUNCTIONS

msg_handle = undefined
window.jsErrors = []

window.onerror = ->
  window.jsErrors[window.jsErrors.length] = arguments
  return


postSearchResults = (search_res) ->
  console.log 'post search results'
  $('#search_word').val ''
  return

Tracker.autorun ->
  Meteor.subscribe 'rooms'
  Meteor.subscribe 'users'
  return
