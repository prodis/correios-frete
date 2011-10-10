# encoding: UTF-8
require 'spec_helper'

describe Correios::Frete::Calculador do
  describe ".new" do
    context "create with default value of" do
      before(:each) { @frete = Correios::Frete::Calculador.new }

      { :peso => 0.0,
        :comprimento => 0.0,
        :altura => 0.0,
        :largura => 0.0,
        :diametro => 0.0,
        :formato => :caixa_pacote,
        :mao_propria => false,
        :aviso_recebimento => false,
        :valor_declarado => 0.0
      }.each do |attr, value|
        it attr do
          @frete.send(attr).should == value
        end
      end
    end

    { :cep_origem => "01000-000",
      :cep_destino => "021222-222",
      :peso => 0.321,
      :comprimento => 12.5,
      :altura => 1.4,
      :largura => 4.6,
      :diametro => 5.0,
      :formato => :rolo_prisma,
      :mao_propria => true,
      :aviso_recebimento => true,
      :valor_declarado => 1.99,
      :codigo_empresa => "1234567890",
      :senha => "senha",
    }.each do |attr, value|
      context "when #{attr} is supplied" do
        it "sets #{attr}" do
          @frete = Correios::Frete::Calculador.new(attr => value)
          @frete.send(attr).should == value
        end
      end

      context "when #{attr} is supplied in a block" do
        it "sets #{attr}" do
          @frete = Correios::Frete::Calculador.new { |f| f.send("#{attr}=", value) }
          @frete.send(attr).should == value
        end
      end
    end
  end

  describe "#calcular" do
    around do |example|
      Correios::Frete.configure { |config| config.log_enabled = false }
      example.run
      Correios::Frete.configure { |config| config.log_enabled = true }
    end

    before :each do
      @frete = Correios::Frete::Calculador.new
    end

    context "to many services" do
      before :each do
        fake_request_for(:success_response_many_services)
      end

      it "returns all services" do
        @frete.calcular(:pac, :sedex).keys.should == [:pac, :sedex]
      end
    end

    context "to one service" do
      before :each do
        fake_request_for(:success_response_one_service)
      end

      it "returns only one service" do
        @frete.calcular(:sedex).tipo.should == :sedex
      end
    end
  end

  ["calcular", "calculate"].each do |method_name|
    Correios::Frete::Servico::AVAILABLE_SERVICES.each do |key, service|
      describe "##{method_name}_#{service[:type]}" do
        before :each do
          @frete = Correios::Frete::Calculador.new
          @servico = Correios::Frete::Servico.new

          web_service = mock(Correios::Frete::WebService, :request! => "XML")
          Correios::Frete::WebService.stub(:new).and_return(web_service)

          parser = mock(Correios::Frete::Parser, :servicos => { service[:type] => @servico })
          Correios::Frete::Parser.stub(:new).and_return(parser)
        end

        it "calculates #{service[:name]}" do
          @frete.send("#{method_name}_#{service[:type]}").should == @servico
        end

        it "returns true when method exists" do
          subject.respond_to?("#{method_name}_#{service[:type]}").should be_true
        end
      end
    end

    describe "##{method_name}_servico_que_nao_existe" do
      before(:each) { @frete = Correios::Frete::Calculador.new }

      it "raises NoMethodError" do
        expect { @frete.send("#{method_name}_servico_que_nao_existe") }.to raise_error(NoMethodError)
      end
    end
  end
end
