# encoding: UTF-8
require 'spec_helper'

describe Correios::Frete::Servico do
  describe "#parse" do
    before :each do
      @servico = Correios::Frete::Servico.new
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
end
