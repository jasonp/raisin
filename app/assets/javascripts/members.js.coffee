# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/



$ ->
  $("input[data-behavior='participant']").click ->
    $('#hidden_new_member_email_field').css "display", "inline"


$ ->
  $("input[data-behavior='nonparticipant']").click ->
    $('#hidden_new_member_email_field').css "display", "none"

$ ->
  $("a[data-member-explainer='this_link']").click ->
    $('#hidden_participating_explainer').toggle()
		