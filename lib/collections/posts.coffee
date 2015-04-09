@Posts = new Mongo.Collection 'posts'


Meteor.methods
  postInsert : (postAttribute) ->
    check Meteor.userId(), String
    check postAttribute, {title : String, url : String}

    postWithSameLink = Posts.findOne({url:postAttribute.url});
    if postWithSameLink
      return postExists: true, _id: postWithSameLink._id

    user = Meteor.user()

    post = _.extend postAttribute , { userId : user._id, author : user.username, submitted : new Date()}

    postId = Posts.insert postAttribute

    _id : postId