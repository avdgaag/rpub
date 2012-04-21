module Rpub
  # Add tracking of subclasses to an existing class by extending it with
  # SubclassTracker.
  #
  # This allows you to set an identifier in a subclass using the +identifier+
  # macro, and find subclasses based on that value.
  #
  # Example:
  #
  #     class ParentClass
  #       extend SubclassTracker
  #     end
  #
  #     class ChildClass < ParentClass
  #       identifier 'foo'
  #     end
  #
  #     ParentClass.matching('foo') # => ChildClass
  #     ParentClass.matching('bar') # => raises SubclassTracker::NoSuchSubclass
  #
  # Note that you don't HAVE to set an identifier. If you don't, your child
  # class will never be found by +#matching+.
  module SubclassTracker
    class NoSuchSubclass < StandardError
      def initialize(subcommand)
        super "Unrecognized identifier: #{subcommand}"
      end
    end

    # Set or return the identifier for this class.
    def identifier(id = nil)
      return @identifier if id.nil?
      @identifier = id
    end

    def inherited(child)
      @subclasses ||= []
      @subclasses << child
      super
    end

    def each
      @subclasses ||= []
      @subclasses.each { |subclass| yield subclass }
    end

    def matching(identifier)
      find { |subclass| subclass.identifier === identifier } or raise NoSuchSubclass, identifier
    end

    include Enumerable
  end
end
