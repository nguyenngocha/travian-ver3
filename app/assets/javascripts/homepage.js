document.addEventListener("turbolinks:load", function() {
  var flash = function slide_up_flash(){
    setTimeout(function(){
      $('#flash').slideUp(2000);
    }, 1500);
  };

  $(document).ready(flash);
  $(document).on('page:load', flash);
  $(document).on('page:change', flash);
});
function clear_then_show_flash(data_flash){
  close_loading_after();
  $('#flash').html(data_flash);
  setTimeout(function(){
    $('#flash').show().slideUp(4000);
  }, 200);
}
