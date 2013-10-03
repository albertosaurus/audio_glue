module AudioGlue
  class Template
    extend Forwardable
    def_delegators 'self.class', :format, :rate, :channels, :path, :body_proc

    class << self
      attr_accessor :format, :rate, :channels, :path, :body_proc
    end

    # Method to process +head+ statement in +.glue+ templates.
    #
    # @yield block which will be executed in context of
    #   {AudioGlue::Template::HeadContext} object.
    #
    # @return [void]
    def self.head(&block)
      HeadContext.new(self).instance_eval(&block)
    end

    # Method to process +body+ statement in +.glue+ templates.
    #
    # @yield block which will be executed in context of
    #   {AudioGlue::Template::BodyContext} object. It should define body of
    #   audio template.
    # @return [void]
    def self.body(&block)
      self.body_proc = block
    end

    # Redefine +inspect+ method to provide more information when it's an
    # anonymous class.
    #
    # @return [String]
    def self.inspect
      if self.name
        super
      else
        info = "<AudioGlue::Template(class)"
        info << " path=#{path.inspect}" if path
        info << ">"
      end
    end


    # @params variables [Hash] hash of parameters which can be used as instance
    #   variables in +body+ statement of +.glue+ template.
    def initialize(variables = {})
      @variables = variables
    end

    # Executes body of template to build a snippet packet.
    #
    # @return [AudioGlue::SnippetPacket]
    def build_snippet_packet
      SnippetPacket.new(format, rate, channels).tap do |packet|
        body = BodyContext.new(packet, @variables)
        body.instance_eval(&body_proc)
      end
    end

    # Redefine +inspect+ to provide more information if class of the template
    # object is anonymous.
    #
    # @return [String]
    def inspect
      if self.class.name
        super
      else
        info = "<AudioGlue::Template"
        info << "(path=#{path.inspect})" if path
        info << " @variables=#{@variables.inspect}>"
      end
    end
  end
end
