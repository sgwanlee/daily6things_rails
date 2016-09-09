jQuery.fn.submitOnCheck = function() {
  this.find('input[type=checkbox]').change(function() {
    $(this).parent('form').submit();
  });
  return this;
}

$(document).on("turbolinks:load", function (){
  $('.edit_task').submitOnCheck();
});