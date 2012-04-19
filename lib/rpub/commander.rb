module Rpub
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
