module AudioGlue
  class Builder
    def initialize
      @adapter = SoxAdapter.new
    end

    def write(template, output_file)
      packet = build_snippet_packet(template)
      @adapter.write(packet, output_file)
    end

    def build_snippet_packet(template)
      SnippetPacket.new(template.rate, template.channels).tap do |packet|
        template.build(packet)
      end
    end
  end
end
