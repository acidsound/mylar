#HOME TEMPLATE
Template.home.helpers
  rooms: ->
    Rooms.find()
  user: ->
    Meteor.user()
  usersOnline: ->
    Meteor.users.find Online: true

Template.home.events
  'click #chatnowBtn': ->
    user = $('#username').val().trim()
    password = $('#password').val().trim()
    if user.length and password.length
      Accounts.createUser {
        username: user
        email: user
        password: password
      }, (error) ->
        if error
          $('#errorUsernameMsg').text error
    else
      $('#errorUsernameMsg').text 'Username and Password must be non empty.'
  'click #logoutBtn': ->
    #UPDATE USER COLLECTION ONLINE FALSE
    Meteor.call 'UpdateOnlineFalse'
    Meteor.logout()
    Session.set 'search_tag', undefined
    search_happened = false
