function toggleableResults(searcher) {
  var toggleableResults = $('#' + searcher + ' [data-behavior="toggleable-results"]');
  var threshold = toggleableResults.data('toggleThreshold');
  var toggleButton = $('#' + searcher + '-results-toggle-button');
  var listItemsBeyondThreshold = toggleableResults.find('li:nth-child(n+' + (threshold + 1) + ')');

  listItemsBeyondThreshold.toggle();

  toggleButton.data('opened', false);
  toggleButton.on('click', function() {
    toggleButton.data('opened', !toggleButton.data('opened'));

    listItemsBeyondThreshold.slideToggle();

    if (toggleButton.data('opened')) {
      toggleButton.text(' Show fewer');
      toggleButton.prepend('<i class="fa fa-chevron-up"></i>')
      toggleButton.attr('aria-expanded', true);
    } else {
      toggleButton.text(' ' + toggleButton.data('originalText'));
      toggleButton.prepend('<i class="fa fa-chevron-down"></i>')
      toggleButton.attr('aria-expanded', false);
    }
  });
}
