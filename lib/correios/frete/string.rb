class String
  def backward_encode(to, from)
    if self.respond_to?(:encode)
      self.encode(to, from)
    else
      require 'iconv'
      Iconv.conv(to, from, self)
    end
  end
end
