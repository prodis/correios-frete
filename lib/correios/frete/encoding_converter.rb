# encoding: UTF-8
require 'iconv'

module Correios
  module Frete
    class EncodingConverter
      def self.from_iso_to_utf8(text)
        converter = Iconv.new "UTF-8", "ISO-8859-1"
        converter.iconv(text)
      end
    end
  end
end
