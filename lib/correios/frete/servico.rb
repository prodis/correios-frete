# encoding: UTF-8
require 'sax-machine'

module Correios
  module Frete
    class Servico
      include SAXMachine

      AVAILABLE_SERVICES = {
        "41106" => { :type => :pac       , :name => "PAC"        },
        "40010" => { :type => :sedex     , :name => "SEDEX"      },
        "40215" => { :type => :sedex_10  , :name => "SEDEX 10"   },
        "40290" => { :type => :sedex_hoje, :name => "SEDEX Hoje" },
        "81019" => { :type => :e_sedex   , :name => "e-SEDEX"    }
      }

      element :Codigo, :as => :codigo
      element :Valor, :as => :valor
        element :PrazoEntrega, :as => :prazo_entrega
      element :ValorMaoPropria, :as => :valor_mao_propria
      element :ValorAvisoRecebimento, :as => :valor_aviso_recebimento
      element :ValorValorDeclarado, :as => :valor_valor_declarado
      element :EntregaDomiciliar, :as => :entrega_domiciliar
      element :EntregaSabado, :as => :entrega_sabado
      element :Erro, :as => :erro
      element :MsgErro, :as => :msg_erro
      attr_reader :tipo, :nome

      alias_method :original_parse, :parse

      def parse(xml_text)
        original_parse xml_text

        if AVAILABLE_SERVICES[codigo]
          @tipo = AVAILABLE_SERVICES[codigo][:type]
          @nome = AVAILABLE_SERVICES[codigo][:name]
        end

        cast_to_float! :valor, :valor_mao_propria, :valor_aviso_recebimento, :valor_valor_declarado
        cast_to_int! :prazo_entrega
        cast_to_boolean! :entrega_domiciliar, :entrega_sabado
        self
      end

      def success?
        erro == "0"
      end
      alias sucesso? success?

      def error?
        !success?
      end
      alias erro? error?

      def self.code_from_type(type)
        # I don't use select method for Ruby 1.8.7 compatibility.
        AVAILABLE_SERVICES.map { |key, value| key if value[:type] == type }.compact.first
      end

      private

      def cast_to_float!(*attributes)
        attributes.each do |attr|
          instance_variable_set("@#{attr}", send(attr).to_s.gsub("," ,".").to_f)
        end
      end

      def cast_to_int!(*attributes)
        attributes.each do |attr|
          instance_variable_set("@#{attr}", send(attr).to_i)
        end
      end

      def cast_to_boolean!(*attributes)
        attributes.each do |attr|
          instance_variable_set("@#{attr}", send(attr) == "S")
        end
      end
    end
  end
end
