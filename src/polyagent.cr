require "./sysctl"
require "./sysctl/**"

module Polyagent
  VERSION = "0.1.0"
end


p Sysctl.by_name("kern.hostname", coerce_into: Sysctl::String)
p Sysctl.by_name("kern.version", coerce_into: Sysctl::String)

p Sysctl.by_name("hw.machine", coerce_into: Sysctl::String)
p Sysctl.by_name("hw.model", coerce_into: Sysctl::String)
p Sysctl.by_name("hw.physicalcpu", coerce_into: Sysctl::Int)
p Sysctl.by_name("hw.busfrequency_min", coerce_into: Sysctl::Int)
p Sysctl.by_name("hw.l3cachesize", coerce_into: Sysctl::Int)
p Sysctl.by_name("hw.cachesize", coerce_into: Sysctl::Raw)
p Sysctl.by_name("hw.cpufamily", coerce_into: Sysctl::Int)
