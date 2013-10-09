module AudioGlue
  # Builds audio from a {AudioGlue::Template template} instance.
  #
  # @example
  #   # Instantiate the builder with an adapter:
  #   builder = AudioGlue::Builder.new(AudioGlue::PlainSoxAdapter.new)
  #
  #   # Create the template instance:
  #   template = HiTemplate.new(:with_smalltalk => true)
  #
  #   # Build the output audio:
  #   builder.build(template) # => audio as a binary string
  class Builder
    # @param adapter [AudioGlue::BaseAdapter] instance of an adapter
    def initialize(adapter)
      @adapter = adapter
    end

    # Build an audio file and return the result as a binary string.
    #
    # @param template [AudioGlue::Template]
    # @param opts [Hash]
    #
    # @option opts :format [Symbol, String]
    # @option opts :rate [Integer, String]
    # @option opts :channels [Integer, String]
    #
    # @return [String]
    def build(template, opts = {})
      format, rate, channels = opts[:format], opts[:rate], opts[:channels]

      packet =  template.build_snippet_packet
      packet.format   = format   if format
      packet.rate     = rate     if rate
      packet.channels = channels if channels

      @adapter.snippet_packet = packet
      @adapter.build
    end
  end
end
