jQuery(function() {

  $( "#edit_translation" ).dialog({
    autoOpen: false,
    height: 500,
    width: 800,
    modal: true,
    open: function(event, ui) {
      $('.ui-widget-overlay').bind('click', function() {
        $("#edit_translation").dialog('close');
      });
    }
  });

  $('.edit_translation').click(function(){
    $( "#edit_translation" ).dialog( "open" );
    return false;
  })

})
