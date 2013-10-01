begin
  silence_warnings do
    require 'pry'
    IRB = Pry
  end

  if defined?(Zeus::Rails)
    class Zeus::Rails
      def console
        Pry.start
      end
    end
  end
rescue LoadError
end
