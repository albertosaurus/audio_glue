require 'sox'

require 'forwardable'
require 'fileutils'
require 'tempfile'

require 'audio_glue/snippet'
require 'audio_glue/snippet_packet'
require 'audio_glue/template'

require 'audio_glue/adapters/base_adapter'
require 'audio_glue/adapters/plain_sox_adapter'

require 'audio_glue/builder'



module AudioGlue

  class Error < StandardError
  end

  class AbstractMethodCallError < Error
  end
end
