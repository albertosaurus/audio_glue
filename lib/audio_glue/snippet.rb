module AudioGlue
  class Snippet
    attr_reader :type, :location

    # @param type [Symbol] :file or :url
    # @param location [String] location of the file
    # @param snippet_packet [AudioGlue::SnippetPacket] snippet packet which is
    #   to add audio snippet to packet when `-` unary method is called.
    def initialize(type, location, snippet_packet)
      @type     = type
      @location = location
      @snippet_packet = snippet_packet
    end

    def -@
      @snippet_packet << self
    end
  end
end
