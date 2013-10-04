$(function() {
  $( '#tag' ).autocomplete({
    minLength: 2,
    source: function(request, response) {
      $.getJSON( 'product_infos/tags/search.json',{term: request.term}, function( data ) {
      var items = [];
      $.each( data, function( key, val ) {
        items.push( val.name );
      });
      response(items);
    });
    }
  });
});
