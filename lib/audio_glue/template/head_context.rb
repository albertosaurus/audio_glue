module AudioGlue
  class Template
    # Context in which  +head+ statement of +.glue+ template is executed.
    # Is used to set +format+, +rate+ and +channels+ on template.
    class HeadContext
      # @param template [Class] subclass of {AudioGlue::Template}
      def initialize(template)
        @template = template
      end

      # Set format of audio on template("mp3", "ogg", "wav", etc).
      #
      # @param format_value [Symbol, String]
      #
      # @return [void]
      def format(format_value)
        @template.format = format_value
      end

      # Set rate of audio on template.
      #
      # @param rate_value [Integer, String]
      #
      # @return [void]
      def rate(rate_value)
        @template.rate = rate_value
      end

      # Set number of channels on template.
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
