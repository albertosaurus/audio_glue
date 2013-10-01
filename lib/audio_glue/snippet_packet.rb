module AudioGlue
  class SnippetPacket
    extend Forwardable
    def_delegators :@snippets, :<<

    attr_reader :format, :rate, :channels, :snippets

    def initialize(format, rate, channels)
      @format   = format
      @rate     = rate
      @channels = channels
      @snippets = []
    end
  end
end
