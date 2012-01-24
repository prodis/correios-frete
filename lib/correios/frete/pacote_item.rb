# encoding: UTF-8
module Correios
  module Frete
    class PacoteItem
      attr_accessor :peso, :comprimento, :altura, :largura

      DEFAULT_OPTIONS = {
        :peso => 0.0,
        :comprimento => 0.0,
        :altura => 0.0,
        :largura => 0.0
      }

      def initialize(options = {})
        DEFAULT_OPTIONS.merge(options).each do |attr, value|
          self.send("#{attr}=", value)
        end

        yield self if block_given?
      end

      def volume
        @comprimento * @altura * @largura
      end
    end
  end
end
