require 'sox'

require 'forwardable'
require 'fileutils'
require 'tempfile'

require 'audio_glue/snippet'
require 'audio_glue/snippet_packet'

require 'audio_glue/template/head_context'
require 'audio_glue/template/body_context'
require 'audio_glue/template'

require 'audio_glue/adapters/base_adapter'
require 'audio_glue/adapters/plain_sox_adapter'

require 'audio_glue/builder'

require 'audio_glue/template_loader'



module AudioGlue

  class Error < StandardError
  end

  class AbstractMethodCallError < Error
  end

  # Can be raised on attempt to load glue template.
  class LoadTemplateError < Error
  end
end
