module VvzsHelper

  def tree_seed_cached(term)
    cache_key = ["vvz:tree_seed", term.id]
    Rails.cache.fetch(cache_key, expires_in: 1.day) { tree_seed(term) }
  end

  def tree_seed(term)
    tree = term.subtree.arrange
    node_map = {}
    tree(tree, node_map)
    node_map.to_json.html_safe
  end

  def tree(node_hash, h)
    node_hash.map do |node, children|
      if node.is_leaf
        ids = nil #node.event_ids
      else
        ids = tree(children, h)
      end
      h[node.id] = [node.name, ids]
      node.id
    end
  end

  def readable_vvz_path(vvz)
    vvz.path.map(&:name)[2..-1].join(" / ")
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
      [event.id, event.name || "", 1, event.simple_type]
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

  def human_term_name(name, type=:normal)
    period, year = split_term(name)

    if period == "WS"
      yi = year.to_i
      year = "20#{yi}/#{yi+1}"
    else
      year = "20#{year}"
    end

    unless type == :short
      period = case period
        when "WS" then "Wintersemester"
        when "SS" then "Sommersemester"
      end
    end

    new_term = "#{period} #{year}"
  end

  def sort_terms(terms)
    sorted = terms.sort_by do |term|
      period, year = split_term(term.name)
      year = year.split("/").first
      "#{year} #{period}"
    end.reverse
  end

  private

  def split_term(term)
    if term.include?("/")
      term = convert_term_name(term)
    end
    term.match(/(\w+) 20(.+)/).captures
  end

  def convert_term_name(name)
    term = name[0..1]
    if term == "SS"
      name
    else
      "#{term} 20#{name[3..4]}"
    end
  end

end
