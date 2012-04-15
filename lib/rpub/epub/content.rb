module RPub
  class Epub
    class Content < XmlFile
      attr_reader :book

      def initialize(book)
        @book = book
        super()
      end

      def render
        xml.instruct!
        xml.declare! :DOCTYPE, :package, :PUBLIC,  '-//W3C//DTD XHTML 1.1//EN', 'http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd'
        xml.package 'xmlns' => 'http://www.idpf.org/2007/opf', 'unique-identifier' => 'BookId', 'version' => '2.0' do
          xml.metadata 'xmlns:dc' => 'http://purl.org/dc/elements/1.1/', 'xmlns:opf' => 'http://www.idpf.org/2007/opf' do
            xml.dc :language,    book.language
            xml.dc :title,       book.title
            xml.dc :creator,     book.creator, 'opf:role' => 'aut'
            xml.dc :publisher,   book.publisher
            xml.dc :subject,     book.subject
            xml.dc :identifier,  book.uid, :id => 'BookId'
            xml.dc :rights,      book.rights
            xml.dc :description, book.description
          end

          xml.manifest do
            xml.item 'id' => 'ncx', 'href' => 'toc.ncx', 'media-type' => 'application/x-dtbncx+xml'
            xml.item 'id' => 'css', 'href' => 'styles.css', 'media-type' => 'text/css'
            book.chapters.each do |chapter|
              xml.item 'id' => chapter.id, 'href' => chapter.filename, 'media-type' => 'application/xhtml+xml'
            end
          end

          xml.spine 'toc' => 'ncx' do
            book.chapters.each do |chapter|
              xml.itemref 'idref' => chapter.id
            end
          end
        end
      end
    end
  end
end

