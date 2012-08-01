module Rpub
  class Epub
    class Content < XmlFile
      attr_reader :book

      MEDIA_TYPES = {
        'png' => 'image/png',
        'gif' => 'image/gif',
        'jpg' => 'image/jpeg',
        'svg' => 'image/svg+xml'
      }

      def initialize(book)
        @book = book
        super()
      end

      def render
        xml.instruct!
        xml.declare! :DOCTYPE, :package, :PUBLIC,  '-//W3C//DTD XHTML 1.1//EN', 'http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd'
        xml.package 'xmlns' => 'http://www.idpf.org/2007/opf', 'unique-identifier' => 'BookId', 'version' => '2.0' do
          xml.metadata 'xmlns:dc' => 'http://purl.org/dc/elements/1.1/', 'xmlns:opf' => 'http://www.idpf.org/2007/opf' do
            xml.dc :language,    book.config.fetch('language')
            xml.dc :title,       book.config.fetch('title')
            xml.dc :creator,     book.config.fetch('creator'), 'opf:role' => 'aut'
            xml.dc :publisher,   book.config.fetch('publisher')
            xml.dc :subject,     book.config.fetch('subject')
            xml.dc :identifier,  book.uid, :id => 'BookId'
            xml.dc :rights,      book.config.fetch('rights')
            xml.dc :description, book.config.fetch('description')

            if book.has_cover?
              xml.meta :name => 'cover', :content => 'cover-image'
            end
          end

          xml.manifest do
            xml.item 'id' => 'ncx', 'href' => 'toc.ncx', 'media-type' => 'application/x-dtbncx+xml'
            xml.item 'id' => 'css', 'href' => 'styles.css', 'media-type' => 'text/css'

            if book.has_fonts?
              book.fonts.each do |font|
                xml.item 'id' => File.basename(font), 'href' => font, 'media-type' => 'font/opentype'
              end
            end

            if book.has_cover?
              xml.item 'id' => 'cover', 'href' => 'cover.html', 'media-type' => 'application/xhtml+xml'
              xml.item 'id' => 'cover-image', 'href' => book.cover_image, 'media-type' => guess_media_type(book.cover_image)
            end

            book.images.each do |image|
              xml.item 'id' => File.basename(image), 'href' => image, 'media-type' => guess_media_type(image)
            end

            if book.has_toc?
              xml.item 'id' => 'toc', 'href' => 'toc.html', 'media-type' => 'application/xhtml+xml'
            end

            book.chapters.each do |chapter|
              xml.item 'id' => chapter.xml_id, 'href' => chapter.filename, 'media-type' => 'application/xhtml+xml'
            end
          end

          xml.spine 'toc' => 'ncx' do
            if book.has_cover?
              xml.itemref 'idref' => 'cover', 'linear' => 'no'
            end
            book.chapters.each do |chapter|
              xml.itemref 'idref' => chapter.xml_id
            end
          end

          if book.has_cover? || book.has_toc?
            xml.guide do
              if book.has_cover?
                xml.reference :type => 'cover', :title => 'Cover', :href => 'cover.html'
              end
              if book.has_toc?
                xml.reference :type => 'toc',   :title => 'Table of Contents', :href => 'toc.html'
              end
            end
          end
        end
      end

      private

      # TODO refactor into separate guesser object
      def guess_media_type(filename)
        MEDIA_TYPES.fetch(filename[/\.(gif|png|jpe?g|svg)$/, 1]) { 'image/png' }
      end
    end
  end
end

