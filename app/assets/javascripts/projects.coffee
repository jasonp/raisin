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

$ ->
  $("body").on 'click', '#edit_list_title_link', (evt) ->
    listId = $(this).data("list-id")
    editDiv = "#todo_list_edit_title_form-" + listId
    titleDiv = "#todo_list_existing_title-" + listId
    $(editDiv).fadeToggle()
    $(titleDiv).toggle()

$ ->
  $("body").on 'click', '#cancel_edit_title_link', (evt) ->
    listId = $(this).data("list-id")
    editDiv = "#todo_list_edit_title_form-" + listId
    titleDiv = "#todo_list_existing_title-" + listId
    $(editDiv).toggle()
    $(titleDiv).toggle()

$ ->
  $("body").on 'click', '#cancel_edit_item_link', (evt) ->
    itemId = $(this).data("item-id")
    editDiv = "#update_list_item_form-" + itemId
    titleDiv = "#list_item_actionable-" + itemId
    $(editDiv).toggle()
    $(titleDiv).toggle()

$ ->
  $("body").on 'click', '#show_edit_item_form_link', (evt) ->
    itemId = $(this).data("item-id")
    editDiv = "#update_list_item_form-" + itemId
    titleDiv = "#list_item_actionable-" + itemId
    $(editDiv).toggle()
    $(titleDiv).toggle()
    $("body").trigger('loadDatePicker')

$ -> 
  $("body").on 'click', '#edit_project_headline_link', (evt) ->
    $("#project_headline").toggle()
    $("#edit_project_headline_form").toggle()
    $("#page_top_collab_invite").toggle()

$ ->
  $("body").on 'click', '#cancel_edit_project_headline_link', (evt) ->
    $('#project_headline').toggle()
    $('#edit_project_headline_form').toggle()
    $('#page_top_collab_invite').toggle()

$ ->
	$("body").on 'loadDatePicker', (evt) ->
    $(".date_picker_field").datetimepicker({
		                icons: {
		                    time: "fa fa-clock-o",
		                    date: "fa fa-calendar",
		                    previous: "fa fa-arrow-left",
		                    next: "fa fa-arrow-right",
		                    today: "fa fa-crosshairs",
		                    close: "fa fa-times",
		                    clear: "fa fa-times-circle"
		                }
		                showTodayButton: true,
		                showClose: true,
		                showClear: true,
		                format: "DD/MM/YYYY"
		            })
$ ->
  $(".date_picker_field").datetimepicker({
                icons: {
                    time: "fa fa-clock-o",
                    date: "fa fa-calendar",
                    previous: "fa fa-arrow-left",
                    next: "fa fa-arrow-right",
                    today: "fa fa-crosshairs",
                    close: "fa fa-times",
                    clear: "fa fa-times-circle"
                }
                showTodayButton: true,
                showClose: true,
                showClear: true,
                format: "DD/MM/YYYY"
            })		
