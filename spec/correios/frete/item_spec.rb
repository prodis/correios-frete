# encoding: UTF-8
require 'spec_helper'

describe Correios::Frete::Item do
  describe "should create with default values" do
    item = Correios::Frete::Item.new
    item.peso.should == 0.0
    item.comprimento.should == 0.0
    item.altura.should == 0.0
    item.largura.should == 0.0
    item.diametro.should == 0.0
  end
  
  describe "should create with specified values" do
    item = Correios::Frete::Item.new(:peso => 1, :comprimento => 2, :altura => 3, :largura => 4, :diametro => 5)
    item.peso.should == 1
    item.comprimento.should == 2
    item.altura.should == 3
    item.largura.should == 4
    item.diametro.should == 5
  end
  
  describe "should calculate the volume" do
    # Box
    item = Correios::Frete::Item.new(:peso => 1, :comprimento => 4, :altura => 4, :largura => 4, :diametro => 0)
    item.volume.should == 4*4*4
    
    # Cilinder
    item = Correios::Frete::Item.new(:peso => 1, :comprimento => 4, :altura => 0, :largura => 0, :diametro => 4)
    item.volume.should == Math::PI*4*(2**2)
  end
end