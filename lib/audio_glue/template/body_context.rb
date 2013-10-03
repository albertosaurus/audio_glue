module AudioGlue
  class Template
    # Context in which  +body+ statement of +.glue+ template is executed.
    class BodyContext
      # @param packet [AudioGlue::Snippet] snippet packet where snippets will be added
      # @param variables [Hash] hash to set instance variables
      def initialize(packet, variables = {})
        @__packet__ = packet

        variables.each do |var, value|
          instance_variable_set("@#{var}", value)
        end
      end

      # Create snippet for +:file+ type.
      #
      # @param  file_path [String] path to an audio file in local file system
      #
      # @return [AudioGlue::Snippet]
      def file(file_path)
        Snippet.new(:file, file_path, @__packet__)
      end

      # Create snippet for +:url+ type.
      #
      # @param remote_url [String] remote location of audio file
      #
      # @return [AudioGlue::Snippet]
      def url(remote_url)
        Snippet.new(:url, remote_url, @__packet__)
      end
    end
  end
end
