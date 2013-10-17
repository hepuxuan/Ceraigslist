$(function() {
  $('.pagination a').on('click', function() {
    var $notice = $('.pagination-notice');
    if ($notice.length > 0) {
      $notice.show();
    }
    else {
      $('<div class = \'pagination-notice\'>Page is loading...</div>').insertBefore('.index-table');
    }
    $.getScript(this.href);
    return false;
  });
});
