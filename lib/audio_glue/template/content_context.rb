module AudioGlue
  class Template
    class ContentContext
      def initialize(packet, variables = {})
        @__packet__ = packet

        variables.each do |var, value|
          instance_variable_set("@#{var}", value)
        end
      end


      def file(file_path)
        Snippet.new(:file, file_path, @__packet__)
      end

      def url(remote_url)
        Snippet.new(:url, remote_url, @__packet__)
      end
    end
  end
end
