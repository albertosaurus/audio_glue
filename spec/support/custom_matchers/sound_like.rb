# Compare sound of two audio files. Based on Chromaprint library and +sox+
# command like tool.
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
      # Convert input files into raw 16-bit signed audio (WAV) to process with Chromaprint
      expected_audio = %x"sox #{expected_file} -e signed -b 16 -t wav - rate #{rate} channels #{channels} 2> /dev/null"
      audio =          %x"sox #{file}          -e signed -b 16 -t wav - rate #{rate} channels #{channels} 2> /dev/null"

      # Get audio fingerprints
      chromaprint = Chromaprint::Context.new(rate, channels)
      expected_fp = chromaprint.get_fingerprint(expected_audio)
      fp = chromaprint.get_fingerprint(audio)

      # Compare fingerprints and compare result against threshold
      expected_fp.compare(fp) > threshold
    else
      false
    end
  end
end
