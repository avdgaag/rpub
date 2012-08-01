module Rpub
  class Command
    attr_reader :args, :options

    def initialize(args, options)
      @args, @options = args, options
      run
    end

    protected

    def run
      raise 'Must be implemented by subclass'
    end

    def book
      @book ||= Book.new(context)
    end

    def context
      @context ||= Context.new({
        :layout => options.layout,
        :styles => options.styles,
        :config => options.config
      })
    end

    def source
      @source ||= Rpub::FilesystemSource
    end
  end
end
