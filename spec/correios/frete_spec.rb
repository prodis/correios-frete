# encoding: utf-8
require 'spec_helper'

describe Correios::Frete do
  describe ".new" do
    context "cria com valor padrão de" do
      before(:each) { @frete = Correios::Frete.new }

      it "formato" do
        @frete.formato.should == :caixa_pacote
      end

      it "mão própria" do
        @frete.mao_propria.should be_false
      end

      it "aviso de recebimento" do
        @frete.aviso_recebimento.should be_false
      end

      it "valor declarado" do
        @frete.valor_declarado.should == 0
      end
    end
  end
end
