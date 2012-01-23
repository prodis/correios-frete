# encoding: UTF-8
module Correios
  module Frete
    class Item
      attr_accessor :peso, :comprimento, :altura, :largura, :diametro
      
      DEFAULT_OPTIONS = {
        :peso => 0.0,
        :comprimento => 0.0,
        :altura => 0.0,
        :largura => 0.0,
        :diametro => 0.0
      }
      
      def initialize(options = {})
        DEFAULT_OPTIONS.merge(options).each do |attr, value|
          self.send("#{attr}=", value)
        end

        yield self if block_given?
      end
            
      def volume
        if comprimento > 0 and altura > 0 and largura > 0
          comprimento*altura*largura
        elsif comprimento > 0 and diametro > 0
          comprimento*Math::PI*( (diametro.to_f/2)**2 )
        else
          0
        end
      end
      
    end
  end
end