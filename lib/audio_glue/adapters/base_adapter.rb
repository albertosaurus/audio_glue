module AudioGlue
  # Base adapter which specifies interface for all adapters.
  # The responsibility of an adapter is to build output audio file
  # from a {AudioGlue::SnippetPacket snippet packet} which provides collection
  # of input audio sources and some parameters for output file(rate, number
  # channels).
  #
  # Adapter can rely on different tools and libraries to process audio files.
  # Also adapter is responsible for correctly processing remote files(e.g.
  # downloading them as temporary files if necessary).
  class BaseAdapter
    attr_reader :snippet_packet

    # @param snippet_packet [AudioGlue::SnippetPacket] snippet packet which
    #   contains snippets that provide locations of audio sources.
    def initialize(snippet_packet)
      @snippet_packet = snippet_packet
    end

    # Build audio file and return result as binary string.
    #
    # @return [String]
    def build
      raise AbstractMethodCallError, __method__
    end
  end
end
