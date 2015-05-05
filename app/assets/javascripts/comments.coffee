# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("body").on 'click', '#cancel_edit_comment_link', (evt) ->
    commentId = $(this).data("comment-id")
    editDiv = "#edit_comment_content-" + commentId
    contentDiv = "#comment_content-" + commentId
    $(editDiv).toggle()
    $(contentDiv).toggle()

$ ->
  $("body").on 'click', '#show_edit_comment_form_link', (evt) ->
    commentId = $(this).data("comment-id")
    editDiv = "#edit_comment_content-" + commentId
    contentDiv = "#comment_content-" + commentId
    $(editDiv).show()
    $(contentDiv).hide()