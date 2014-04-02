class ColumnView
  attr_reader :columns, :back_btn_class, :back_btn_href

  def initialize(vvz, event=nil)
    @columns = get_columns(vvz, event)
    @back_btn_class = @columns.count <= 2 ? "hidden": ""
    back_node = event ? vvz : vvz.parent
    @back_btn_href = "/vvz/#{back_node.id}/"
  end

  def get_columns(vvz, event=nil)
    columns = []
    if vvz.is_term?
      columns.push ListCol.new(vvz, nil)
    elsif event != nil
      columns.push ListCol.new(vvz.parent, vvz)
      columns.push EventListCol.new(vvz, event)
      columns.push EventCol.new(event)
    elsif vvz.is_leaf
      columns.push ListCol.new(vvz.parent.parent, vvz.parent) unless vvz.parent.is_term?
      columns.push ListCol.new(vvz.parent, vvz)
      columns.push EventListCol.new(vvz, nil)
    else
      columns.push ListCol.new(vvz.parent.parent, vvz.parent) unless vvz.parent.is_term?
      columns.push ListCol.new(vvz.parent, vvz)
      columns.push ListCol.new(vvz, nil)
    end
    columns
  end

  # Interface:
  Item = Struct.new(:name, :url, :css_class, :value)
  ItemGroup = Struct.new(:name, :items)

  class ListCol
    attr_reader :groups

    def initialize(parent, selected_node=nil)
      items = parent.children.map do |item_node|
        ListItem.new(item_node, parent, selected_node)
      end
      sorted_items = sort_by_name(items)
      group = ItemGroup.new(nil, sorted_items)
      @groups = [group]
    end

    def sort_by_name(items)
      items.sort {|a,b| a.name <=> b.name}
    end

    class ListItem < Item

      def initialize(node, parent, selected_node=nil)
        self.value = node.id
        self.url = "/vvz/#{node.id}"
        self.name = node.name
        self.css_class = node == selected_node ? "selected" : ""
      end

    end

  end

  class EventListCol
    attr_reader :groups

    def initialize(leaf, selected_event=nil)
      items = leaf.events.map do |item_event|
        EventItem.new(item_event, leaf, selected_event)
      end
      sorted_items = sort_by_name(items)
      groups = group(sorted_items)
      sorted_groups = sort_by_name(groups)
      @groups = sorted_groups
    end

    def group(items)
      groups = items.group_by {|item_event| item_event.event.simple_type }
      groups.map {|type, items| ItemGroup.new(type, items) }
    end

    def sort_by_name(items)
      items.sort {|a,b| a.name <=> b.name}
    end

    class EventItem < Item
      attr_reader :event
      def initialize(event, leaf, active_event=nil)
        self.value = "#{leaf.id}/#{event.id}"
        self.url = "/vvz/#{leaf.id}/events/#{event.id}"
        self.name = event.name
        self.css_class = event == active_event ? "selected" : ""
        @event = event
      end

    end

  end

  EventCol = Struct.new(:event)






end
