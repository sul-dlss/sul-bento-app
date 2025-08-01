# frozen_string_literal: true

class ArticleResult
  FORMAT_TO_ICON = {
    'Academic Journal' => 'book-open-4.svg',
    'Article' => 'wrap-text-around.svg',
    'Audio' => 'microphone-3.svg',
    'Books' => 'notebook.svg',
    'eBooks' => 'notebook.svg',
    'Maps' => 'map-pin-1.svg',
    'Music scores' => 'file-music-1.svg',
    'News' => 'newspaper.svg',
    'Report' => 'notepad-1.svg',
    'Video Recording' => 'camera-film-1.svg',
    'Videos' => 'camera-film-1.svg'
  }.freeze

  include ActiveModel::API

  attr_accessor :title, :format, :journal, :author, :description, :link, :fulltext_link_html,
                :pub_date, :composed_title, :fulltext_stanford_only

  alias fulltext_stanford_only? fulltext_stanford_only

  def icon
    FORMAT_TO_ICON.fetch(format, 'notebook.svg')
  end

  def formatted_year
    return nil if pub_date.blank?

    date = Date.parse(pub_date)
    year = date.strftime('%Y')
    "(#{year})"
  rescue Date::Error
    nil
  end

  def journal_details
    return '' if composed_title.blank?

    search_link_match = composed_title.match(%r{</searchlink>(.*)}i)
    return search_link_match[1] if search_link_match

    italic_match = composed_title.match(%r{\u003C/i\u003E(.*)}i)
    italic_match ? italic_match[1] : ''
  end
end
