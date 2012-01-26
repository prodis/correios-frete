# encoding: UTF-8
require 'spec_helper'

describe Correios::Frete::Pacote do
  before(:each) { @pacote = Correios::Frete::Pacote.new }

  describe ".new" do
    context "creates with default value of" do
      { :peso => 0.0,
        :comprimento => 0.0,
        :altura => 0.0,
        :largura => 0.0
      }.each do |attr, value|
        it attr do
          @pacote.send(attr).should == value
        end
      end

      it "itens" do
        @pacote.itens.should be_empty
      end
    end

    context "when items are supplied" do
      context "as PacoteItem" do
        it "adds in items" do
          itens = [Correios::Frete::PacoteItem.new, Correios::Frete::PacoteItem.new]
          pacote = Correios::Frete::Pacote.new(itens)

          pacote.itens.each_with_index do |item, i|
            item.should == itens[i]
          end
        end
      end

      context "as Hash" do
        it "adds new items" do
          itens = [
            { :peso => 0.3, :comprimento => 30, :largura => 15, :altura => 2 },
            { :peso => 0.7, :comprimento => 70, :largura => 25, :altura => 3 }
          ]
          pacote = Correios::Frete::Pacote.new(itens)

          pacote.itens.each_with_index do |item, i|
            item.peso.should == itens[i][:peso]
            item.comprimento.should == itens[i][:comprimento]
            item.largura.should == itens[i][:largura]
            item.altura.should == itens[i][:altura]
          end
        end
      end
    end
  end

  describe "#formato" do
    it "is caixa/pacote" do
      @pacote.formato.should == :caixa_pacote
    end
  end

  describe "#adicionar_item" do
    context "when adds a package item" do
      it "adds in items" do
        item = Correios::Frete::PacoteItem.new
        @pacote.adicionar_item(item)
        @pacote.itens.first.should == item
      end
    end

    context "when adds package item params" do
      it "adds new item" do
        params = { :peso => 0.3, :comprimento => 30, :largura => 15, :altura => 2 }
        @pacote.adicionar_item(params)

        @pacote.itens.first.peso.should == params[:peso]
        @pacote.itens.first.comprimento.should == params[:comprimento]
        @pacote.itens.first.largura.should == params[:largura]
        @pacote.itens.first.altura.should == params[:altura]
      end
    end

    context "when adds nil item" do
      it "does not add" do
        @pacote.adicionar_item(nil)
        @pacote.itens.should be_empty
      end
    end
  end

  describe "calculations" do
    context "when adds one package item" do
      before :each do
        @item = Correios::Frete::PacoteItem.new(:peso => 0.3, :comprimento => 30, :largura => 15, :altura => 2)
        @pacote.adicionar_item(@item)
      end

      it "calculates package weight" do
        @pacote.peso.should == @item.peso
      end

      it "calculates package volume" do
        @pacote.volume.should == @item.volume
      end

      it "calculates package length" do
        @pacote.comprimento.should == @item.comprimento
      end

      it "calculates package width" do
        @pacote.largura.should == @item.largura
      end

      it "calculates package height" do
        @pacote.altura.should == @item.altura
      end

      context "with dimensions less than each minimum" do
        before :each do
          item = Correios::Frete::PacoteItem.new(:peso => 0.3, :comprimento => 15, :largura => 10, :altura => 1)
          @pacote = Correios::Frete::Pacote.new
          @pacote.adicionar_item(item)
        end

        it "sets minimum length value" do
          @pacote.comprimento.should == 16
        end

        it "sets minimum width value" do
          @pacote.largura.should == 11
        end

        it "sets minimum height value" do
          @pacote.altura.should == 2
        end
      end
    end

    context "when adds more than one package item" do
      before :each do
        @item1 = Correios::Frete::PacoteItem.new(:peso => 0.3, :comprimento => 30, :largura => 15, :altura => 2)
        @item2 = Correios::Frete::PacoteItem.new(:peso => 0.7, :comprimento => 70, :largura => 25, :altura => 3)
        @expected_dimension = (@item1.volume + @item2.volume).to_f**(1.0/3)

        @pacote.adicionar_item(@item1)
        @pacote.adicionar_item(@item2)
      end

      it "calculates package weight" do
        @pacote.peso.should == @item1.peso + @item2.peso
      end

      it "calculates package volume" do
        @pacote.volume.should == @item1.volume + @item2.volume
      end

      it "calculates package length" do
        @pacote.comprimento.should == @expected_dimension
      end

      it "calculates package width" do
        @pacote.largura.should == @expected_dimension
      end

      it "calculates package height" do
        @pacote.altura.should == @expected_dimension
      end

      context "with dimensions less than each minimum" do
        before :each do
          item = Correios::Frete::PacoteItem.new(:peso => 0.3, :comprimento => 3, :largura => 1, :altura => 1)
          @pacote = Correios::Frete::Pacote.new
          @pacote.adicionar_item(item)
          @pacote.adicionar_item(item)
        end

        it "sets minimum length value" do
          @pacote.comprimento.should == 16
        end

        it "sets minimum width value" do
          @pacote.largura.should == 11
        end

        it "sets minimum height value" do
          @pacote.altura.should == 2
        end
      end
    end
  end
end
