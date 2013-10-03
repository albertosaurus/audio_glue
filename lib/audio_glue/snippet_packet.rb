module AudioGlue
  # Basically SnippetPacket is a collection of {AudioGlue::Snippet snippets} with
  # some additional info about output file(format, rate, number of channels).
  #
  # It's supposed to be built from {AudioGlue::Template}, and then it's passed to one
  # of adapters which builds audio output.
  class SnippetPacket
    extend Forwardable
    def_delegators :@snippets, :<<

    attr_reader :format, :rate, :channels, :snippets

    # @param format [Symbol, String]
    # @param rate [Numeric, String]
    # @param channels [Numeric, String]
    def initialize(format, rate, channels)
      @format   = format
      @rate     = rate
      @channels = channels
      @snippets = []
    end
  end
end
