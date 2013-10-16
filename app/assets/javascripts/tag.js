$( function() {
  $('#more_tags').on('click', function(e) {
    e.preventDefault();
    $(this).hide();
    $.getJSON( $(this).attr('href') + '.json', function( data ) {
      var items = [];
      
      $.each( data, function( key, val ) {
        items.push( '<li><a href="/product_infos?tag=' + val.name + '">' + val.name + '</a></li>' );
      });

      $(items.join( '' )).appendTo( '.nav.nav-tabs.nav-stacked' );
    });
  });
});
