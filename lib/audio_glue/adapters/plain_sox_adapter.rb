module AudioGlue
  # Pretty small adapter which is based on the +ruby-sox+ library and handles
  # only local files (snippet type = :file).
  class PlainSoxAdapter < BaseAdapter
    # Write output to temporary file and read data from it and remove it.
    #
    # @param snippet_packet [AudioGlue::SnippetPacket]
    #
    # @return [String] audio data as a binary string.
    def build(snippet_packet)
      tmp_file = gen_tmp_filename(snippet_packet.format)
      write(snippet_packet, tmp_file)
      File.binread(tmp_file)
    rescue ::Sox::Error => err
      raise(::AudioGlue::BuildError, err.message)
    ensure
      FileUtils.rm tmp_file if File.exists?(tmp_file)
    end


    # Build an output file using the snippet packet and write it to a file.
    #
    # @param output_file [String] path to a file
    # @param snippet_packet [AudioGlue::SnippetPacket]
    #
    # @return [void]
    def write(snippet_packet, output_file)
      input_files = snippet_packet.snippets.map { |snippet| snippet.source}
      combiner    = Sox::Combiner.new( input_files,
                                       :combine  => :concatenate,
                                       :rate     => snippet_packet.rate,
                                       :channels => snippet_packet.channels )
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
