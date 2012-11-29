$(document).ready (
  function() {
    $(".action").on("click", "button", function(event) {
      var $self = $(this),
          $messageField = $("#m" + event.target.id[1]);
          
      if ($self.hasClass('accept')) {
        $messageField.removeClass("hidden");
        $self.siblings('button.decline').removeClass('hidden');
      } else {
        $messageField.addClass("hidden");
        $self.siblings('button.accept').removeClass('hidden');
      }
      $self.addClass('hidden');  
    })
  }
})