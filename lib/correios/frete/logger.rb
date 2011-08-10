# encoding: UTF-8
require 'logger'

module Correios
  module Frete
    module Logger
      attr_writer :log_enabled
      attr_writer :logger

      def log_enabled?
        @log_enabled != false
      end

      def logger
        @logger ||= ::Logger.new STDOUT
      end

      def log(message)
        logger.info(message) if log_enabled?
      end
    end
  end
end
