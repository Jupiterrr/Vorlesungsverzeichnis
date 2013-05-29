# encoding: UTF-8

# Public: tries to improve names like 'Übung zu 100212'. Removes all improved names before.
class DataEnhancement
  class << self
    # Public: tries to improve names like 'Übung zu 100212'. 
    # Removes all improved names before.
    def improve_names
      Event.all.each {|event| improve_name(event) }
    end

    def improve_name(event)
      if stupid_name?(event.original_name) 
        event_no = /[[:digit:]]+/.match(event.original_name)
        if link = find_event(event_no)
          event.name = tutorium?(event.original_name) ? "Tutorium zu #{link.name}" : "Übung zu #{link.name}"
          puts "#{event.original_name} => #{event.name}"
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
      Event.find(:first, conditions: ["nr LIKE ?", "%" + event_no.to_s])
    end
  end
end
