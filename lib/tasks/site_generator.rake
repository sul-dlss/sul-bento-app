# frozen_string_literal: true

LIBRARY_WEBSITE_URI = 'https://library.stanford.edu'

desc 'Generate the website template from library.stanford.edu'
task :generate_website do # rubocop:disable Rails/RakeEnvironment, Metrics/BlockLength
  result = HTTP.get(LIBRARY_WEBSITE_URI)
  data = result.body.to_s

  if data.include?('Vercel Security Checkpoint')
    puts "Unable to get #{LIBRARY_WEBSITE_URI}"
    exit(1)
  end

  doc = Nokogiri::HTML(data)

  # Update any links
  doc.css('a').each do |node|
    next if node['href'].start_with?('http') || node['href'].start_with?('#')

    node['href'] = "#{LIBRARY_WEBSITE_URI}#{node['href']}"
  end

  # Update href of any link node
  doc.css('head link').each do |node|
    next if node['href'].start_with?('http')

    node['href'] = "#{LIBRARY_WEBSITE_URI}#{node['href']}"
  end

  # Update srcset of any img node
  doc.css('img[srcset]').each do |node|
    next if node['srcset'].start_with?('http')

    sources = node['srcset'].split(', ')
    # TODO, split the set up.
    node['srcset'] = sources.map { "#{LIBRARY_WEBSITE_URI}#{it}" }.join(', ')
  end

  # Remove any scripts
  doc.css('link[as="script"]').each(&:remove)
  doc.css('script').each(&:remove)

  # Remove nerd squirrel
  doc.css('footer .absolute').each(&:remove)

  # Remove the red underline on home
  doc.css('.lg\:after\:bg-cardinal-red').each do |node|
    node.remove_class('lg:after:bg-cardinal-red')
  end

  # Remove the search button from the top menu
  doc.css('nav[aria-label="Main Menu"] > ul > li:last-child').each(&:remove)

  # Add right padding on the last menu item
  doc.css('nav[aria-label="Main Menu"] > ul > li:last-child').each do |node|
    node.add_class('mr-32')
  end

  # Wipe out the main so we can put our content there
  doc.css('main').each do |node|
    new_node = doc.create_element 'main'
    node.replace new_node
  end
  html = doc.to_html

  # Add main body with yield and an id, so skiplinks will work
  erb = html.sub('<main></main>', '<main id="main-content"><%= yield %></main>')
            .sub('</head>', "<%= render 'shared/extra_header' %>\n</head>")
  File.write('app/views/layouts/application.html.erb', erb)
end
