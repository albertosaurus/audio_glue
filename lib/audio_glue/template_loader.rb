module AudioGlue
  # Loads +.glue+ template and caches them.
  #
  # @example
  #  loader = AudioGlue::TemplateLoader.new('/project/audio_templates/')
  #
  #  # load and cache "/project/audio_templates/john/hi.glue"
  #  loader.get('john/hi') # => subclass of AudioGlue::Template
  class TemplateLoader
    # Extension of template files.
    TEMPLATE_EXT = 'glue'

    # @attr_reader base_path [String] path to a directory with templates
    attr_reader :base_path

    # @attr_reader cache [Hash<String, Class>] cached templates, key is a path
    #   to a template file, value is a subclass of {AudioGlue::Template}
    attr_reader :cache

    # @param base_path [String] path to a directory with templates
    # @param opts [Hash] options
    # @option opts :helper [Module] module which provides custom methods for templates.
    def initialize(base_path, opts = {})
      @base_path = base_path
      @helper    = opts.delete(:helper)
      @cache     = {}
    end

    # Load and cached template from +.glue+ template file.
    #
    # @param template_name [String] name of template in +base_path+ directory
    #
    # @return [Class] a subclass of {AudioGlue::Template}
    def get(template_name)
      path = absolute_path(template_name)
      @cache[path] ||= load_tepmlate_from_file(path)
    end

    # Reset cache.
    #
    # @return [Hash] empty cache
    def reset_cache!
      @cache.clear
    end



    # Calculate absolute path to file from a template name.
    #
    # @param template_name [String] name of template in +base_path+ directory
    #
    # @return [String] absolute path to a template file
    def absolute_path(template_name)
      File.join(@base_path, "#{template_name}.#{TEMPLATE_EXT}")
    end
    private :absolute_path

    # Read .glue template file and create a template class from it.
    #
    # @param path [String] absolute path to .glue template file
    #
    # @return [Class] a subclass of {AudioGlue::Template}
    def load_tepmlate_from_file(path)
      Class.new(AudioGlue::Template).tap do |template|
        content = File.read(path)
        template.path = path
        template.send(:include, @helper) if @helper
        template.instance_eval(content, path)
      end
    rescue Errno::ENOENT => err
      raise AudioGlue::LoadTemplateError, err.message
    rescue SyntaxError, NameError => err
      raise AudioGlue::LoadTemplateError, err.message, err.backtrace
    end
    private :load_tepmlate_from_file
  end
end
