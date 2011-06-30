# encoding: UTF-8
require 'sax-machine'

class Correios::Frete::Servico
  include SAXMachine

  element :Codigo, :as => :codigo
  element :Valor, :as => :valor
  element :PrazoEntrega, :as => :prazo_entrega
  element :ValorMaoPropria, :as => :valor_mao_propria
  element :ValorAvisoRecebimento, :as => :valor_aviso_recebimento
  element :ValorValorDeclarado, :as => :valor_valor_declarado
  element :EntregaDomiciliar, :as => :entrega_domiciliar
  element :EntregaSabado, :as => :entrega_sabado
  element :Erro, :as => :erro
  element :MsgErro, :as => :msg_erro

  alias_method :original_parse, :parse

  def parse(xml_text)
    original_parse xml_text
    cast_to_float! :valor, :valor_mao_propria, :valor_aviso_recebimento, :valor_valor_declarado
    cast_to_int! :prazo_entrega, :erro
    cast_to_boolean! :entrega_domiciliar, :entrega_sabado
    self
  end

  private

  def cast_to_float!(*attributes)
    attributes.each do |attr|
      instance_variable_set("@#{attr}", send(attr).gsub("," ,".").to_f)
    end
  end

  def cast_to_int!(*attributes)
    attributes.each do |attr|
      instance_variable_set("@#{attr}", send(attr).to_i)
    end
  end

  def cast_to_boolean!(*attributes)
    attributes.each do |attr|
      instance_variable_set("@#{attr}", send(attr) == "S")
    end
  end
end
