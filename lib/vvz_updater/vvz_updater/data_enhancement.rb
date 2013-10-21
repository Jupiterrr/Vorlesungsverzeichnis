# encoding: UTF-8

module VVZUpdater
  # Public: tries to improve names like 'Übung zu 100212'. Removes all improved names before.
  class DataEnhancer

    def initialize(term, opts={})
      @options = {
        event_scope: Event,
        logging: true
      }.merge(opts)
      event_scope = @options[:event_scope]
      @event_scope = event_scope.where(term: term)
    end

    # Public: tries to improve names like 'Übung zu 100212'.
    # Removes all improved names before.
    def improve_names
      @event_scope.each {|event| improve_name(event) }
    end

    def improve_name(event)
      if stupid_name?(event.original_name)
        event_no = /[[:digit:]]+/.match(event.original_name)
        if link = find_event(event_no)
          event.name = tutorium?(event.original_name) ? "Tutorium zu #{link.name}" : "Übung zu #{link.name}"
          puts "#{event.original_name} => #{event.name}" if @options[:logging]
          event.save
        end
      end
    end

    def stupid_name?(name)
      /^(Übung(en)?|Tutorium) ((zu|für) )?[[:digit:]]+/ =~ name
    end

    def tutorium?(name)
      /^Tutorium / =~ name
    end

    def find_event(event_no)
      @event_scope.find(:first, conditions: ["nr LIKE ?", "%" + event_no.to_s])
    end

  end
end
