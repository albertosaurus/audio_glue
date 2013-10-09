# Compare the sound of two audio files.
# Based on the Chromaprint library and the +sox+ command like tool.
#
# @example
#   "/Airborne.mp3".should sound_like "/ACDC.mp3"
#   "/Children_of_Bodom.mp3".should_not sound_like "/Britney_Spears.mp3"
RSpec::Matchers.define :sound_like do |expected_file|
  match do |file|
    rate      = 96000
    channels  = 1
    threshold = 0.95

    if File.exists?(expected_file) && File.exists?(file)
      # Convert input files into raw 16-bit signed audio (WAV) to process
      # with Chromaprint:
      sox_command    = "sox %s -e signed -b 16 -t wav - " \
                       "rate #{rate} channels #{channels} 2> /dev/null"
      expected_audio = %x"#{sox_command % [expected_file]}"
      audio          = %x"#{sox_command % [file]}"

      # Get audio fingerprints:
      chromaprint = Chromaprint::Context.new(rate, channels)
      expected_fp = chromaprint.get_fingerprint(expected_audio)
      fp          = chromaprint.get_fingerprint(audio)

      # Compare fingerprints and compare result against threshold:
      expected_fp.compare(fp) > threshold
    else
      false
    end
  end
end
