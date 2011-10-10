# encoding: UTF-8
require 'spec_helper'

describe Correios::Frete::Servico do
  before(:each) { @servico = Correios::Frete::Servico.new }

  describe "#parse" do
    context "when service exists" do
      before :each do
        @xml = """<cServico>
                    <Codigo>41106</Codigo>
                    <Valor>15,70</Valor>
                    <PrazoEntrega>3</PrazoEntrega>
                    <ValorMaoPropria>3,75</ValorMaoPropria>
                    <ValorAvisoRecebimento>1,99</ValorAvisoRecebimento>
                    <ValorValorDeclarado>1,50</ValorValorDeclarado>
                    <EntregaDomiciliar>S</EntregaDomiciliar>
                    <EntregaSabado>N</EntregaSabado>
                    <Erro>-3</Erro>
                    <MsgErro>Somente para teste</MsgErro>
                  </cServico>"""
      end

      { :tipo => :pac,
        :nome => "PAC",
        :descricao => "PAC sem contrato",
        :codigo => "41106",
        :valor => 15.70,
        :prazo_entrega => 3,
        :valor_mao_propria => 3.75,
        :valor_aviso_recebimento => 1.99,
        :valor_valor_declarado => 1.50,
        :entrega_domiciliar => true,
        :entrega_sabado => false,
        :erro => "-3",
        :msg_erro => "Somente para teste"
      }.each do |attr, value|
        it "sets #{attr} to #{value}" do
          @servico.parse @xml
          @servico.send(attr).should == value
        end
      end
    end

    context "when service does not exist" do
      before :each do
        @xml = """<cServico>
                    <Codigo>99999</Codigo>
                    <Valor>0,00</Valor>
                    <PrazoEntrega>0</PrazoEntrega>
                    <ValorMaoPropria>0,00</ValorMaoPropria>
                    <ValorAvisoRecebimento>0,00</ValorAvisoRecebimento>
                    <ValorValorDeclarado>0,00</ValorValorDeclarado>
                    <EntregaDomiciliar></EntregaDomiciliar>
                    <EntregaSabado></EntregaSabado>
                    <Erro>-1</Erro>
                    <MsgErro>Codigo de servico invalido</MsgErro>
                  </cServico>"""
      end

      { :tipo => nil,
        :nome => nil,
        :codigo => "99999",
        :valor => 0.0,
        :prazo_entrega => 0,
        :valor_mao_propria => 0.0,
        :valor_aviso_recebimento => 0.0,
        :valor_valor_declarado => 0.0,
        :entrega_domiciliar => false,
        :entrega_sabado => false,
        :erro => "-1",
        :msg_erro => "Codigo de servico invalido"
      }.each do |attr, value|
        it "sets #{attr} to #{value}" do
          @servico.parse @xml
          @servico.send(attr).should == value
        end
      end
    end

    context "when there is an unexpected error" do
      before :each do
        @xml = """<cServico>
                    <Codigo></Codigo>
                    <Valor></Valor>
                    <PrazoEntrega></PrazoEntrega>
                    <ValorMaoPropria></ValorMaoPropria>
                    <ValorAvisoRecebimento></ValorAvisoRecebimento>
                    <ValorValorDeclarado></ValorValorDeclarado>
                    <EntregaDomiciliar></EntregaDomiciliar>
                    <EntregaSabado></EntregaSabado>
                    <Erro>99</Erro>
                    <MsgErro>Input string was not in a correct format.</MsgErro>
                  </cServico>"""
      end

      { :tipo => nil,
        :nome => nil,
        :codigo => nil,
        :valor => 0.0,
        :prazo_entrega => 0,
        :valor_mao_propria => 0.0,
        :valor_aviso_recebimento => 0.0,
        :valor_valor_declarado => 0.0,
        :entrega_domiciliar => false,
        :entrega_sabado => false,
        :erro => "99",
        :msg_erro => "Input string was not in a correct format."
      }.each do |attr, value|
        it "sets #{attr} to #{value}" do
          @servico.parse @xml
          @servico.send(attr).should == value
        end
      end
    end
  end

  describe "#success?" do
    context "when does not have error" do
      it "returns true" do
        @servico.parse "<cServico><Erro>0</Erro><cServico>"
        @servico.success?.should be_true
      end
    end

    context "when has error" do
      it "returns false" do
        @servico.parse "<cServico><Erro>7</Erro><cServico>"
        @servico.success?.should be_false
      end
    end
  end

  describe "#error?" do
    context "when has error" do
      it "returns true" do
        @servico.parse "<cServico><Erro>7</Erro><cServico>"
        @servico.error?.should be_true
      end
    end

    context "when does not have error" do
      it "returns false" do
        @servico.parse "<cServico><Erro>0</Erro><cServico>"
        @servico.error?.should be_false
      end
    end
  end

  describe ".code_from_type" do
    Correios::Frete::Servico::AVAILABLE_SERVICES.each do |code, value|
      context "to #{value[:type]} type" do
        it "returns #{code} code" do
          Correios::Frete::Servico.code_from_type(value[:type]).should == code
        end
      end
    end

    context "when type does not exist" do
      it "returns nil" do
        Correios::Frete::Servico.code_from_type(:nao_existe).should be_nil
      end
    end
  end
end
