Template.postSubmit.events
  'submit form' : (e) ->
    e.preventDefault()

    post =
      url: $(e.target).find('[name=url]').val()
      title: $(e.target).find('[name=title]').val()


    Meteor.call 'postInsert', post, (error, result) ->
      if error
        return throwError error.reason

      if result.postExists
        throwError 'This link has already been posted'

      Router.go 'postsList'


