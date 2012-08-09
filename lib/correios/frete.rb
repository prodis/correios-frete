# encoding: UTF-8
require 'log-me'

module Correios
  module Frete
    extend LogMe

    module Timeout
      DEFAULT_REQUEST_TIMEOUT = 10 #seconds
      attr_writer :request_timeout

      def request_timeout
        (@request_timeout ||= DEFAULT_REQUEST_TIMEOUT).to_i
      end
    end

    extend Timeout
  end
end
