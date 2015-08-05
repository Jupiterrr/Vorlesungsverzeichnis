module FeatureFlipper

  @@features = {}

  def flipper(name, value=false, &block)
    if block_given?
      @@features[name] = block
    else
      @@features[name] = !!value
    end
  end

  def feature(name, args=[], &block)
    active = get(name, args)
    if active
      block.call if block_given?
      true
    else
      false
    end
  end

  class FeatureNotFound < StandardError; end

  private
    def get(name, args=[])
      raise FeatureNotFound unless @@features.key?(name.to_sym)
      value = @@features[name.to_sym]
      value.respond_to?(:call) ? !!value.call(*args) : value
    end

end