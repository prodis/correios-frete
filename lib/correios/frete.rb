# encoding: utf-8

module Correios
  class Frete
    attr_accessor :cep_origem, :cep_destino
    attr_accessor :peso, :comprimento, :altura, :largura, :diametro
    attr_accessor :formato, :mao_propria, :aviso_recebimento, :valor_declarado

    ATRIBUTOS_PADRAO = {
      :formato => :caixa_pacote, 
      :mao_propria => false, 
      :aviso_recebimento => false, 
      :valor_declarado => 0
    }

    def initialize(atributos = {})
      ATRIBUTOS_PADRAO.merge(atributos).each do |atributo, valor|
        self.send("#{atributo}=", valor)
      end

      yield self if block_given?
    end
  end
end
