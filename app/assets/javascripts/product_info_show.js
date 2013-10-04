$(function () {
  $('.product_img_link').hover(function(e) {
    e.preventDefault();
    $this = $(this);
    $('#product_img').attr('src', $this.attr('href'));
  });
});