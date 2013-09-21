module AudioGlue
  class Snippet
    attr_reader :type, :location

    # @param type [Symbol] :file or :url
    # @param location [String] location of the file
    def initialize(type, location)
      @type     = type
      @location = location
    end
  end
end
