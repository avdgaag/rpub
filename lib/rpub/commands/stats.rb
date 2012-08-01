module Rpub
  module Commands
    class Stats < Command
      def run
        text = Rpub::Preview.new(context, source).text
        puts "#{text.words.size} words"
        puts "#{(text.words.size.to_f / 500).ceil} pages"
        puts "#{text.sentences} sentences"
        puts "#{text.avg_sentence_length} avg sentence length"
        puts format("%.2f ari", text.ari)
        puts format("%.2f clf", text.clf)
      end
    end
  end
end
