class TermPresenter
  include VvzsHelper

  def initialize(term)
    @term = term
  end

  def as_json(*)
    {
      'name' => human_term_name(@term.name),
      'id' => @term.id,
      'url' => "#{API.api_url}/terms/#{@term.id}"
    }
  end

end