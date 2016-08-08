# encoding: UTF-8
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
          expect(@pacote.send(attr)).to eq(value)
        end
      end

      it "itens" do
        expect(@pacote.itens).to be_empty
      end
    end

    context "when items are supplied" do
      context "as PacoteItem" do
        it "adds in items" do
          itens = [Correios::Frete::PacoteItem.new, Correios::Frete::PacoteItem.new]
          pacote = Correios::Frete::Pacote.new(itens)

          pacote.itens.each_with_index do |item, i|
            expect(item).to eq(itens[i])
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
            expect(item.peso).to eq(itens[i][:peso])
            expect(item.comprimento).to eq(itens[i][:comprimento])
            expect(item.largura).to eq(itens[i][:largura])
            expect(item.altura).to eq(itens[i][:altura])
          end
        end
      end
    end
  end

  describe "#formato" do
    it "is caixa/pacote" do
      expect(@pacote.formato).to eq(:caixa_pacote)
    end
  end

  describe "#adicionar_item" do
    context "when adds a package item" do
      it "adds in items" do
        item = Correios::Frete::PacoteItem.new
        @pacote.adicionar_item(item)
        expect(@pacote.itens.first).to eq(item)
      end
    end

    context "when adds package item params" do
      it "adds new item" do
        params = { :peso => 0.3, :comprimento => 30, :largura => 15, :altura => 2 }
        @pacote.adicionar_item(params)

        expect(@pacote.itens.first.peso).to eq(params[:peso])
        expect(@pacote.itens.first.comprimento).to eq(params[:comprimento])
        expect(@pacote.itens.first.largura).to eq(params[:largura])
        expect(@pacote.itens.first.altura).to eq(params[:altura])
      end
    end

    context "when adds nil item" do
      it "does not add" do
        @pacote.adicionar_item(nil)
        expect(@pacote.itens).to be_empty
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
        expect(@pacote.peso).to eq(@item.peso)
      end

      it "calculates package volume" do
        expect(@pacote.volume).to eq(@item.volume)
      end

      it "calculates package length" do
        expect(@pacote.comprimento).to eq(@item.comprimento)
      end

      it "calculates package width" do
        expect(@pacote.largura).to eq(@item.largura)
      end

      it "calculates package height" do
        expect(@pacote.altura).to eq(@item.altura)
      end

      context "with dimensions less than each minimum" do
        before :each do
          item = Correios::Frete::PacoteItem.new(:peso => 0.3, :comprimento => 15, :largura => 10, :altura => 1)
          @pacote = Correios::Frete::Pacote.new
          @pacote.adicionar_item(item)
        end

        it "sets minimum length value" do
          expect(@pacote.comprimento).to eq(16)
        end

        it "sets minimum width value" do
          expect(@pacote.largura).to eq(11)
        end

        it "sets minimum height value" do
          expect(@pacote.altura).to eq(2)
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

        @exceeded_dimensions = Correios::Frete::PacoteItem.new(
          :altura => Correios::Frete::Pacote::MAX_DIMENSIONS[:altura] + 1,
          :largura => Correios::Frete::Pacote::MAX_DIMENSIONS[:largura] + 1,
          :comprimento => Correios::Frete::Pacote::MAX_DIMENSIONS[:comprimento] + 1,
          :peso => 1.0
        )
      end

      it "calculates package weight" do
        expect(@pacote.peso).to eq(@item1.peso + @item2.peso)
      end

      it "calculates package volume" do
        expect(@pacote.volume).to eq(@item1.volume + @item2.volume)
      end

      it "calculates package length" do
        expect(@pacote.comprimento).to eq(@expected_dimension)
      end

      it "calculates package width" do
        expect(@pacote.largura).to eq(@expected_dimension)
      end

      it "calculates package height" do
        expect(@pacote.altura).to eq(@expected_dimension)
      end

      context "with dimensions less than each minimum" do
        before :each do
          item = Correios::Frete::PacoteItem.new(:peso => 0.3, :comprimento => 3, :largura => 1, :altura => 1)
          @pacote = Correios::Frete::Pacote.new
          @pacote.adicionar_item(item)
          @pacote.adicionar_item(item)
        end

        it "sets minimum length value" do
          expect(@pacote.comprimento).to eq(16)
        end

        it "sets minimum width value" do
          expect(@pacote.largura).to eq(11)
        end

        it "sets minimum height value" do
          expect(@pacote.altura).to eq(2)
        end
      end

      context "with at least one item dimension greater than maximum" do
        before :each do
          over_lengthened = Correios::Frete::PacoteItem.new(:peso => 0.3, :largura => 1, :altura => 1,
            :comprimento => @exceeded_dimensions.comprimento)

          too_wide  = Correios::Frete::PacoteItem.new(:peso => 0.3, :comprimento => 3, :altura => 1,
            :largura => @exceeded_dimensions.largura)

          over_heightened = Correios::Frete::PacoteItem.new(:peso => 0.3, :comprimento => 3, :largura => 1,
            :altura => @exceeded_dimensions.altura)

          @pacote = Correios::Frete::Pacote.new
          @pacote.adicionar_item(over_lengthened)
          @pacote.adicionar_item(too_wide)
          @pacote.adicionar_item(over_heightened)
        end

        it "shows biggest length value" do
          expect(@pacote.comprimento).to eq(@exceeded_dimensions.comprimento)
        end

        it "shows biggest width value" do
          expect(@pacote.largura).to eq(@exceeded_dimensions.largura)
        end

        it "shows biggest height value" do
          expect(@pacote.altura).to eq(@exceeded_dimensions.altura)
        end
      end

      context "over lengthed items with zero widht and height" do
        before :each do
          over_lengthened = Correios::Frete::PacoteItem.new(:peso => 0.3, :largura => 0, :altura => 0,
            :comprimento => @exceeded_dimensions.comprimento)

          @pacote = Correios::Frete::Pacote.new
          2.times{@pacote.adicionar_item(over_lengthened)}
        end

        it "does not get length information from minimum dimensions" do
          expect(@pacote.items.size).to eq(2)
          expect(@pacote.comprimento).to_not eq(Correios::Frete::Pacote::MIN_DIMENSIONS[:comprimento])
        end
      end

      context "over widthed items with zero length and height" do
        before :each do
          too_wide = Correios::Frete::PacoteItem.new(:peso => 0.3, :comprimento => 0, :altura => 0,
            :largura => @exceeded_dimensions.largura)

          @pacote = Correios::Frete::Pacote.new
          2.times{@pacote.adicionar_item(too_wide)}
        end

        it "does not get width information from minimum dimensions" do
          expect(@pacote.items.size).to eq(2)
          expect(@pacote.largura).to_not eq(Correios::Frete::Pacote::MIN_DIMENSIONS[:largura])
        end
      end

      context "over heighted items with zero widht and length" do
        before :each do
          over_heightened = Correios::Frete::PacoteItem.new(:peso => 0.3, :comprimento => 0, :largura => 0,
            :altura => @exceeded_dimensions.altura)

          @pacote = Correios::Frete::Pacote.new
          2.times{@pacote.adicionar_item(over_heightened)}
        end

        it "does not get height information from minimum dimensions" do
          expect(@pacote.items.size).to eq(2)
          expect(@pacote.altura).to_not eq(Correios::Frete::Pacote::MIN_DIMENSIONS[:altura])
        end
      end
    end
  end
end
