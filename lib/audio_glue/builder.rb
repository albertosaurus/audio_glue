module AudioGlue
  class Builder
    def initialize(adapter_class = AudioGlue::PlainSoxAdapter)
      @adapter_class = adapter_class
    end

    # Build audio file and return result as binary string.
    #
    # TODO:
    #   Add paramaters +options+ to have an ability to customize particular
    #   with +format+, +rate+ and +channels+.
    #
    # @return [String]
    def build(template)
      packet  = template.build_snippet_packet
      adapter = @adapter_class.new(packet)
      adapter.build
    end

  end
end
