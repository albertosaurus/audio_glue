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
# Consider it like ERB or HAML for audio files, where input is not text
# snippets, but audio snippets, and output is not text, but audio.
module AudioGlue
  # Basic error for AudioGlue errors.
  class Error < StandardError
  end

  # Raised on an attempt to call an unimplemented method of an object which
  # a class inherits from an abstract class.
  class AbstractMethodCallError < Error
  end

  # Raised on a failed attempt to load a glue template.
  class LoadTemplateError < Error
  end

  # Raised when audio data fails to be built.
  class BuildError < Error
  end
end
