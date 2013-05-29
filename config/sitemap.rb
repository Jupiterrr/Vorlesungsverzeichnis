# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://kit.carstengriesheimer.de"
SitemapGenerator::Sitemap.create_index = :auto

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  
  add map_index_path
  add list_map_index_path
  Poi.find_each { |poi| add map_path(poi) }
  
  add vvz_index_path
  Event.find_each do |event|
    vvz = event.vvzs.first
    add vvz_event_path(vvz, event)
  end  

  add page_path("about")

end
