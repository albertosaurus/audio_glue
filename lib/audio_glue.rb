require 'sox'

require 'forwardable'
require 'fileutils'
require 'tempfile'

require 'audio_glue/snippet'
require 'audio_glue/snippet_packet'
require 'audio_glue/template/head_context'
require 'audio_glue/template'
require 'audio_glue/adapters/base_adapter'
require 'audio_glue/adapters/plain_sox_adapter'
require 'audio_glue/builder'

require 'audio_glue/template_loader'


# AudioGlue is a library to concatenate audio snippets using templates.
# Consider it like ERB for audio files, where input is not text snippets,
# but audio snippets, and output is not a text, but an audio.
module AudioGlue
  # Basic error for AudioGlue errors
  class Error < StandardError
  end

  # Is raised on attempt to call not implemented method of object which class
  # inherits from an abstract class.
  class AbstractMethodCallError < Error
  end

  # Can be raised on attempt to load glue template.
  class LoadTemplateError < Error
  end

  # Can be raised while audio data is building
  class BuildError < Error
  end
end
