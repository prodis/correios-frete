# encoding: UTF-8
require 'correios/frete/logger'

module Correios
  module Frete
    extend Logger

    def self.configure
      yield self if block_given?
    end
  end
end
