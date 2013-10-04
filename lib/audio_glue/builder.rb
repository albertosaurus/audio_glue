module AudioGlue
  # Builds audio from {AudioGlue::Template template} instance.
  #
  # @example
  #   # Instantiate builder with adapter
  #   builder = AudioGlue::Builder.new(AudioGlue::PlainSoxAdapter.new)
  #
  #   # Create template instance
  #   template = HiTemplate.new(:with_smalltalk => true)
  #
  #   # Build output audio
  #   builder.build(template) # => audio as a binary string
  class Builder
    # @param adapter [AudioGlue::BaseAdapter] instance of an adapter
    def initialize(adapter)
      @adapter = adapter
    end

    # Build audio file and return result as binary string.
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
      packet =  template.build_snippet_packet
      packet.format   = opts[:format]   if opts[:format]
      packet.rate     = opts[:rate]     if opts[:rate]
      packet.channels = opts[:channels] if opts[:channels]

      @adapter.snippet_packet = packet
      @adapter.build
    end
  end
end
