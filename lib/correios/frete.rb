# encoding: UTF-8
module Correios
  class Frete
    attr_accessor :cep_origem, :cep_destino
    attr_accessor :peso, :comprimento, :altura, :largura, :diametro
    attr_accessor :formato, :mao_propria, :aviso_recebimento, :valor_declarado
    attr_writer :web_service, :parser

    DEFAULT_OPTIONS = {
      :formato => :caixa_pacote, 
      :mao_propria => false, 
      :aviso_recebimento => false, 
      :valor_declarado => 0.0
    }

    def initialize(options = {})
      DEFAULT_OPTIONS.merge(options).each do |attr, value|
        self.send("#{attr}=", value)
      end

      yield self if block_given?
    end

    def web_service
      @web_service ||= Correios::Frete::WebService.new
    end

    def parser
      @parser ||= Correios::Frete::Parser.new
    end

    def calculate(*service_types)
      response = web_service.request(self, service_types)
      parser.servicos response
    end
  end
end
