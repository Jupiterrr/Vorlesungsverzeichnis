module ApplicationHelper

  DEFAULT_TITLE = "KIT Vorlesungsverzeichnis"

  DESCRIPTIONS = {
    vvz: "Ein modernes und schnelles Vorlesungsverzeichnis für das Karlsruher Institut für Technologie (KIT)",
    landing: "Ein modernes und schnelles Vorlesungsverzeichnis für das Karlsruher Institut für Technologie (KIT)",
    map: "Alle Hörsääle, Bibliotheken, Fachschaften und Institute auf einer interaktiven Karte."
  }

  def descriptions(key)
    DESCRIPTIONS.fetch(key)
  end

  def browser_id_uid
    if current_user
      current_user.uid.to_s.inspect.html_safe
    else
      "null"
    end
  end

  def to_params(params)
    parameterize(params)
  end

  def parameterize(params)
    URI.escape(params.collect{|k,v| "#{k}=#{v}"}.join('&'))
  end

  class RenderEvent < Redcarpet::Render::HTML
    def header(text, header_level)
      # level = header_level + 2
      "<b class=\"head\">#{text}</b>"
    end
  end

  def markdown(text, wrapper=true)
    renderer = Redcarpet::Markdown.new(RenderEvent, :hard_wrap=>true, :filter_html=>true, :autolink=>true, :no_intraemphasis=>true, :fenced_code=>true, :gh_blockcode=>true)
    html = renderer.render(text).html_safe
    if wrapper
      content_tag(:div, html, class: "markdown")
    else
      html
    end
  end

  def parent_layout(layout)
    @_content_for[:layout] = self.output_buffer
    self.output_buffer = render(:file => "layouts/#{layout}")
  end

end
