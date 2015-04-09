@Posts = new Mongo.Collection 'posts'


Meteor.methods
  postInsert : (postAttribute) ->
    check Meteor.userId(), String
    check postAttribute, {title : String, url : String}

    user = Meteor.user()

    post = _.extend postAttribute , { userId : user._id, author : user.username, submitted : new Date()}

    postId = Posts.insert postAttribute

    _id : postId