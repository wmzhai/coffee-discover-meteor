@Posts = new Mongo.Collection 'posts'

Posts.allow
  update: (userId, post) -> ownsDocument(userId, post);
  remove: (userId, post) -> ownsDocument(userId, post);

Posts.deny
  update: (userId, post, fieldNames) ->
    _.without(fieldNames, 'url', 'title').length > 0


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


@validatePost = (post) ->
  errors = {}
  if !post.title
    errors.title = "请填写标题"
  if !post.url
    errors.url = "请填写URL"
  return errors