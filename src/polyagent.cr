module Polyagent
  VERSION = "0.1.0"
end


class ByteBuffer
  getter bytes : Array(Int64)

  def initialize(bytes : Array(Int64))
    @bytes = bytes
  end

  def to_s
    io = IO::Memory.new
    bytes.each do |byte|
      io.write_bytes(byte, IO::ByteFormat::LittleEndian)
    end
    io.to_s.gsub("\u0000", "") # hack :(
  end

  def to_i
    int = bytes[0]
    bytes.each_with_index do |byte, index|
      next if index == 0
      int |= byte << (8*index)
    end
    int
  end
end


lib LibC
  # `sysctl` and `sysctlbyname` man page: http://manpagez.com/man/3/sysctlbyname/osx-10.10.php

  # https://rust-lang-nursery.github.io/futures-api-docs/0.3.0-alpha.5/src/libc/unix/bsd/apple/mod.rs.html#2346
  fun sysctl(
    name    : UInt8*,
    namelen : LibC::UInt,
    oldp    : Void*,
    oldlenp : LibC::SizeT*,
    newp    : Void*,
    newlen  : LibC::SizeT
  )

  # https://rust-lang-nursery.github.io/futures-api-docs/0.3.0-alpha.5/src/libc/unix/bsd/apple/mod.rs.html#2353
  fun sysctlbyname(
    name    : LibC::Char*,
    oldp    : Void*,
    oldlenp : LibC::SizeT*,
    newp    : Void*,
    newlen  : LibC::SizeT
  )
end

class Sysctl
  def self.by_name(name : String)
    size = LibC::SizeT.new(0)

    # Find out how big our buffer needs to be
    LibC.sysctlbyname(name, nil, pointerof(size), nil, 0)

    # Make the buffer
    #
    # TODO: Can we change buffer type depending on {size} value?
    buf = Array(Int64).new(size, 0)

    # Re-run with the provided buffer
    #
    #   {buf.to_unsafe} returns a pointer to the internal buffer where self's
    #   elements are stored. Traditionally this is unsafe because if the buffer
    #   (array) grows, the internal buffer is reallocated which can cause our
    #   pointer to no longer reference itself.
    #
    #   However, we've mitigated the possibility for this be unsafe because the
    #   buffer is created with a fixed size. Using a fixed size ensures the
    #   buffer never grow which means, which prevents reallocation, which
    #   prevents the pointer from moving.
    LibC.sysctlbyname(name, buf.to_unsafe, pointerof(size), nil, 0)

    ByteBuffer.new(buf)
  end
end

p Sysctl.by_name("hw.machine").to_s
p Sysctl.by_name("hw.model").to_s
p Sysctl.by_name("hw.physicalcpu").to_i
p Sysctl.by_name("hw.busfrequency_min").to_i
p Sysctl.by_name("hw.l3cachesize").to_i
