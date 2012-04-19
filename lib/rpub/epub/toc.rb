module Rpub
  class Epub
    class Toc < XmlFile
      attr_reader :book

      def initialize(book)
        @book = book
        super()
      end

      def render
        xml.instruct!
        xml.declare! :DOCTYPE, :ncx, :PUBLIC, "-//W3C//DTD XHTML 1.1//EN", 'http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd'
        xml.ncx :xmlns => 'http://www.daisy.org/z3986/2005/ncx/', :version => '2005-1' do
          xml.head do
            xml.meta :name => 'dtb:uid', :content => @book.uid
            xml.meta :name => 'dtb:depth', :content => '1'
            xml.meta :name => 'dtb:totalPageCount', :content => '0'
            xml.meta :name => 'dtb:maxPageNumber', :content => '0'
          end
          xml.docTitle { xml.text @book.title }
          xml.navMap do
            @book.chapters.each_with_index do |chapter, n|
              xml.navPoint :id => chapter.id, :playOrder => n do
                xml.navLabel { xml.text chapter.title }
                xml.content :src => chapter.filename
              end
            end
          end
        end
      end
    end
  end
end

