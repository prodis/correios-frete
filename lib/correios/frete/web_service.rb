# encoding: UTF-8
require 'net/http'
require 'uri'

module Correios
  module Frete
    class WebService
      URL = "http://ws.correios.com.br/calculador/CalcPrecoPrazo.aspx"
      FORMATS = { :caixa_pacote => 1, :rolo_prisma => 2 }
      CONDITIONS = { true => "S", false => "N" }

      def request(frete, service_types)
        @url = "#{URL}?#{params_for(frete, service_types)}"
        with_log { Net::HTTP.get_response URI.parse(@url) }
      end

      private

      def params_for(frete, service_types)
        "sCepOrigem=#{frete.cep_origem}&" +
        "sCepDestino=#{frete.cep_destino}&" +
        "nVlPeso=#{frete.peso}&" +
        "nVlComprimento=#{frete.comprimento}&" +
        "nVlAltura=#{frete.altura}&" +
        "nVlLargura=#{frete.largura}&" +
        "nVlDiametro=#{frete.diametro}&" +
        "nCdFormato=#{FORMATS[frete.formato]}&" +
        "sCdMaoPropria=#{CONDITIONS[frete.mao_propria]}&" +
        "sCdAvisoRecebimento=#{CONDITIONS[frete.aviso_recebimento]}&" +
        "nVlValorDeclarado=#{format("%.2f" % frete.valor_declarado)}&" +
        "nCdServico=#{service_codes_for(service_types)}&" +
        "nCdEmpresa=#{frete.codigo_empresa}&" +
        "sDsSenha=#{frete.senha}&" +
        "StrRetorno=xml"
      end

      def service_codes_for(service_types)
        service_types.map { |type| Correios::Frete::Servico.code_from_type(type) }.join(",")
      end

      def with_log
        Correios::Frete.log format_request_message
        response = yield
        Correios::Frete.log format_response_message(response)
        response.body
      end

      def format_request_message
        message =  with_line_break { "Correios-Frete Request:" }
        message << with_line_break { @url }
      end

      def format_response_message(response)
        message =  with_line_break { "Correios-Frete Response:" }
        message << with_line_break { "HTTP/#{response.http_version} #{response.code} #{response.message}" }
        message << with_line_break { format_headers_for(response) } if Correios::Frete.log_level == :debug
        message << with_line_break { response.body }
      end

      def format_headers_for(http)
        # I'm using an empty block in each_header method for Ruby 1.8.7 compatibility.
        http.each_header{}.map { |name, values| "#{name}: #{values.first}" }.join("\n")
      end

      def with_line_break
        "#{yield}\n"
      end
    end
  end
end
