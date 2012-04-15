module RPub
  class Epub
    attr_reader :book, :styles

    def initialize(book, styles)
      @book, @styles = book, styles
    end

    def manifest_in(target)
      target.store_file 'mimetype', 'application/epub+zip'
      target.compress_file 'META-INF/container.xml', Container.new
      target.compress_file 'OEBPS/content.opf', Content.new(book)
      target.compress_file 'OEBPS/toc.ncx', Toc.new(book)
      target.compress_file 'OEBPS/styles.css', styles
      book.each do |chapter|
        target.compress_file File.join('OEBPS', chapter.filename), chapter.to_html
      end
    end
  end
end
