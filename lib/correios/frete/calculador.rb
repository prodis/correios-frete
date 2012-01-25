# encoding: UTF-8
module Correios
  module Frete
    class Calculador
      attr_accessor :cep_origem, :cep_destino
      attr_accessor :diametro, :mao_propria, :aviso_recebimento, :valor_declarado
      attr_accessor :codigo_empresa, :senha, :encomenda
      attr_writer :peso, :comprimento, :largura, :altura, :formato

      DEFAULT_OPTIONS = {
        :peso => 0.0,
        :comprimento => 0.0,
        :largura => 0.0,
        :altura => 0.0,
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

      [:peso, :comprimento, :largura, :altura, :formato].each do |method|
        define_method method do
          @encomenda ? @encomenda.send(method) : instance_variable_get("@#{method}")
        end
      end

      def calcular(*service_types)
        response = web_service(service_types).request!
        services = parser.servicos(response)

        if service_types.size == 1
          services.values.first
        else
          services
        end
      end
      alias calculate calcular

      def method_missing(method_name, *args)
        return calcular($2.to_sym) if method_name.to_s =~ /^(calcular|calculate)_(.*)/ && Correios::Frete::Servico.code_from_type($2.to_sym)
        super
      end

      def respond_to?(method_name)
        return true if method_name.to_s =~ /^(calcular|calculate)_(.*)/ && Correios::Frete::Servico.code_from_type($2.to_sym)
        super
      end

      private

      def web_service(service_types)
        Correios::Frete::WebService.new(self, service_types)
      end

      def parser
        @parser ||= Correios::Frete::Parser.new
      end
    end
  end
end
