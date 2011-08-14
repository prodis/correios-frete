# encoding: UTF-8
require 'spec_helper'

describe Correios::Frete do
  describe "#log_enabled?" do
    it "default is true" do
      Correios::Frete.log_enabled?.should be_true
    end

    context "when log is disabled" do
      around do |example|
        Correios::Frete.configure { |config| config.log_enabled = false }
        example.run
        Correios::Frete.configure { |config| config.log_enabled = true }
      end

      it "returns false" do
        Correios::Frete.log_enabled?.should be_false
      end
    end
  end

  describe "#logger" do
    it "default is Logger" do
      Correios::Frete.logger.should be_a(Logger)
    end

    context "when set logger" do
      it "returns set logger" do
        fake_logger = Class.new
        Correios::Frete.configure { |config| config.logger = fake_logger }
        Correios::Frete.logger.should == fake_logger
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
        @log_stream.string.should include("Some message to log.")
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
        @log_stream.string.should be_empty
      end
    end
  end
end
