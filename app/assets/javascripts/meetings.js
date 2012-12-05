var Meeting = {
  init: function() {

    $('input[value="Accept"]').on('click', this.showForm);
    $('.form form').on('submit', this.checkNewMeeting);
    $('input[value="Nevermind"]').on('click', this.unAcceptMeeting);

    $('.form input[type="text"]').blur(this.handleInputChange);
   
    
  },

  unAcceptMeeting: function(event) {
    $(this).parents('.message').addClass('hidden');
    $(this).parents('.meeting').removeClass('meeting-with-form');
    $('input[disabled="disabled"]').removeAttr('disabled');
  },

  showForm: function(event) {
    $(this).parents('.meeting').addClass('meeting-with-form');
    $messageField = $(this).parents('.meeting').children('.message');
    $messageField.removeClass("hidden");
    $(this).submit();
    $(this).attr('disabled','disabled');
  },

  handleInputChange: function() {
    var $field = $(this).eq(0);
    Meeting.validateField($field);
  },

  checkNewMeeting: function(event) {
    var perfect = true;
    $(this).find('input').each(function(k, field) {
      if (!Meeting.validateField($(field))) {
        perfect = false;
        event.preventDefault();
      }
    });
    return perfect;
  },
  validateField: function($field) {
    if ($field.val() === '') {
      var name = $field.attr('id').replace('meeting_','')
      $field.attr('placeholder', 'Please enter a ' + name);
      $field.addClass('inputError');
      return false;
    } else {
      $field.removeClass('inputError');
      return true;
    }
  }
};



$(document).ready(function(){ Meeting.init(); });