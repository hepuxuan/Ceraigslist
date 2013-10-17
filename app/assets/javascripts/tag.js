$( function() {
  $('#more_tags').on('click', function(e) {
    e.preventDefault();
    $(this).hide();
    $.getScript(this.href);
  });
});
