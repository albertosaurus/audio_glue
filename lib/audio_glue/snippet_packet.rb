module AudioGlue
  class SnippetPacket
    extend Forwardable
    def_delegators :@snippets, :<<

    attr_reader :rate, :channels, :snippets

    def initialize(rate, channels)
      @rate     = rate
      @channels = channels
      @snippets = []
    end
  end
end
