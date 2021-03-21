class ByteBuffer
  getter bytes

  def initialize(bytes : Array(Int64))
    @bytes = bytes
    prune_null_bytes!
  end

  def value
    raise NotImplementedError.new("ByteBuffer does not implement #value")
  end

  private def prune_null_bytes!
    bytes.reject! { |byte| byte == 0 }
  end
end
