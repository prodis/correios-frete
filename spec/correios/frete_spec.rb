# encoding: UTF-8
require 'spec_helper'

describe Correios::Frete do
  describe "#log_enabled?" do
    it "default is true" do
      expect(Correios::Frete.log_enabled?).to be_truthy
    end

    context "when log is disabled" do
      around do |example|
        Correios::Frete.configure { |config| config.log_enabled = false }
        example.run
        Correios::Frete.configure { |config| config.log_enabled = true }
      end

      it "returns false" do
        expect(Correios::Frete.log_enabled?).to be_falsey
      end
    end
  end

  describe "#logger" do
    it "default is Logger" do
      expect(Correios::Frete.logger).to be_a(Logger)
    end

    context "when set logger" do
      it "returns set logger" do
        fake_logger = Class.new
        Correios::Frete.configure { |config| config.logger = fake_logger }
        expect(Correios::Frete.logger).to eq(fake_logger)
      end
    end
  end

  describe "#log" do
    before :each do
      @log_stream = StringIO.new
      Correios::Frete.configure { |config| config.logger = Logger.new(@log_stream) }
    end

    context "when log is enabled" do
      it "logs the message" do
        Correios::Frete.log("Some message to log.")
        expect(@log_stream.string).to include("Some message to log.")
      end
    end

    context "when log is disabled" do
      around do |example|
        Correios::Frete.configure { |config| config.log_enabled = false }
        example.run
        Correios::Frete.configure { |config| config.log_enabled = true }
      end

      it "does not log the message" do
        Correios::Frete.log("Some message to log.")
        expect(@log_stream.string).to be_empty
      end
    end
  end

  describe "#request_timeout" do
    it "default is 10" do
      expect(Correios::Frete.request_timeout).to eql 10
    end

    context "when set timeout" do
      it "returns timeout" do
        Correios::Frete.configure { |config| config.request_timeout = 3 }
        expect(Correios::Frete.request_timeout).to eql 3
      end

      it "returns timeout in seconds (integer)" do
        Correios::Frete.configure { |config| config.request_timeout = 5.123 }
        expect(Correios::Frete.request_timeout).to eql 5
      end
    end
  end
end
