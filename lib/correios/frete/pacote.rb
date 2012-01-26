# encoding: UTF-8
module Correios
  module Frete
    class Pacote
      attr_reader :peso, :comprimento, :altura, :largura, :volume

      MIN_DIMENSIONS = {
        :comprimento => 16.0,
        :largura => 11.0,
        :altura => 2.0
      }

      def initialize(itens = nil)
        @peso = @comprimento = @largura = @altura = @volume = 0.0
        @itens = []

        itens.each { |item| adicionar_item(item) } if itens
      end

      def formato
        :caixa_pacote
      end

      def itens
        @itens
      end
      alias items itens

      def adicionar_item(item)
        return unless item

        item = Correios::Frete::PacoteItem.new(item) if item.is_a?(Hash)
        @itens << item

        calcular_medidas(item)
        item
      end
      alias add_item adicionar_item

      private

      def calcular_medidas(item)
        @peso += item.peso
        @volume += item.volume

        if @itens.size == 1
          @comprimento = item.comprimento
          @largura = item.largura
          @altura = item.altura
        else
          dimensao = @volume.to_f**(1.0/3)
          @comprimento = @largura = @altura = dimensao
        end

        min_dimension_values
      end

      def min_dimension_values()
        @comprimento = min(@comprimento, MIN_DIMENSIONS[:comprimento])
        @largura = min(@largura, MIN_DIMENSIONS[:largura])
        @altura = min(@altura, MIN_DIMENSIONS[:altura])
      end

      def min(value, minimum)
        (value < minimum) ? minimum : value
      end
    end
  end
end
