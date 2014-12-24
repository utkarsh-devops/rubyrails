//= require active_admin/base
//= require tinymce

$(document).ready(function() {
  tinyMCE.init({
    mode: 'textareas',
    theme: 'advanced',
    editor_selector: 'tinymce',
    width : "800",
    height : "600",
    theme_advanced_buttons1 : "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,styleselect,formatselect,fontselect,fontsizeselect",
    theme_advanced_buttons2 : "bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,anchor,image,cleanup,help,code,|,forecolor,backcolor",
    theme_advanced_buttons3 : "hr,removeformat,visualaid,|,sub,sup,|,charmap"
  });

  // Datepicker : to select today onwards date only on new event
  $('input.hasDatePicker').datepicker({
    dateFormat: "mm-dd-yy",
    minDate: 0,
    maxDate: "+1Y"
  });

  // Custimazing hyperlink label in action item
  $("span.action_item a[href='/admin/admin_users/new']").text("+ New Admin User");
  $("span.action_item a[href='/admin/uses/new']").text("+ New Use");
  $("span.action_item a[href='/admin/events/new']").text("+ New Event");

  // Handle enable/disable of no date checkbox on new event
  event_form = $("form.event");
  no_date = event_form.find("#event_is_permanent_event");
  event_date = event_form.find("#event_event_date");

  function event_date_task(){
    if( $(no_date).prop("checked") == true ){
      event_date.prop('disabled', true)
      if ($("#new_event").length>0){
        event_date.val("");
      }
      $("label[for='event_is_permanent_event']").before("<div id='eventNote'>This event will be permanent</div>");
    }
    else {
      event_date.prop('disabled', false);
      event_form.find('#eventNote').remove();
    }

  }
  // on load
  event_date_task();
  // on change
  $(no_date).on('change',function(){
    event_date_task();
  });

  // change date formate for edit event
  if ($.trim(event_date) != "" && event_date.val() != undefined){
    var splited_date = event_date.val().split("-");
    if(splited_date[0].length == 4){
      new_date = splited_date[1] + "-" + splited_date[2].substring(0,2) + "-" + splited_date[0]
      $(event_date).val(new_date);
    }
  }
});