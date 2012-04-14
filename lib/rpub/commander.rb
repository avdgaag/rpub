module RPub
  module Commander
    def invoke(args = [])
      subcommand, *options = args
      Commands::Base.matching(subcommand).new(options).invoke
    rescue SubclassTracker::NoSuchSubclass
      Commands::Main.new(args).invoke
    end

    extend self
  end
end
