require "../byte_buffer"

class Sysctl::Int < ByteBuffer
  def value
    int = bytes[0]
    bytes.each_with_index do |byte, index|
      next if index == 0
      int |= byte << (8*index)
    end
    int
  end
end
