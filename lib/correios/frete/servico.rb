# encoding: UTF-8
require 'sax-machine'

module Correios
  module Frete
    class Servico
      include SAXMachine

      AVAILABLE_SERVICES = {
        "41106" => { :type => :pac,                         :name => "PAC",            :description => "PAC sem contrato"                  },
        "41068" => { :type => :pac_com_contrato,            :name => "PAC",            :description => "PAC com contrato"                  },
        "40010" => { :type => :sedex,                       :name => "SEDEX",          :description => "SEDEX sem contrato"                },
        "40045" => { :type => :sedex_a_cobrar,              :name => "SEDEX a Cobrar", :description => "SEDEX a Cobrar, sem contrato"      },
        "40126" => { :type => :sedex_a_cobrar_com_contrato, :name => "SEDEX a Cobrar", :description => "SEDEX a Cobrar, com contrato"      },
        "40215" => { :type => :sedex_10,                    :name => "SEDEX 10",       :description => "SEDEX 10, sem contrato"            },
        "40290" => { :type => :sedex_hoje,                  :name => "SEDEX Hoje",     :description => "SEDEX Hoje, sem contrato"          },
        "40096" => { :type => :sedex_com_contrato_1,        :name => "SEDEX",          :description => "SEDEX com contrato"                },
        "40436" => { :type => :sedex_com_contrato_2,        :name => "SEDEX",          :description => "SEDEX com contrato"                },
        "40444" => { :type => :sedex_com_contrato_3,        :name => "SEDEX",          :description => "SEDEX com contrato"                },
        "40568" => { :type => :sedex_com_contrato_4,        :name => "SEDEX",          :description => "SEDEX com contrato"                },
        "40606" => { :type => :sedex_com_contrato_5,        :name => "SEDEX",          :description => "SEDEX com contrato"                },
        "81019" => { :type => :e_sedex,                     :name => "e-SEDEX",        :description => "e-SEDEX, com contrato"             },
        "81027" => { :type => :e_sedex_prioritario,         :name => "e-SEDEX",        :description => "e-SEDEX Prioritário, com contrato" },
        "81035" => { :type => :e_sedex_express,             :name => "e-SEDEX",        :description => "e-SEDEX Express, com contrato"     },
        "81868" => { :type => :e_sedex_grupo_1,             :name => "e-SEDEX",        :description => "(Grupo 1) e-SEDEX, com contrato"   },
        "81833" => { :type => :e_sedex_grupo_2,             :name => "e-SEDEX",        :description => "(Grupo 2) e-SEDEX, com contrato"   },
        "81850" => { :type => :e_sedex_grupo_3,             :name => "e-SEDEX",        :description => "(Grupo 3) e-SEDEX, com contrato"   }
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
      attr_reader :tipo, :nome, :descricao

      alias_method :original_parse, :parse

      def parse(xml_text)
        original_parse xml_text

        if AVAILABLE_SERVICES[codigo]
          @tipo = AVAILABLE_SERVICES[codigo][:type]
          @nome = AVAILABLE_SERVICES[codigo][:name]
          @descricao = AVAILABLE_SERVICES[codigo][:description]
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
