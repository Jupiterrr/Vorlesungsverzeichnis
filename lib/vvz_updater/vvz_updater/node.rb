module VVZUpdater
  class Node < Struct.new(:id, :name, :children, :event_ids)

    def child_ids
      children.map(&:id)
    end

    def external_id
      id
    end

    def is_leaf?
      children.empty?
    end

    def as_json
      base = {id: id, name: name}
      if is_leaf?
        base[:event_ids] = event_ids
      else
        base[:children] = children.map(&:as_json)
      end
      base
    end

    def flatten(nodes=[])
      nodes << self
      children.each {|child| child.flatten(nodes) }
      nodes
    end

    def leafs(nodes=[])
      if is_leaf?
        nodes << self
      else
        children.map {|child| child.leafs(nodes) }
      end
      nodes
    end

    def term_name
      if name.include?("/")
        term, y = name.match(/(..)\s(\d+)/).captures
        "#{term} 20#{y}"
      else
        name
      end
    end

  end
end

