$(function() {
  ajaxPagination();
});
function ajaxPagination() {
  $('.pagination a, .sidebar .nav a').not('#more_tags').on('click', function() {
    var $pagination = $('.pagination'),
        $notice = $('.pagination-notice');

    if ($notice.length > 0) {
      $notice.show();
    }
    else {
      $('<div class = \'pagination-notice\'>Page is loading...</div>').insertBefore('.index-table');
    }
    $.getScript(this.href);
    return false;
  });

  $('#search-form, #search-string').on('submit', function() {
    $.getScript(this.action + '?' + $(this).serialize());
    return false;
  });
}
