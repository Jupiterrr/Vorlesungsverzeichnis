module MetaHelper

  def meta_top()
    meta = {
      site: "KitHub",
      title: -> { meta_title_for(title, site) },
      keywords: [:keywords, "KIT", "Karlsruher Institut für Technologie", "Uni Karlsruhe"]
    }
    fb_meta(meta)
    meta
  end

  def fb_meta(meta)
    meta[:fb] = {
      app_id: "293326227400560",
      admins: "1187916060"
    }
    meta[:og] = {
      site_name: "KitHub",
      url: "http://www.kithub.de#{request.fullpath}",
      image: "http://www.kithub.de/fb_logo.png"
    }
  end

  def meta_title_for(title, site)
    array = Array(title)
    array.push(site) unless array.last && array.last.include?(site)
    array.join(" · ")
  end

  # def og_place(meta, poi)
  #   meta[:ob].merge({
  #     type: "place",
  #     title: poi.name,
  #     image: "http://maps.googleapis.com/maps/api/staticmap?zoom=15&size=600x315&maptype=roadmap&markers=#{poi.lat},#{poi.lng}&sensor=false".html_safe,
  #   })
  #   meta[:place] = {
  #     location: {
  #       latitude: poi.lat},
  #       longitude: poi.lng
  #     }
  #   }
  # end

  # <meta property="og:title" content="<%=h yield(:title) %>" />
  # <meta property="og:image" content="http://www.kithub.de/fb_logo.png" />

end
