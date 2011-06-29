# encoding: utf-8

module Correios
  class Frete
    attr_accessor :cep_origem, :cep_destino
    attr_accessor :peso, :comprimento, :altura, :largura, :diametro
    attr_accessor :formato, :mao_propria, :aviso_recebimento, :valor_declarado
    attr_writer :frete_service, :frete_parser

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

    def frete_service
      @frete_service ||= FreteService.new
    end

    def frete_parser
      @frete_parser ||= FreteParser.new
    end

    def calculate(*services)
      response = @frete_service.request services
      @frete_parser.servicos response
    end
  end
end
