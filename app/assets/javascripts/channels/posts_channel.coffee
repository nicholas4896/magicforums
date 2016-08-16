postsChannelFunctions = () ->

  checkMe = (comment_id, username) ->
    unless $('meta[name=admin]').length > 0 || $("meta[user=#{username}]").length > 0
      $(".comment[data-id=#{comment_id}] .control-panel").remove()
    console.log("checkme:" + comment_id)
    $(".comment[data-id=#{comment_id}]").removeClass("hidden")

  if $('#comment-partial-container').length > 0
    App.posts_channel = App.cable.subscriptions.create {
      channel: "PostsChannel"
    },
    connected: () ->
      #console.log("user logged in");

    disconnected: () ->
      #console.log("user logged out");

    received: (data) ->
      if $('#comment-partial-container').data().id == data.post.id
        $('#comments').append(data.partial)
        checkMe(data.comment.id, data.username)

$(document).on 'turbolinks:load', postsChannelFunctions
