module AudioGlue
  class Template
    class HeadContext
      def initialize(template)
        @template = template
      end

      def format(format_value)
        @template.format = format_value
      end

      def rate(rate_value)
        @template.rate = rate_value
      end

      def channels(channels_value)
        @template.channels = channels_value
      end
    end
  end
end
