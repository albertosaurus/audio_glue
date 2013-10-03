module AudioGlue
  # Represents an audio partial which will be used to build an output audio.
  # There few types of snippets:
  # * :file - represents audio file in local file system
  # * :url  - represents remote audio file
  #
  # {AudioGlue::BaseAdapter adapters} are responsible for processing every
  # particular snippet type.
  class Snippet
    attr_reader :type, :location, :snippet_packet

    # @param type [Symbol] :file or :url
    # @param location [String] location of the file
    # @param snippet_packet [AudioGlue::SnippetPacket] snippet packet which is
    #   to add audio snippet to packet when `-` unary method is called.
    def initialize(type, location, snippet_packet)
      @type     = type
      @location = location
      @snippet_packet = snippet_packet
    end

    # Add self to snippet packet.
    # It's used to support dash syntax in +.glue+ files, like:
    #   - file('/audio.mp3')
    #
    # @return [void]
    def -@
      @snippet_packet << self
    end
  end
end
