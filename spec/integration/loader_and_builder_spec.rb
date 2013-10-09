require 'spec_helper'

describe 'Using loader and builder together' do
  let(:output_file) { gen_tmp_filename('flac') }

  after do
    FileUtils.rm output_file if File.exists?(output_file)
  end

  let(:helper_module) do
    Module.new do
      def input(filename)
        path = File.join(SOUND_FIXTURES_PATH, 'input', filename)
        file(path)
      end
    end
  end

  it 'should build' do
    loader = AudioGlue::TemplateLoader.new( TEMPLATE_FIXTURES_PATH,
                                            :helper => helper_module )

    template_class = loader.get('hi')
    template       = template_class.new(:smalltalk => true)

    adapter = AudioGlue::PlainSoxAdapter.new
    builder = AudioGlue::Builder.new(adapter)

    audio_data = builder.build(template)
    File.binwrite(output_file, audio_data)

    output_file.should sound_like output_fixture(
                                    'hi_hi_how_are_you_fine_bye.wav'
                                  )
  end
end
