module AudioGlue
  class PlainSoxAdapter < BaseAdapter

    # TODO:
    #   Update ruby-sox to have +build+ method which would return binary string
    #   instead of writing output into a file. We hack sox with --sox-pipe option to
    #   make it write output to stdout to achieve this.
    #
    def build
      tmp_file = gen_tmp_filename(@snippet_packet.format)
      write(tmp_file)
      File.binread(tmp_file)
    ensure
      FileUtils.rm tmp_file
    end


    def write(output_file)
      input_files = @snippet_packet.snippets.map { |snippet| snippet.location }
      combiner = Sox::Combiner.new(input_files,
                                   :combine  => :concatenate,
                                   :rate     => @snippet_packet.rate,
                                   :channels => @snippet_packet.channels)
      combiner.write(output_file)
    end
    private :write

    def gen_tmp_filename(ext)
      Dir::Tmpname.make_tmpname ['/tmp/audio-glue-', ".#{ext}"], nil
    end
    private :gen_tmp_filename
  end
end
