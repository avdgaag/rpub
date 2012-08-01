module Rpub
  module MediaType
    MEDIA_TYPES = {
      'png' => 'image/png',
      'gif' => 'image/gif',
      'jpg' => 'image/jpeg',
      'svg' => 'image/svg+xml'
    }

    module_function

    def guess_media_type(filename)
      MEDIA_TYPES.fetch(filename[/\.(gif|png|jpe?g|svg)$/, 1]) { 'image/png' }
    end
  end
end
