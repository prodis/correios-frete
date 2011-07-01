# encoding: UTF-8
require 'nokogiri'

class Correios::Frete::Parser
  SERVICES = {
    :pac => "41106",
    :sedex => "40010",
    :sedex_10 => "40215",
    :sedex_hoje => "40290"
  }

  def servicos(xml)
    servicos = {}

    Nokogiri::XML(xml).root.elements.each do |element|
      servico = Correios::Frete::Servico.new.parse(element.to_xml)
      servicos[servico.type] = servico
    end

    servicos
  end
end
