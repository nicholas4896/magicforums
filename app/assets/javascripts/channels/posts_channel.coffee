postsChannelFunctions = () ->

  checkMe = (comment_id, username) ->
    unless $('meta[name=admin]').length > 0 || $("meta[user=#{username}]").length > 0
      $(".comment[data-id=#{comment_id}] .control-panel").remove()
    # $(".comment[data-id=#{comment_id}]").removeClass("hidden")

  createComment = (data) ->
    if $('#comment-partial-container').data().id == data.post.id
      $('#comments').append(data.partial)
      checkMe(data.comment.id)

  updateComment = (data) ->
    if $('#comment-partial-container').data().id == data.post.id
      $(".comment[data-id=#{data.comment.id}]").replaceWith(data.partial)
      checkMe(data.comment.id)

  destroyComment = (data) ->
    if $('#comment-partial-container').data().id == data.post.id
      $(".comment[data-id=#{data.comment.id}]").remove()
      checkMe(data.comment.id)

  if $('#comment-partial-container').length > 0
    App.posts_channel = App.cable.subscriptions.create {
      channel: "PostsChannel"
    },
    connected: () ->


    disconnected: () ->


    received: (data) ->
      if $('#comment-partial-container').data().id == data.post.id
        switch data.type
          when "create" then createComment(data)
          when "update" then updateComment(data)
          when "destroy" then destroyComment(data)

$(document).on 'turbolinks:load', postsChannelFunctions
