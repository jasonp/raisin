# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

set_positions = ->
  $('.sortable_list').each (i) ->
    $(this).attr("data-list-pos",i+1);
    $(this).find('li').each (n) ->
      $(this).attr("data-item-pos",n+1);

ready = ->
  set_positions();
  $('.sortable').sortable();

 	$('.sortable').sortable().bind 'sortupdate', (e, ui) ->

    updated_order = []

    set_positions()
    
    $('.sortable_list').each (i) ->
      $(this).find('li').each (n) ->
        updated_order.push
          id: $(this).data('item-id')
          position: n + 1
        return

    $.ajax
      type: 'PUT'
      url: '/tasks/sort'
      data: order: updated_order
    return

$ ->
  $(document).ready ready

$ ->
  $("body").on 'loadSortable', (evt) ->
    ready();