module Puppet::Parser::Functions
  newfunction(:hindsight_escape, :type => :rvalue, :doc => <<-EOS
  Escape string values
EOS
             ) do |args|

    if args.size != 1
      raise(Puppet::ParseError, "hindsight_escape(): Wrong number of args, given #{args.size}, accepts 1")
    end

    if args[0].instance_of? String
      return "'#{args[0]}'"
    end
    return args[0]
  end
end