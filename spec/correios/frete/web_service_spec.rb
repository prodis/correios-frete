# encoding: UTF-8
require 'spec_helper'

describe Correios::Frete::WebService do
  describe "#request" do
    before :each do
      @frete = Correios::Frete.new :cep_origem => "01000-000",
                                   :cep_destino => "021222-222",
                                   :peso => 0.321,
                                   :comprimento => 12.5,
                                   :altura => 1.4,
                                   :largura => 4.6,
                                   :diametro => 5.0,
                                   :formato => :rolo_prisma,
                                   :mao_propria => true,
                                   :aviso_recebimento => false,
                                   :valor_declarado => 1.99,
                                   :codigo_empresa => "1234567890",
                                   :senha => "senha"
      url = "http://ws.correios.com.br/calculador/CalcPrecoPrazo.aspx?" +
            "sCepOrigem=01000-000&" +
            "sCepDestino=021222-222&" +
            "nVlPeso=0.321&" +
            "nVlComprimento=12.5&" +
            "nVlAltura=1.4&" +
            "nVlLargura=4.6&" +
            "nVlDiametro=5.0&" +
            "nCdFormato=2&" +
            "sCdMaoPropria=S&" +
            "sCdAvisoRecebimento=N&" +
            "nVlValorDeclarado=1.99&" +
            "nCdServico=41106,40010&" +
            "nCdEmpresa=1234567890&" +
            "sDsSenha=senha&" +
            "StrRetorno=xml"
      Net::HTTP.stub(:get).with(URI.parse(url)).and_return("<xml><fake></fake>")
      @web_service = Correios::Frete::WebService.new
    end

    it "returns XML response" do
      @web_service.request(@frete, [:pac, :sedex]).should == "<xml><fake></fake>"
    end
  end
end
