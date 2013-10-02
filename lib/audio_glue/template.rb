module AudioGlue
  class Template
    extend Forwardable
    def_delegators 'self.class', :format, :rate, :channels, :content_proc

    class << self
      attr_accessor :format, :rate, :channels, :path, :content_proc

      def head(&block)
        HeadContext.new(self).instance_eval(&block)
      end

      def content(&block)
        self.content_proc = block
      end

      def inspect
        if self.name
          super
        else
          info = "<AudioGlue::Template(class)"
          info << " path=#{path.inspect}" if path
          info << ">"
        end
      end
    end


    def initialize(variables = {})
      @variables = variables
    end

    def build_snippet_packet
      packet = SnippetPacket.new(format, rate, channels)
      context = ContentContext.new(packet, @variables)
      context.instance_eval(&content_proc)
      packet
    end

    def inspect
      if self.class.name
        super
      else
        "<AudioGlue::Template(instance)"
      end
    end
  end
end
