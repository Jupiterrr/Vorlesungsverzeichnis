module MustacheTemplateHandler
  def self.call(template)
    # haml = "Haml::Engine.new(#{template.source.inspect}).render"
    #     if template.locals.include? :mustache
    #       "Mustache.render(#{haml}, mustache).html_safe"
    #     else
    #       haml.html_safe
    #     end
    puts "+++++++++++++++++"
    puts template.inspect
    Mustache.render(template, {})
  end
end
ActionView::Template.register_template_handler(:mustache, MustacheTemplateHandler)