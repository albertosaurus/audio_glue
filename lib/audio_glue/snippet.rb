module AudioGlue
  # Represents an audio partial which will be used to build an output audio.
  # There are a few types of snippets:
  # * :file - represents audio file in local file system
  # * :url  - represents remote audio file
  #
  # Other custom types can be created if custom adapter will support them.
  #
  # {AudioGlue::BaseAdapter adapters} are responsible for processing every
  # particular snippet type.
  class Snippet
    attr_reader :type, :source, :snippet_packet, :opts

    # @param type [Symbol] :file, :url or anything else that can be handled by adapter
    # @param source [String] Can be location, URL, or whatever depending on type
    # @param snippet_packet [AudioGlue::SnippetPacket] the snippet packet used
    #   to add the audio snippet to the packet when `-` unary method is called
    # @params opts [Hash] any specific options which are supported by adapter
    def initialize(type, source, snippet_packet, opts = {})
      @type           = type
      @source         = source
      @snippet_packet = snippet_packet
      @opts           = opts
    end

    # Add self to the snippet packet.
    # It's used to support dash syntax in +.glue+ files, like:
    #   - file('/audio.mp3')
    #
    # @return [void]
    def -@
      @snippet_packet << self
    end
  end
end
