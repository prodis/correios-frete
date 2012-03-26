# encoding: UTF-8
require 'nokogiri'

module Correios
  module Frete
    class Parser
      def servicos(xml)
        servicos = {}

        Nokogiri::XML(xml).root.elements.each do |element|
          encode_msg_erro!(element)
          servico = Correios::Frete::Servico.new.parse(element.to_xml)
          servicos[servico.tipo] = servico
        end

        servicos
      end

      private

      def encode_msg_erro!(element)
        msg_erro_element = element.search("MsgErro").first.children.first
        msg_erro_element.content = Correios::Frete::EncodingConverter.from_iso_to_utf8(msg_erro_element.text) if msg_erro_element
      end
    end
  end
end
