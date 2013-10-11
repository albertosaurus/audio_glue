require 'spec_helper'

describe 'AudioGlue::Builder integration' do
  let(:output_file) { gen_tmp_filename('wav')         }
  let(:adapter)     { AudioGlue::PlainSoxAdapter.new  }
  let(:builder)     { AudioGlue::Builder.new(adapter) }

  after do
    FileUtils.rm output_file if File.exists?(output_file)
  end

  context 'Template with local files' do
    let(:template_class) do
      Class.new(AudioGlue::Template) do
        head do
          format 'wav'
          rate 96000
          channels 1
        end

        body do
          - file(input_fixture('hi.wav'))
          - file(input_fixture('hi.wav'))

          if @smalltalk
            - file(input_fixture('how_are_you_doing.wav'))
            - file(input_fixture('fine_thanks.wav'))
          end

          - file(input_fixture('bye_bye.wav'))
        end

      end
    end


    it 'should build audio without smalltalk' do
      template = template_class.new

      audio = builder.build(template)
      File.write(output_file, audio)

      output_file.should sound_like output_fixture('hi_hi_bye_bye.wav')
    end

    it 'should build audio with smalltalk' do
      template = template_class.new(:smalltalk => true)

      audio = builder.build(template)
      File.write(output_file, audio)

      output_file.should sound_like output_fixture(
                                      'hi_hi_how_are_you_fine_bye.wav'
                                    )
    end

    context 'with options' do
      let(:output_file) { gen_tmp_filename('flac') }

      it 'should use the passed options' do
        template = template_class.new

        audio = builder.build(template,
                              :format   => 'flac',
                              :rate     => 44100,
                              :channels => 2)
        File.write(output_file, audio)

        output_file.should have_rate(44100)
        output_file.should have_channels(2)

        output_file.should sound_like output_fixture('hi_hi_bye_bye.wav')
      end
    end
  end
end
