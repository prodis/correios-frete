# encoding: UTF-8
require 'net/http'
require 'uri'

class Correios::Frete::WebService
  URL = "http://ws.correios.com.br/calculador/CalcPrecoPrazo.aspx"
  FORMATS = { :caixa_pacote => 1, :rolo_prisma => 2 }
  CONDITIONS = { true => "S", false => "N" }

  def request(frete, service_types)
    Net::HTTP.get(URI.parse("#{URL}?#{params_for(frete, service_types)}"))
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
    service_types.map { |type| Correios::Frete::Servico::TYPES[type] }.join(",")
  end
end
