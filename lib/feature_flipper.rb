module FeatureFlipper

  @@features = {}

  def flipper(name, value=false, &block)
    if block_given?
      @@features[name] = block
    else
      @@features[name] = !!value
    end
  end

  def get(name, args=[])
    value = @@features[name]
    value.respond_to?(:call) ? !!value.call(*args) : value
  end

  def feature(name, args=[], &block)
    active = self.get(name, args)
    if active
      block.call if block_given?
      true
    else
      false
    end
  end

end