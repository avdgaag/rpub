module RPub
  class Chapter
    attr_reader :content, :number

    def initialize(content, chapter_number)
      @content  = content
      @number   = chapter_number
      @document = Kramdown::Document.new(content, :template => File.expand_path('../../../support/layout.html', __FILE__), :auto_ids => false)
    end

    def uid
      @uid ||= Digest::SHA1.hexdigest(content + id.to_s)
    end

    def id
      "chapter-#{number}"
    end

    def to_html
      @document.to_html
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
