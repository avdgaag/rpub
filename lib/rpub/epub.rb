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
      if book.cover?
        target.compress_file 'OEBPS/cover.html', Cover.new(book)
        target.compress_file File.join('OEBPS', book.cover_image), File.read(book.cover_image)
      end
      if book.toc?
        target.compress_file 'OEBPS/toc.html', toc { HtmlToc.new(book).render }
      end
      book.each do |chapter|
        target.compress_file File.join('OEBPS', chapter.filename), chapter.to_html
      end
      book.images.each do |image|
        target.compress_file File.join('OEBPS', image), File.read(image)
      end
    end

  private

    def toc
      @body = yield
      ERB.new(File.read(book.layout)).result(binding)
    end
  end
end
