module Rpub
  module Commands
    class Generate < Command
      def run
        all = [options.styles, options.layout, options.config].all? do |b|
          b.nil? || b == false
        end

        if (options.styles.nil? && all) || (!options.styles.nil? && options.styles)
          source.write 'styles.css', source.read(Rpub.support_file('styles.css'))
        end

        if (options.layout.nil? && all) || (!options.layout.nil? && options.layout)
          source.write 'layout.html', source.read(Rpub.support_file('layout.html'))
        end

        if (options.config.nil? && all) || (!options.config.nil? && options.config)
          source.write 'config.yml', source.read(Rpub.support_file('config.yml'))
        end
      end
    end
  end
end
