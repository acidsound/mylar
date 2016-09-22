###******* SEARCH TEMPLATES *********###

search_happened = false

Template.searcharea.helpers
  searchHappened: ->
    search_happened
  resCount: ->
    searchResCount()
  hasResults: ->
    searchResCount() > 0

Template.searcharea.helpers
  rooms: ->
    search_tag = Session.get('search_tag')
    unless search_tag
      Messages.find _tag: 'nothing'
    else
      Messages.find _tag: search_tag

###**************************************###
searchResCount = ->
  search_tag = Session.get('search_tag')
  if !search_tag
    return 0
  Messages.find(_tag: search_tag).count()

Template.searcharea.events
  'click #search': ->
    unless search_loaded()
      if typeof Android == 'undefined'
        alert 'You don\'t have search turned on. Follow instructions in README to turn it on.'
      else
        Android.showPretty 'You don\'t have search turn on. Instructions for search in Android coming soon!'
    word = $('#search_word').val()
    search_happened = true
    userprinc = Principal.user()
    Messages.search 'search-messages-of-userid', { 'message': word }, userprinc, Meteor.userId(), postSearchResults
  'click .joinRoom': (evt) ->
    joinRoom evt
