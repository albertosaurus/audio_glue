module AudioGlue
  class Template
    # The context in which the +head+ statement of a +.glue+ template is
    # executed. It's used to set the +format+, +rate+ and +channels+ on
    # the template.
    class HeadContext
      # @param template [Class] subclass of {AudioGlue::Template}
      def initialize(template)
        @template = template
      end

      # Set the audio format on the template ("mp3", "ogg", "wav", etc).
      #
      # @param format_value [Symbol, String]
      #
      # @return [void]
      def format(format_value)
        @template.format = format_value
      end

      # Set the audio bitrate on the template.
      #
      # @param rate_value [Integer, String]
      #
      # @return [void]
      def rate(rate_value)
        @template.rate = rate_value
      end

      # Set the number of channels on the template.
      #
      # @param channels_value [Integer, String]
      #
      # @return [void]
      def channels(channels_value)
        @template.channels = channels_value
      end
    end
  end
end
