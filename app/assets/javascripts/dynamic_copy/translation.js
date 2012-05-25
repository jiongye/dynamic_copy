jQuery(function() {

  $("#edit_translation").dialog({
    autoOpen: false,
    title: 'Edit Translation',
    height: 500,
    width: 800,
    modal: true
  });

  $('.edit_translation').click(function(){
    if($("#edit_translation")[0] != undefined){
      url = $(this).attr('href');
      $.get(url, function(data){
        $('#edit_translation').html(data);
      }, 'html');

      $("#edit_translation").dialog( "open" );
      return false;
    }
  })

})
