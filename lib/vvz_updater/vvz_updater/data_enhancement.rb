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
      @event_scope.original_with_number.each {|event| improve_name(event) }
    end

    def improve_name(event)
      matcher = GenericMatcher.new(event.original_name)
      if matcher.match?
        if link = find_event(matcher.event_no, event)
          event.update_attributes(name: matcher.fix_name(link.name))
          puts "#{event.original_name} => #{event.name}" if @options[:logging]
        end
      end
    end

    def stupid_name?(name)
      /^(Übung(en)?|Tutorium) ((zu|für) )?[[:digit:]]+/ =~ name
    end

    def tutorium?(name)
      /^Tutorium / =~ name
    end

    def find_event(event_no, event)
      @event_scope.find(:first, conditions: ["no LIKE ? AND id != ?", "%" + event_no.to_s, event.id])
    end

    class GenericMatcher

      REGEX = /^?(\S+) (?:zu|für|for)\s+?(\d+)/

      def initialize(name)
        @name = name
      end

      def event_no
        @name.match(self.class::REGEX)[1] rescue nil
      end

      def match?
        self.class::REGEX =~ @name
      end

      def event_no
        @name.match(self.class::REGEX)[2] rescue nil
      end

      def fix_name(master_name)
        type = @name.match(self.class::REGEX)[1] rescue nil
        type = "Tutorium" if type == "Tutorial"
        type = "Übung" if type == "bung"
        "#{type} zu #{master_name}"
      end
    end

  end
end
