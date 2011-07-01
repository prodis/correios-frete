# encoding: UTF-8
require 'spec_helper'

describe Correios::Frete::Servico do
  describe "#parse" do
    before(:each) { @servico = Correios::Frete::Servico.new }

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

      { :type => :pac,
        :codigo => "41106",
        :valor => 15.70,
        :prazo_entrega => 3,
        :valor_mao_propria => 3.75,
        :valor_aviso_recebimento => 1.99,
        :valor_valor_declarado => 1.50,
        :entrega_domiciliar => true,
        :entrega_sabado => false,
        :erro => -3,
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

      { :type => nil,
        :codigo => "99999",
        :valor => 0.0,
        :prazo_entrega => 0,
        :valor_mao_propria => 0.0,
        :valor_aviso_recebimento => 0.0,
        :valor_valor_declarado => 0.0,
        :entrega_domiciliar => false,
        :entrega_sabado => false,
        :erro => -1,
        :msg_erro => "Codigo de servico invalido"
      }.each do |attr, value|
        it "sets #{attr} to #{value}" do
          @servico.parse @xml
          @servico.send(attr).should == value
        end
      end
    end
  end
end
