# encoding: UTF-8
require 'net/http'
require 'uri'

class Correios::Frete::WebService
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
    "nVlValorDeclarado=#{frete.valor_declarado}&" +
    "nCdServico=#{service_codes_for(service_types)}&" +
    "nCdEmpresa=#{frete.codigo_empresa}&" +
    "sDsSenha=#{frete.senha}&" +
    "StrRetorno=xml"
  end

  def service_codes_for(service_types)
    service_types.map { |type| Correios::Frete::Servico.code_from_type(type) }.join(",")
  end

  def with_log
    Correios::Frete.log "Correios-Frete Request:\n#{@url}"
    response = yield
    Correios::Frete.log format_response_message(response)
    response.body
  end

  def format_response_message(response)
    message = "Correios-Frete Response:\n"
    message << "HTTP/#{response.http_version} #{response.code} #{response.message}\n"
    response.each_header { |header| message << "#{header}: #{response[header]}\n" }
    message << response.body
  end
end
