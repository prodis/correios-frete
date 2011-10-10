# encoding: UTF-8
require 'spec_helper'

describe Correios::Frete::WebService do
  describe "#request" do
    around do |example|
      Correios::Frete.configure { |config| config.log_enabled = false }
      example.run
      Correios::Frete.configure { |config| config.log_enabled = true }
    end

    let(:frete) { Correios::Frete::Calculador.new }
    let(:webservice) { Correios::Frete::WebService.new(frete, [:pac, :sedex]) }

    it "returns XML response" do
      fake_request_for("<xml><fake></fake>")
      webservice.request!.should == "<xml><fake></fake>"
    end
  end
end
