module AudioGlue
  # Pretty small adapter which is based on the +ruby-sox+ library and handles
  # only local files (snippet type = :file).
  class PlainSoxAdapter < BaseAdapter
    # Write output to temporary file and read data from it and remove it.
    #
    # @return [String] audio data as a binary string.
    def build
      tmp_file = gen_tmp_filename(@snippet_packet.format)
      write(tmp_file)
      File.binread(tmp_file)
    rescue ::Sox::Error => err
      raise(::AudioGlue::BuildError, err.message)
    ensure
      FileUtils.rm tmp_file if File.exists?(tmp_file)
    end


    # Build an output file using the snippet packet and write it to a file.
    #
    # @param output_file [String] path to a file
    #
    # @return [void]
    def write(output_file)
      input_files = @snippet_packet.snippets.map { |snippet| snippet.location }
      combiner    = Sox::Combiner.new( input_files,
                                       :combine  => :concatenate,
                                       :rate     => @snippet_packet.rate,
                                       :channels => @snippet_packet.channels )
      combiner.write(output_file)
    end
    private :write

    # Generate a unique name for a temporary file.
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
