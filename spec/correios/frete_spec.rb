# encoding: utf-8
require 'spec_helper'

describe Correios::Frete do
  describe ".new" do
    context "create with default value of" do
      before(:each) { @frete = Correios::Frete.new }

      it "formato" do
        @frete.formato.should == :caixa_pacote
      end

      it "mao_propria" do
        @frete.mao_propria.should be_false
      end

      it "aviso_recebimento" do
        @frete.aviso_recebimento.should be_false
      end

      it "valor_declarado" do
        @frete.valor_declarado.should == 0
      end
    end

    { :cep_origem => "01000-000", 
      :cep_destino => "021222-222",
      :peso => 0.321, 
      :comprimento => 12.5, 
      :altura => 1.4, 
      :largura => 4.6, 
      :diametro => 5.0,
      :formato => :rolo_prisma, 
      :mao_propria => true, 
      :aviso_recebimento => true, 
      :valor_declarado => 1.99
    }.each do |attr, value|
      context "when #{attr} is supplied" do
        it "set #{attr} value" do
          @frete = Correios::Frete.new(attr => value)
          @frete.send(attr).should == value
        end
      end
    end
  end
end
