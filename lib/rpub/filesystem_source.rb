module Rpub
  module FilesystemSource
    def read(filename)
      File.read(filename)
    end

    def write(filename, content, force = false)
      return if content.nil?
      if !force && File.exist?(filename)
        warn "Not overriding #{filename}"
        return
      end
      File.open(filename, 'w') do |f|
        f.write content
      end
    end

    def force_write(filename, content)
      write filename, content, true
    end

    def remove(filename, dry_run = false)
      if File.exist?(filename)
        if dry_run
          puts filename
        else
          File.unlink(filename)
        end
      end
    end

    extend self
  end
end
