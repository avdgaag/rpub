module Rpub
  # The +Commander+ module is responsible for invoking `Command` objects. This is
  # the internal part of the library that is used by the CLI.
  #
  # The +Commander+ takes a list of arguments, which would typically come from the CLI,
  # and tries to look up a +Command+ class. If it cannot find anything, it will invoke
  # the {Rpub::Commands::Main} command.
  #
  # @see Rpub::Commands::Base
  # @see Rpub::Commands
  module Commander
    def invoke(args = [])
      subcommand, *options = args
      Commands::Base.matching(subcommand).new(options).invoke
    rescue SubclassTracker::NoSuchSubclass
      Commands::Main.new(args).invoke
    rescue NoConfiguration
      abort 'The current directory does not look like an rpub project.'
    end

    extend self
  end
end
