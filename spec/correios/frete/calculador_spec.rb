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
      :web_service => Correios::Frete::WebService.new,
      :parser => Correios::Frete::Parser.new
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
    before :each do
      @web_service = Correios::Frete::WebService.new
      @parser = Correios::Frete::Parser.new
      @frete = Correios::Frete::Calculador.new(:web_service => @web_service, :parser => @parser)
    end

    context "to many services" do
      before :each do
        @xml = '<?xml version="1.0" encoding="ISO-8859-1" ?><Servicos><cServico><Codigo>41106</Codigo><Valor>15,70</Valor><PrazoEntrega>3</PrazoEntrega><ValorMaoPropria>3,70</ValorMaoPropria><ValorAvisoRecebimento>0,00</ValorAvisoRecebimento><ValorValorDeclarado>1,50</ValorValorDeclarado><EntregaDomiciliar>S</EntregaDomiciliar><EntregaSabado>N</EntregaSabado><Erro>0</Erro><MsgErro></MsgErro></cServico><cServico><Codigo>40010</Codigo><Valor>17,80</Valor><PrazoEntrega>1</PrazoEntrega><ValorMaoPropria>3,70</ValorMaoPropria><ValorAvisoRecebimento>0,00</ValorAvisoRecebimento><ValorValorDeclarado>1,50</ValorValorDeclarado><EntregaDomiciliar>S</EntregaDomiciliar><EntregaSabado>S</EntregaSabado><Erro>0</Erro><MsgErro></MsgErro></cServico></Servicos>'
        @servicos = { :pac => Correios::Frete::Servico.new, :sedex => Correios::Frete::Servico.new }

        @parser.stub(:servicos).and_return(@servicos)
        @web_service.stub(:request).with(@frete, [:pac, :sedex]).and_return(@xml)
      end

      it "returns all services" do
        @frete.calcular(:pac, :sedex).should == @servicos
      end
    end

    context "to one service" do
      before :each do
        @xml = '<?xml version="1.0" encoding="ISO-8859-1" ?><cServico><Codigo>40010</Codigo><Valor>17,80</Valor><PrazoEntrega>1</PrazoEntrega><ValorMaoPropria>3,70</ValorMaoPropria><ValorAvisoRecebimento>0,00</ValorAvisoRecebimento><ValorValorDeclarado>1,50</ValorValorDeclarado><EntregaDomiciliar>S</EntregaDomiciliar><EntregaSabado>S</EntregaSabado><Erro>0</Erro><MsgErro></MsgErro></cServico></Servicos>'
        @servico = Correios::Frete::Servico.new

        @parser.stub(:servicos).and_return(:sedex => @servico)
        @web_service.stub(:request).with(@frete, [:sedex]).and_return(@xml)
      end

      it "returns only one service" do
        @frete.calcular(:sedex).should == @servico
      end
    end
  end

  ["calcular", "calculate"].each do |method_name|
    Correios::Frete::Servico::AVAILABLE_SERVICES.each do |key, service|
      describe "##{method_name}_#{service[:type]}" do
        before :each do
          web_service = Correios::Frete::WebService.new
          parser = Correios::Frete::Parser.new
          @frete = Correios::Frete::Calculador.new(:web_service => web_service, :parser => parser)
          @servico = Correios::Frete::Servico.new

          parser.stub(:servicos).and_return(service[:type] => @servico)
          web_service.stub(:request).with(@frete, [service[:type]]).and_return("XML")
        end

        it "calculates #{service[:name]}" do
          @frete.send("#{method_name}_#{service[:type]}").should == @servico
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
