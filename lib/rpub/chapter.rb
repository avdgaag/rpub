module RPub
  class Chapter
    attr_reader :content, :number, :layout

    def initialize(content, number, layout)
      @content, @number, @layout = content, number, layout
      @document = Kramdown::Document.new(content, KRAMDOWN_OPTIONS.merge(:template => layout))
    end

    def uid
      @uid ||= Digest::SHA1.hexdigest([content, id.to_s, layout].join)
    end

    def id
      @id ||= "chapter-#{number}"
    end

    def to_html
      @to_html ||= @document.to_html
    end

    def filename
      @filename ||= id.to_s + '-' + title.gsub(/[^\w\.]/i, '-').squeeze('-').downcase.chomp('-') + '.html'
    end

    def title
      @title ||= begin
        h = @document.root.children.find { |c| c.type == :header }
        return 'untitled' unless h
        collector = lambda do |c|
          c.children.collect do |cc|
            if cc.type == :text
              cc.value
            else
              collector.call cc
            end
          end.join ''
        end
        title = collector.call(h) || 'untitled'
      end
    end
  end
end
