module ApplicationHelper

  DEFAULT_TITLE = "KIT Vorlesungsverzeichnis"

  def page_title(title=nil)
    if title
      @page_title = "#{title} - #{DEFAULT_TITLE}"
    else
      @page_title ||= DEFAULT_TITLE
    end
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

end
