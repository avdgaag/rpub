module Rpub
  module Commands
    class Stats < Base
      identifier 'stats'
      include CompilationHelpers

      def invoke
        super
        text = Nokogiri::HTML(concatenated_document.to_html).xpath('//text()').to_s
        puts "#{text.words.size} words"
        puts "#{text.words.size / 500} pages"
        puts "#{text.sentences} sentences"
        puts "#{text.avg_sentence_length} avg sentence length"
        puts "#{text.ari} ari"
        puts "#{text.clf} clf"
      end
    end
  end
end
