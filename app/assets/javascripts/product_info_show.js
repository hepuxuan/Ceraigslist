$(function () {
  $('.product_img_link').hover(function(e) {
    e.preventDefault();
    $('#product_img').attr('src', $(this).attr('href'));
  });
});