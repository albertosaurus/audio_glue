module AudioGlue
  # Base adapter that specifies interface for all adapters.
  # The responsibility of an adapter is to build an output audio file
  # from a {AudioGlue::SnippetPacket snippet packet}, which provides
  # a collection of input audio sources and some parameters for the output file
  # (rate, number of channels).
  #
  # An adapter can rely on different tools and libraries to process audio
  # files. Also an adapter is responsible for correctly processing remote files
  # (e.g. downloading them as temporary files if necessary).
  class BaseAdapter
    # Build audio file from a snippet packet and return result as binary string.
    #
    # @param snippet_packet [AudioGlue::SnippetPacket]
    #
    # @return [String]
    def build(snippet_packet)
      raise AbstractMethodCallError, __method__
    end
  end
end
