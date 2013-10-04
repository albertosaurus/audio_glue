module AudioGlue
  # Audio templates.
  # Every particular template is a subclass of {AudioGlue::Template}. Quite often
  # the classes can be anonymous(that's why +inspect+ is redefined to provide more information).
  #
  # Template class owns +format+, +rate+, +channels+ and also a block which is used
  # to create {AudioGlue::SnippetPacket} ("render" in term of view templates).
  #
  # Instances of templates differs from template classes with instance variables,
  # which can be used in +body+ block.
  #
  # @example
  #   class HiTemplate < AudioGlue::Template
  #     # Output file information
  #     head do
  #       format :mo3
  #       rate 22050
  #       channels 2
  #     end
  #
  #     # Block to "render" template
  #     body do
  #       - file('/hi.mp3')
  #       if @with_smalltalk
  #         - url('http://say.it/how-are-you.mp3')
  #       end
  #     end
  #   end
  #
  #   # Create an instance of template. We wonder how our friend is doing so
  #   # we pass ":with_smalltalk => true", to add a remote URL snippet.
  #   template = HiTemplate.new(:with_smalltalk => true)
  #
  #   # Let's create a snippet packet
  #   packet = template.build_snippet_packet => # <AudioGlue::SnippetPacket ..>
  #   # Now we can pass a snippet packet to adapter to build output audio.
  #
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


    # @param variables [Hash] hash of parameters which can be used as instance
    #   variables in +body+ statement of +.glue+ template.
    def initialize(variables = {})
      variables.each do |var, value|
        instance_variable_set("@#{var}", value)
      end
    end

    # Executes body of template to build a snippet packet.
    #
    # @return [AudioGlue::SnippetPacket]
    def build_snippet_packet
      @__packet__ = SnippetPacket.new(format, rate, channels)
      instance_eval(&body_proc)
      @__packet__
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

        instance_variables.each do |var|
          info << " #{var}="
          info << instance_variable_get(var).inspect
        end

        info << ">"
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
    private :file

    # Create snippet for +:url+ type.
    #
    # @param remote_url [String] remote location of audio file
    #
    # @return [AudioGlue::Snippet]
    def url(remote_url)
      Snippet.new(:url, remote_url, @__packet__)
    end
    private :url
  end
end
