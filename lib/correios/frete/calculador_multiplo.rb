# encoding: UTF-8
module Correios
  module Frete
    class CalculadorMultiplo < Correios::Frete::Calculador
      attr_accessor :items, :volume

      DEFAULT_OPTIONS = {
        :mao_propria => false, 
        :aviso_recebimento => false, 
        :valor_declarado => 0.0
      }
      
      def initialize(options = {})
        @items = []
        super(options)
      end
      
      def calcular(*service_types)
        prepare_package
        super(*service_types)
      end
      
      def add_item(options = {})
        @items.push Item.new(options)
      end
            
      #
      # Prepare package is an experimental algorithm that estimates the weigh
      # and dimensions of the package that can fit a group of items.
      # It's taken the assumption that the Correios shipping costs are defined by
      # the density of a package (this way, we can focus on finding a valid shape
      # that has the summed volume of items).
      # If the final volume exceeds the Correios maximum volume (which is about 53**3 cm^3),
      # we normalize it so the shipping can be calculated.
      #
      # Credits: @barbolo
      #
      def prepare_package
        formato = :caixa_pacote
        peso = 0
        volume = 0
        items.each do |item|
          peso += item.peso
          volume += item.volume
        end
        
        if volume <= 352 # minimum volume for a package (16x11x2)
          comprimento = 16 # minimum length
          largura = 11 # minimum width
          altura = 2 # minimum height
          
        elsif volume < 4096 # minimum volume for a valid cube package (16x16x16)
          comprimento = 16
          largura = 11
          altura = 2
          
          area = altura*largura
          comprimento = (volume.to_f/area).ceil
          
          if comprimento > 90
            comprimento = 90
            area = comprimento*altura
            largura = (volume.to_f/area).ceil
          end
          
        else # for volumes greater than 4096, a cube package works perfectly (maximum edge = 53 cm)
          lado = [ ( volume**(1.0/3) ).ceil, 53].min
          comprimento = altura = largura = lado
          
        end
        
        @formato = formato
        @peso = peso
        @comprimento = comprimento
        @altura = altura
        @largura = largura
        @volume = comprimento*altura*largura
      end
      
    end
  end
end