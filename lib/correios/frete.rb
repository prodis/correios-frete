# encoding: UTF-8
module Correios
  class Frete
    attr_accessor :cep_origem, :cep_destino
    attr_accessor :peso, :comprimento, :altura, :largura, :diametro
    attr_accessor :formato, :mao_propria, :aviso_recebimento, :valor_declarado
    attr_writer :web_service, :parser

    DEFAULT_OPTIONS = {
      :peso => 0.0,
      :comprimento => 0.0,
      :altura => 0.0,
      :largura => 0.0,
      :diametro => 0.0,
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

    def calcular(*service_types)
      response = web_service.request(self, service_types)
      services = parser.servicos(response)

      if service_types.size == 1
        services.values.first
      else
        services
      end
    end
  end
end
