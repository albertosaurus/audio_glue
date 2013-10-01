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
      packet  = build_snippet_packet(template)
      adapter = @adapter_class.new(packet)
      adapter.build
    end

    def build_snippet_packet(template)
      SnippetPacket.new(template.format, template.rate, template.channels).tap do |packet|
        template.build(packet)
      end
    end
  end
end
