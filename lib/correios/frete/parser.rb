# encoding: UTF-8
require 'nokogiri'

class Correios::Frete::Parser
  def servicos(xml)
    servicos = {}

    Nokogiri::XML(xml).root.elements.each do |element|
      servico = Correios::Frete::Servico.new.parse(element.to_xml)
      servicos[servico.tipo] = servico
    end

    servicos
  end
end
