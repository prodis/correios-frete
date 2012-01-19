# encoding: UTF-8
def fake_request_for(response)
  FakeWeb.register_uri(:get,
                       Regexp.new("http://ws.correios.com.br/calculador/CalcPrecoPrazo.aspx"),
                       :status => 200,
                       :body => body_for(response))
end

def body_for(response)
  case response
  when :success_response_one_service
    File.open(File.dirname(__FILE__) + "/responses/success-response-one-service.xml").read
  when :success_response_many_services
    File.open(File.dirname(__FILE__) + "/responses/success-response-many-services.xml").read
  else
    response
  end
end
