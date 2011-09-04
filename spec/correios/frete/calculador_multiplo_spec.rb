# encoding: UTF-8
require 'spec_helper'

describe Correios::Frete::CalculadorMultiplo do
  describe "should create with default values" do
    frete = Correios::Frete::CalculadorMultiplo.new
    frete.mao_propria.should == false
    frete.aviso_recebimento.should == false
    frete.valor_declarado.should == 0.0
  end
  
  describe "should create frete with specified values" do
    frete = Correios::Frete::CalculadorMultiplo.new(  :cep_origem => "04094-050",
                                                      :cep_destino => "90619-900",
                                                      :mao_propria => true,
                                                      :aviso_recebimento => true,
                                                      :valor_declarado => 10.0)
    frete.cep_origem.should == "04094-050"
    frete.cep_destino.should == "90619-900"
    frete.mao_propria.should == true
    frete.aviso_recebimento.should == true
    frete.valor_declarado.should == 10.0
  end
  
  describe "should calculate a single item as Calculador" do
    
    frete_unico = Correios::Frete::Calculador.new(  :cep_origem => "04094-050",
                                                    :cep_destino => "90619-900",
                                                    :peso => 0.3,
                                                    :comprimento => 30,
                                                    :largura => 15,
                                                    :altura => 2)
    
    frete_multiplo = Correios::Frete::CalculadorMultiplo.new( :cep_origem => "04094-050",
                                                              :cep_destino => "90619-900")
    frete_multiplo.add_item(:peso => 0.3, :comprimento => 30, :largura => 15, :altura => 2)
    
    frete_unico.calcular_sedex.valor.should == frete_multiplo.calcular_sedex.valor
  end
  
  describe "should calculate multiple items" do    
    frete_multiplo = Correios::Frete::CalculadorMultiplo.new( :cep_origem => "04094-050",
                                                              :cep_destino => "90619-900")
    frete_multiplo.add_item(:peso => 0.3, :comprimento => 30, :largura => 15, :altura => 2)
    frete_multiplo.add_item(:peso => 10, :comprimento => 40, :diametro => 5)
    frete_multiplo.calcular_sedex.success?.should == true
  end
end