# encoding: UTF-8
require 'spec_helper'

describe Correios::Frete::Parser do
  describe "#servicos" do
    let(:xml) { body_for :success_response_many_services }
    let(:parser) { Correios::Frete::Parser.new }

    it "encodes from ISO-8859-1 to UTF-8" do
      xml.should_receive(:backward_encode).with("UTF-8", "ISO-8859-1").and_return(xml)
      parser.servicos(xml)
    end

    { :pac => { :tipo => :pac,
                :codigo => "41106",
                :valor => 15.70,
                :prazo_entrega => 3,
                :valor_mao_propria => 3.75,
                :valor_aviso_recebimento => 1.99,
                :valor_valor_declarado => 1.50,
                :entrega_domiciliar => true,
                :entrega_sabado => false,
                :erro => "-3",
                :msg_erro => "Somente para teste" },
      :sedex => { :tipo => :sedex,
                  :codigo => "40010",
                  :valor => 17.8,
                  :prazo_entrega => 1,
                  :valor_mao_propria => 3.70,
                  :valor_aviso_recebimento => 0.0,
                  :valor_valor_declarado => 1.5,
                  :entrega_domiciliar => true,
                  :entrega_sabado => true,
                  :erro => "0",
                  :msg_erro => nil }
    }.each do |service, attributes|
      it "returns #{service} data" do
        servicos = parser.servicos(xml)

        attributes.each do |attr, value|
          servicos[service].send(attr).should == value
        end
      end
    end
  end
end
