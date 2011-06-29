# encoding: UTF-8
class Correios::Frete::WebService
  FORMATS = {
    :caixa_pacote => 1,
    :rolo_prisma => 2
  }

  SERVICES = {
    :pac => "41106",
    :sedex => "40010",
    :sedex_10 => "40215",
    :sedex_hoje => "40290"
  }

  def request(services)
    puts "Correios::FreteService#request called."
  end
end
