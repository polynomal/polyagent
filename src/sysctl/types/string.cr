require "../byte_buffer"

class Sysctl::String < ByteBuffer
  def value
    io = IO::Memory.new
    bytes.each do |byte|
      io.write_bytes(byte, IO::ByteFormat::LittleEndian)
    end

    # Hack. If our {bytes} array was the correct Int type, we wouldn't need this.
    io.to_s.gsub("\u0000", "")
  end
end
