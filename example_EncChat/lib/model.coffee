#//////// Shared code (client and server) //////////
@Rooms = new (Meteor.Collection)('rooms')

###  roomTitle
 peopleID
 peopleUsername: creator username
 invitedID : list of ids of users invited to this room
 createdByID: user id creator
###

@Messages = new (Meteor.Collection)('messages')

### rID: room id,
 roomprinc
 message,
 userID: id of user sender,
 username: username of sender,
 time: time when message was sent
###

# returns true if search package loaded

@search_loaded = ->
  typeof MYLAR_USE_SEARCH != 'undefined'

@Messages._encrypted_fields 'message':
  princ: 'roomprinc'
  princtype: 'room'
  auth: [ '_id' ]
@Messages._immutable roomprinc: [
  'rID'
  'roomTitle'
  '_id'
]
# important for the IDP, so it get the _wrapped_pk fields of the user doc

### trusted IDP: ###

#var idp_pub = '8a7fe03431b5fc2db3923a2ab6d1a5ddf35cd64aea35e743' +
#              'ded7655f0dc7e085858eeec06e1c7da58c509d57da56dbe6';
#idp_init("http://localhost:3000", idp_pub, false);
# use IDP only if active attacker
Accounts.config sendVerificationEmail: active_attacker()

@getFormattedDate = ->
  date = new Date
  str = date.getFullYear() + '-' + date.getMonth() + 1 + '-' + date.getDate() + ' ' + date.getHours() + ':' + date.getMinutes() + ':' + date.getSeconds()
  str
