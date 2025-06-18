# frozen_string_literal: true

module IconMappingHelper
  DEFAULT_ICON = 'notebook.svg'
  HASH = {
    'Loose-leaf' => 'notepad-1.svg',
    'Report' => 'notepad-1.svg',
    'Object' => 'box-3.svg',
    'Academic Journal' => 'book-open-4.svg',
    'Archive/Manuscript' => 'box-1.svg',
    'Archived website' => 'network-web.svg',
    'Article' => 'wrap-text-around.svg',
    'Book' => 'notebook.svg',
    'Books' => 'notebook.svg',
    'eBook' => 'notebook.svg',
    'Dataset' => 'graph-bar-2.svg',
    'Database' => 'window-search.svg',
    'Equipment' => 'plug-1.svg',
    'Image' => 'picture-2.svg',
    'Journal/Periodical' => 'book-open-4.svg',
    'Map' => 'map-pin-1.svg',
    'Music recording' => 'turntable.svg',
    'Music score' => 'file-music-1.svg',
    'Music scores' => 'file-music-1.svg',
    'Newspaper' => 'newspaper.svg',
    'News' => 'newspaper.svg',
    'Software/Multimedia' => 'mouse.svg',
    'Sound recording' => 'microphone-3.svg',
    'Video' => 'camera-film-1.svg',
    'Videos' => 'camera-film-1.svg'
  }.freeze

  def icon_for(format, default_format = 'Book')
    HASH[format] || HASH[default_format] || DEFAULT_ICON
  end
end
