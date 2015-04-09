Template.postSubmit.events
  'submit form' : (e) ->
    e.preventDefault()

    post =
      url: $(e.target).find('[name=url]').val()
      title: $(e.target).find('[name=title]').val()

    post._id = Posts.insert(post)

    #console.log post._id
    
    Router.go 'postPage', post


