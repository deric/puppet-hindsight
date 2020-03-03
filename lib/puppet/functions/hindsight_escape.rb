# frozen_string_literal: true

# @summary
#   Escape string values
Puppet::Functions.create_function(:hindsight_escape) do
  def hindsight_escape(*args)
    if args.size != 1
      raise(Puppet::ParseError, "hindsight_escape(): Wrong number of args, given #{args.size}, accepts 1")
    end

    if args[0].instance_of? String
      return "'#{args[0]}'"
    end

    args[0]
  end
end
