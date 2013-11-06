function validateEmail(email) { 
  var re = /^\S+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/;
  return re.test(email);
} 

$( function() {
  $('.user_form .btn').on('click', function() {
    if(!validateEmail($('#user_email').val()) || $('#user_password_confirmation').val().length < 6 || $('#user_password').val().length < 6 || 
      $('#user_password').val() !== $('#user_password_confirmation').val()) {
      $('<div class="alert alert-error">sorry but you have invalid input</div>').insertBefore('.user_form');
      return false;
    }
  });

  $('#user_email').on('blur', function() {
    var invalidInfo = 'sorry but your email is invalid'
    $this = $(this);
    if (!validateEmail($this.val())) {
      if ($('#email_msg').length) {
        $('#email_msg').text(invalidInfo);
      } 
      else {
        $('<div id="email_msg" class="text-error">' + invalidInfo + '</div>').insertBefore($this);
      }
    }
    else {
      if ($('#email_msg').length) {
        $('#email_msg').text('');
      } 
    }
  });  

  $('#user_password').on('blur', function() {
    var invalidInfo = 'sorry but your password should be at least 6 characters'
    $this = $(this);
    if ($this.val().length < 6) {
      if ($('#password_msg').length) {
        $('#password_msg').text(invalidInfo);
      } 
      else {
        $('<div id="password_msg" class="text-error">' + invalidInfo + '</div>').insertBefore($this);
      }
    }
    else {
      if ($('#password_msg').length) {
        $('#password_msg').text('');
      } 
    }
  });

  $('#user_password_confirmation').on('blur', function() {
    var invalidInfo = 'sorry but your password confirmation should be at least 6 characters and same as your password'
    $this = $(this);
    if ($this.val().length < 6 || $this.val() !== $('#user_password').val()) {
      if ($('#password_confirm_msg').length) {
        $('#password_confirm_msg').text(invalidInfo);
      } 
      else {
        $('<div id="password_confirm_msg" class="text-error">' + invalidInfo + '</div>').insertBefore($this);
      }
    }
    else {
      if ($('#password_confirm_msg').length) {
        $('#password_confirm_msg').text('');
      } 
    }
  });
})