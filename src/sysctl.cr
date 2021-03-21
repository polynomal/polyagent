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

module Sysctl
  def self.by_name(name, coerce_into = nil)
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
    #   buffer never grows, which prevents reallocation, which prevents the
    #   pointer from moving.
    LibC.sysctlbyname(name, buf.to_unsafe, pointerof(size), nil, 0)

    if coerce_into != nil
      coerce_into.new(buf).value
    else
      Sysctl::Raw.new(buf).value
    end
  end
end
