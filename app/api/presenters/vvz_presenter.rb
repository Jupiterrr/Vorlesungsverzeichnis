class VvzPresenter

  def initialize(vvz)
    @vvz = vvz
  end

  def as_json(*)
    data = {
      'name' => @vvz.name,
      'id' => @vvz.id,
      'parent_id' => @vvz.parent_id  
    }
  end

end