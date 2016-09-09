jQuery.fn.submitOnEnter = function() {
  this.find('input[type=submit]').remove();
  this.find('input[type=text]').keydown(function(event) {
    if (event.keyCode == 13) {
      $(this).parents('form').submit();
      $(this).val("");
      return false;
     }
  });
  return this;
}

$(document).on("turbolinks:load", function (){
  $('#new_task').submitOnEnter();
  var dragula = Dragula([document.querySelector('#incompleted-tasks')], {
    moves: function (el, container, handle) {
      return handle.classList.contains('bar-icon');
    },
    mirrorContainer: document.querySelector('#incompleted-tasks')
  });

  dragula.on('drop', function(el){
    console.log($(el).index('#incompleted-tasks form'))
    var id = $(el).attr('id').slice(10,12)
    console.log(id)
    $.ajax({
      url: '/tasks/'+id+'/replace',
      type: 'POST',
      dataType: "script",
      data: {
        index: $(el).index('#incompleted-tasks form'),
        task_id: id
      },
      error: function(err){
      },
      success: function(response){
        // console.log("success-update-menu");
      }
    });
  })
  
});