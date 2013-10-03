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
    # TODO:
    #   Add paramaters +options+ to have an ability to customize particular
    #   with +format+, +rate+ and +channels+.
    #
    # @return [String]
    def build(template)
      @adapter.snippet_packet = template.build_snippet_packet
      @adapter.build
    end
  end
end
