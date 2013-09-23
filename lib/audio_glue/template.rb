module AudioGlue
  class Template

    class << self
      attr_accessor :rate, :channels
    end

    def rate
      self.class.rate
    end

    def channels
      self.class.channels
    end




    def initialize(variables = {})
      variables.each do |var, value|
        instance_variable_set("@#{var}", value)
      end
    end

    def file(file_path)
      Snippet.new(:file, file_path)
    end

    def url(remote_url)
      Snippet.new(:url, remote_url)
    end

    def build(snippet_packet)
      raise NotImplementedError, __method__
    end
  end
end
