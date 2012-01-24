# encoding: UTF-8
module Correios
  module Frete
    class Pacote
      attr_reader :peso, :comprimento, :altura, :largura, :volume

      def initialize()
        @peso = @comprimento = @largura = @altura = @volume = 0.0
        @itens = []
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
          @comprimento = dimensao
          @largura = dimensao
          @altura = dimensao
        end
      end
    end
  end
end
