module AudioGlue
  class Template
    extend Forwardable
    def_delegators 'self.class', :format, :rate, :channels, :body_proc

    class << self
      attr_accessor :format, :rate, :channels, :path, :body_proc

      def head(&block)
        HeadContext.new(self).instance_eval(&block)
      end

      def body(&block)
        self.body_proc = block
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
      body = BodyContext.new(packet, @variables)
      body.instance_eval(&body_proc)
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
