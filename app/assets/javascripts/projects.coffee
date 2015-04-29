# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ ->
  $("a[data-project-status='status_link']").click ->
    $('#hidden_settings_form').toggle()
    $(this).toggle()

$ ->
  $("a[data-edit-status-hide='hide_link']").click ->
    $('#hidden_settings_form').toggle()
    $("a[data-project-status='status_link']").toggle()

$ ->
  $("a[data-family-member='options_link']").click ->
    $('#edit_family_member_project').toggle()
    $(this).toggle()

$ ->
  $("a[data-family-options='hide_options_link']").click ->
    $('#edit_family_member_project').toggle()
    $("a[data-family-member='options_link']").toggle()

$ ->
  $("body").on 'click', '.submittable', (evt) ->
    $(this).parents('form:first').submit();