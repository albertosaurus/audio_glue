require 'spec_helper'

describe 'AudioGlue::Builder integration' do
  let(:output_file) { gen_tmp_filename('wav')         }
  let(:adapter)     { AudioGlue::PlainSoxAdapter.new  }
  let(:builder)     { AudioGlue::Builder.new(adapter) }

  context 'Template with local files' do
    let(:template_class) do
      Class.new(AudioGlue::Template) do
        head do
          format 'wav'
          rate 9600
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

      output_file.should sound_like output_fixture('hi_hi_how_are_you_fine_bye.wav')
    end
  end


  #context 'Template with remote files' do
  #  let(:template_class) do
  #    Class.new(AudioGlue::Template) do
  #      self.rate     = 44100
  #      self.channels = 2


  #      def build(packet)
  #        packet << url('http://host.com/hi.wav')
  #        packet << url('http://host.com/hi.wav')

  #        packet << url('http://host.com/bye_bye.wav')
  #      end
  #    end
  #  end

  #  it 'should build audio from remote files' do
  #    stub_request(:get, 'http://host.com/hi.wav').
  #      to_return(File.binread(input_fixture('hi.wav')))

  #    stub_request(:get, 'http://host.com/bye_bye.wav').
  #      to_return(File.binread(input_fixture('bye_bye.wav')))



  #    template = template_class.new
  #    builder.write(template, output_file)

  #    output_file.should sound_like output_fixture('hi_hi_bye_bye.wav')
  #  end
  #end
end
