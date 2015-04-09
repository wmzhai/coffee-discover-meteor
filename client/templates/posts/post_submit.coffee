Template.postSubmit.created = ->
  Session.set 'postSubmitErrors', {}


Template.postSubmit.helpers
  errorMessage: (field) ->
    Session.get('postSubmitErrors')[field]
  errorClass: (field) ->
    if !!Session.get('postSubmitErrors')[field] then 'has-error' else ''


Template.postSubmit.events
  'submit form' : (e) ->
    e.preventDefault()

    post =
      url: $(e.target).find('[name=url]').val()
      title: $(e.target).find('[name=title]').val()


    errors = validatePost(post)
    if (errors.title || errors.url)
      return Session.set('postSubmitErrors', errors)


    Meteor.call 'postInsert', post, (error, result) ->
      if error
        return throwError error.reason

      if result.postExists
        throwError 'This link has already been posted'

      Router.go 'postsList'


