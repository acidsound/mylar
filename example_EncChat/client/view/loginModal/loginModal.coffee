Template.loginModal.events 'click #chatnowLoginBtn': (evt) ->
  console.log 'chat now'
  # login user
  username = $('#usernameLogin').val().trim()
  password = $('#passwordLogin').val().trim()
  Meteor.loginWithPassword email: username, password, (error) ->
    if error
      #alert("Failed to login");
      $('#loginErroMsg').text 'Warning: Incorrect Login: ' + error
    else
      #UPDATE USER COLLECTION ONLINE TRUE
      Meteor.call 'UpdateOnlineTrue'
      $('#usernameLogin').val ''
      $('#passwordLogin').val ''
      $('#loginErroMsg').text ''
      $('#loginModal').hide()
    return
  return

