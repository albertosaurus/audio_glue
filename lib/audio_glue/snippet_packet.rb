module AudioGlue
  # SnippetPacket is a collection of {AudioGlue::Snippet snippets} with
  # some additional info about the output file
  # (format, rate, number of channels).
  #
  # It's supposed to be built by {AudioGlue::Template}. And then it's passed
  # to an adapter which builds the audio output.
  class SnippetPacket
    extend Forwardable
    def_delegators :@snippets, :<<

    attr_accessor :format, :rate, :channels
    attr_reader :snippets

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
