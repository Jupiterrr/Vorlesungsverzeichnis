module VvzsHelper
  def tree_seed(node_hash)
    #node, children = node_hash.to_a.first
    
    tree(node_hash).first.to_s.html_safe
  end

  def tree(node_hash)
    node_hash.map do |node, children|
      if children.empty?
        [node.id, node.name, 0, events_js(node)]
      else
        [node.id, node.name, 0, tree(children)]
      end
    end
  end

  private
  def nodes_js(children)
    children.map do |hash|
      node, children = node_hash.to_a

      [node.id, node.name, 0, nodes_js(children)]
    end
  end

  def events_js(parent)
    parent.events.map do |event| 
      [event.id, event.name, 1]
    end
  end

  def children_js(parent)
    parent.children.empty? ? events_js(parent) : nodes_js(parent)
  end

  def simple_type(type)
    type[/^(\S)+/]
  end

  def vvz_event_url(event)
    vvz = event.vvzs.first
    "#{vvz_url(vvz)}/events/#{event.id}"
  end

  def human_term_name(name)
    t = name.clone
    t.gsub!("_", " ")
    t.gsub!("WS", "Wintersemester")
    t.gsub!("SS", "Sommersemester")
    # binding.pry
    if t.include? "-"
      puts t
      a,b = t.match(/(\d+)-(\d+)/).captures
      t.gsub!(/(\d+)-(\d+)/) {|y| "20#{a}/#{b}" }
    end
    
    t
  end
end
