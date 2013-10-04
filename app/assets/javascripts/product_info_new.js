$(function () {
  $('#address_same_as_user').click(function(){
    if($(this).is(':checked')) {
      $('#address_address1').attr('readonly', true);
      $('#address_address2').attr('readonly', true);
      $('#product_info_city').attr('readonly', true);
      $('#product_info_state').attr('readonly', true);
      $('#address_address1').val($('#product_info').data('address'));
      $('#product_info_city').val($('#product_info').data('city'));
      $('#product_info_state').val($('#product_info').data('state'));
    }
    else {
      $('#address_address1').attr('readonly', false);
      $('#address_address2').attr('readonly', false);
      $('#product_info_city').attr('readonly', false);
      $('#product_info_state').attr('readonly', false);
    }
  });
});
