module AudioGlue
  class SoxAdapter

    def write(snippet_packet, output_file)
      input_files = snippet_packet.snippets.map do |snippet|
        snippet.location
      end

      combiner = Sox::Combiner.new(input_files, :combine => :concatenate, :rate => snippet_packet.rate, :channels => snippet_packet.channels)
      combiner.write(output_file)
    end

  end
end
