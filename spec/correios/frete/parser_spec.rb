# encoding: UTF-8
require 'spec_helper'

describe Correios::Frete::Parser do
  describe "#servicos" do
    before :each do
      @xml = """<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?>
                <Servicos>
                  <cServico>
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
                  </cServico>
                  <cServico>
                    <Codigo>40010</Codigo>
                    <Valor>17,80</Valor>
                    <PrazoEntrega>1</PrazoEntrega>
                    <ValorMaoPropria>3,70</ValorMaoPropria>
                    <ValorAvisoRecebimento>0,00</ValorAvisoRecebimento>
                    <ValorValorDeclarado>1,50</ValorValorDeclarado>
                    <EntregaDomiciliar>S</EntregaDomiciliar>
                    <EntregaSabado>S</EntregaSabado>
                    <Erro>0</Erro>
                    <MsgErro></MsgErro>
                  </cServico>
                </Servicos>"""
      @parser = Correios::Frete::Parser.new
    end

    { :pac => { :type => :pac,
                :codigo => "41106",
                :valor => 15.70,
                :prazo_entrega => 3,
                :valor_mao_propria => 3.75,
                :valor_aviso_recebimento => 1.99,
                :valor_valor_declarado => 1.50,
                :entrega_domiciliar => true,
                :entrega_sabado => false,
                :erro => -3,
                :msg_erro => "Somente para teste" },
      :sedex => { :type => :sedex,
                  :codigo => "40010",
                  :valor => 17.8,
                  :prazo_entrega => 1,
                  :valor_mao_propria => 3.70,
                  :valor_aviso_recebimento => 0.0,
                  :valor_valor_declarado => 1.5,
                  :entrega_domiciliar => true,
                  :entrega_sabado => true,
                  :erro => 0,
                  :msg_erro => nil }
    }.each do |service, attributes|
      it "returns #{service} data" do
        servicos = @parser.servicos @xml

        attributes.each do |attr, value|
          servicos[service].send(attr).should == value
        end
      end
    end
  end
end
