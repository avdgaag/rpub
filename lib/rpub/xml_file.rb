module RPub
  class XmlFile
    attr_reader :xml

    def initialize
      @xml = Builder::XmlMarkup.new :indent => 2
    end

    def to_s
      render
      xml.target!
    end
  end
end
