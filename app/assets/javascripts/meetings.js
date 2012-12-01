var Meeting = {
  init: function() {
    $('.action').on('click', 'button', this.showForm);
    $('.form input[type="text"]').blur(this.validateFields);
    $('.form form').on('submit', this.checkNewMeeting);
  },

  showForm: function(event) {
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
  },

  validateFields: function() {
    var $self = $(this);
    if ($self[0].value === '') {
      $self.eq(0).addClass('inputError');
      $('#new_meeting_submit').addClass('disabled');
      if ($self[0].name === 'meeting[neighborhood]') {
        $self.eq(0).attr('placeholder', 'Please enter a neighborhood');
      }
      else {
        $self.eq(0).attr('placeholder', 'Please enter a description');
      }
    } else {
      $self.eq(0).removeClass('inputError');
      $('#new_meeting_submit').removeClass('disabled');
    }
  },

  checkNewMeeting: function(event) {
    topic = $(this).children().eq(2).children()[0];
    neighborhood = $(this).children().eq(2).children()[1];
    description = $(this).children().eq(2).children()[2];
    if ((neighborhood.value === '') || (description.value === '') || 
      (topic.value === '')) {
      event.preventDefault();
      $(neighborhood).addClass('inputError');
      $(description).addClass('inputError');
      $(neighborhood).attr('placeholder', 'Please enter a neighborhood');
      $(description).attr('placeholder', 'Please enter a description');
    }
  }


};

$(document).ready(function(){ Meeting.init(); });