module AudioGlue
  # Pretty small adapter which is based on +ruby-sox+ library and handles only
  # local files (snippet type = :file).
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


    # TODO:
    #   Handle sox exceptions and raise AudioGlue exceptions.
    #
    # Build output file using snippet packet and write it to a file.
    #
    # @param output_file [String] path to a faile
    #
    # @return [void]
    def write(output_file)
      input_files = @snippet_packet.snippets.map { |snippet| snippet.location }
      combiner = Sox::Combiner.new(input_files,
                                   :combine  => :concatenate,
                                   :rate     => @snippet_packet.rate,
                                   :channels => @snippet_packet.channels)
      combiner.write(output_file)
    end
    private :write

    # Generate unique name for a temporary file.
    #
    # @param ext [String] extension of a file
    #
    # @return [String]
    def gen_tmp_filename(ext)
      Dir::Tmpname.make_tmpname ['/tmp/audio-glue-', ".#{ext}"], nil
    end
    private :gen_tmp_filename
  end
end
