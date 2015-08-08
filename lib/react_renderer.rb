class ReactRenderer

  def self.client
    @client ||= ReactRenderer.new
  end

  def self.timetable(event_dates)
    client.send(event_dates)
  end

  def initialize
    @http = Net::HTTP.new("localhost", "3030")
    @http.read_timeout = 500
  end

  def send(data)
    res = @http.post("/", data.to_json, {'Content-Type' =>'application/json'})
    res.body.force_encoding(Encoding::UTF_8).html_safe
  end

end
