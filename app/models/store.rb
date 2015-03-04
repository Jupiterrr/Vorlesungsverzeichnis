class Store < ActiveRecord::Base
  self.primary_key = 'key'
  self.table_name = 'store'

  def self.[](key)
    get(key).value
  end

  def self.get(key)
    where(key: key.to_s).first_or_initialize
  end

  def self.set(key, value)
    s = get(key)
    s.value = value.to_s
    s.save!
  end

  def self.[]=(key, value)
    set(key, value)
  end

end
