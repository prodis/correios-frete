# encoding: UTF-8
require 'spec_helper'

describe Correios::Frete::PacoteItem do
  describe ".new" do
    context "create with default value of" do
      before(:each) { @item = Correios::Frete::PacoteItem.new }

      { :peso => 0.0,
        :comprimento => 0.0,
        :altura => 0.0,
        :largura => 0.0
      }.each do |attr, value|
        it attr do
          @item.send(attr).should == value
        end
      end
    end

    { :peso => 0.321,
      :comprimento => 12.5,
      :altura => 1.4,
      :largura => 4.6
    }.each do |attr, value|
      context "when #{attr} is supplied" do
        it "sets #{attr}" do
          item = Correios::Frete::PacoteItem.new(attr => value)
          item.send(attr).should == value
        end
      end

      context "when #{attr} is supplied in a block" do
        it "sets #{attr}" do
          item = Correios::Frete::PacoteItem.new { |f| f.send("#{attr}=", value) }
          item.send(attr).should == value
        end
      end
    end
  end

  describe "#volume" do
    it "calculates item volume" do
      item = Correios::Frete::PacoteItem.new(:comprimento => 16, :altura => 2, :largura => 11)
      item.volume.should == 352
    end
  end
end
