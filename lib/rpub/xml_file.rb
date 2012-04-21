module Rpub
  class XmlFile
    # @return [Builder::XmlMarkup]
    attr_reader :xml

    def initialize
      @xml = Builder::XmlMarkup.new :indent => 2
    end

    # @return [String] render this file and output as string
    def to_s
      render
      xml.target!
    end
  end
end
