module AudioGlue
  class Builder
    def initialize(adapter_class = AudioGlue::PlainSoxAdapter)
      @adapter_class = adapter_class
    end

    def write(template, output_file)
      packet  = build_snippet_packet(template)
      adapter = @adapter_class.new(packet)

      adapter.write(output_file)
    end

    def build_snippet_packet(template)
      SnippetPacket.new(template.rate, template.channels).tap do |packet|
        template.build(packet)
      end
    end
  end
end
