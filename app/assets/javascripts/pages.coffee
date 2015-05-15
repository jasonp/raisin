# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

makeQuill = (element) ->
  quill = new Quill '#new_comment_editor', modules:
      'toolbar': container: '#toolbar'
      'link-tooltip': true

  $("body").on 'reloadQuill', (evt) ->
    quill = new Quill '#new_comment_editor', modules:
      'toolbar': container: '#toolbar'
      'link-tooltip': true

  quill.on 'text-change', (delta, source) ->
    if source is 'user'
      html = quill.getHTML()
      $("#comment_area").val(html)

  $("body").on 'reloadQuill', (evt) ->
    quill.on 'text-change', (delta, source) ->
      if source is 'user'
        html = quill.getHTML()
        $("#comment_area").val(html)


$ ->  
  element = $('#new_comment_editor')
  makeQuill(element) if element.val()?

