require 'net/https'
require 'json'

class BrowserID

  def self.verify_assertion(assertion, host)
    # Send the assertion to Mozilla's verifier service.
    http = Net::HTTP.new("verifier.login.persona.org", 443)
    http.use_ssl = true

    request = Net::HTTP::Post.new("/verify")
    request.set_form_data(assertion: assertion, audience: host)
    response = http.request(request)

    response.is_a?(Net::HTTPSuccess) or raise "request failed"
      
    data = JSON.parse(response.body)
    data.fetch("status") == 'okay' or raise "response: #{data.inspect}"
    email = data.fetch("email")
    yield email, data
  end

end
