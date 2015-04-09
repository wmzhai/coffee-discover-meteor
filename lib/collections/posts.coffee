@Posts = new Mongo.Collection 'posts'

Posts.allow
  update: (userId, post) -> ownsDocument(userId, post);
  remove: (userId, post) -> ownsDocument(userId, post);

Posts.deny
  update: (userId, post, fieldNames) ->
    _.without(fieldNames, 'url', 'title').length > 0

  update: (userId, post, fieldNames, modifier) ->
    errors = validatePost(modifier.$set)
    errors.title || errors.url

Meteor.methods
  postInsert : (postAttributes) ->
    check Meteor.userId(), String
    check postAttributes, {title : String, url : String}

    errors = validatePost(postAttributes)
    if (errors.title || errors.url)
      throw new Meteor.Error('invalid-post', "你必须为你的帖子填写标题和 URL")

    postWithSameLink = Posts.findOne({url:postAttributes.url});
    if postWithSameLink
      return postExists: true, _id: postWithSameLink._id

    user = Meteor.user()

    post = _.extend postAttributes , { userId : user._id, author : user.username, submitted : new Date()}

    postId = Posts.insert postAttributes

    _id : postId


@validatePost = (post) ->
  errors = {}
  if !post.title
    errors.title = "请填写标题"
  if !post.url
    errors.url = "请填写URL"
  return errors