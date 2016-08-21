jQuery.fn.submitOnCheck = function() {
  this.find('input[type=submit]').remove();
  this.find('input[type=checkbox]').click(function() {
    $(this).parent('form').submit();
  });
  this.find('.delete-link').mouseover(function(){
    $(this).parent('form').css('background-color', '#eee');
  });
  this.find('.delete-link').mouseout(function(){
    $(this).parent('form').css('background-color', '');
  });
  return this;
}

$(function() {
  $('.edit_task').submitOnCheck();
});