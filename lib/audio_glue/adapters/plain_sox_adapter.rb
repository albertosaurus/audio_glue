module AudioGlue
  class PlainSoxAdapter < BaseAdapter

    def write(output_file)
      input_files = @snippet_packet.snippets.map { |snippet| snippet.location }
      combiner = Sox::Combiner.new(input_files,
                                   :combine  => :concatenate,
                                   :rate     => snippet_packet.rate,
                                   :channels => snippet_packet.channels)
      combiner.write(output_file)
    end

    # TODO: implement. How to take format? Should it be a property of a snippet_packet?
    def build

    end
  end
end
