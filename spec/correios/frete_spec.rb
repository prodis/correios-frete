# encoding: UTF-8
require 'spec_helper'

describe Correios::Frete do
  describe ".new" do
    context "create with default value of" do
      before(:each) { @frete = Correios::Frete.new }

      it "formato" do
        @frete.formato.should == :caixa_pacote
      end

      it "mao_propria" do
        @frete.mao_propria.should be_false
      end

      it "aviso_recebimento" do
        @frete.aviso_recebimento.should be_false
      end

      it "valor_declarado" do
        @frete.valor_declarado.should == 0
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
      :web_service => Correios::Frete::WebService.new,
      :parser => Correios::Frete::Parser.new
    }.each do |attr, value|
      context "when #{attr} is supplied" do
        it "set #{attr} value" do
          @frete = Correios::Frete.new(attr => value)
          @frete.send(attr).should == value
        end
      end

      context "when #{attr} is supplied in a block" do
        it "set #{attr} value" do
          @frete = Correios::Frete.new { |f| f.send("#{attr}=", value) }
          @frete.send(attr).should == value
        end
      end
    end
  end

  describe "#calculate" do
    before :each do
      @xml = '<?xml version="1.0" encoding="ISO-8859-1" ?><Servicos><cServico><Codigo>41106</Codigo><Valor>15,70</Valor><PrazoEntrega>3</PrazoEntrega><ValorMaoPropria>3,70</ValorMaoPropria><ValorAvisoRecebimento>0,00</ValorAvisoRecebimento><ValorValorDeclarado>1,50</ValorValorDeclarado><EntregaDomiciliar>S</EntregaDomiciliar><EntregaSabado>N</EntregaSabado><Erro>0</Erro><MsgErro></MsgErro></cServico><cServico><Codigo>40010</Codigo><Valor>17,80</Valor><PrazoEntrega>1</PrazoEntrega><ValorMaoPropria>3,70</ValorMaoPropria><ValorAvisoRecebimento>0,00</ValorAvisoRecebimento><ValorValorDeclarado>1,50</ValorValorDeclarado><EntregaDomiciliar>S</EntregaDomiciliar><EntregaSabado>S</EntregaSabado><Erro>0</Erro><MsgErro></MsgErro></cServico></Servicos>'
      @web_service = Correios::Frete::WebService.new
      @web_service.stub(:request).and_return(@xml)

      @servicos = { :pac => Correios::Frete::Servico.new, :sedex => Correios::Frete::Servico.new }
      @parser = Correios::Frete::Parser.new
      @parser.stub(:servicos).and_return(@servicos)

      @frete = Correios::Frete.new(:web_service => @web_service, :parser => @parser)
    end

    it "returns services" do
      @frete.calculate(:pac, :sedex).should == @servicos
    end
  end
end
