require "../byte_buffer"

# {Sysctl::Raw} prunes null bytes (0 valued). In some cases, the 0
# might reflect an actual value.
class Sysctl::Raw < ByteBuffer
  def value
    bytes
  end
end
