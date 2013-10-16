require 'spec_helper'

describe 'AudioGlue::Builder integration' do
  let(:adapter) { AudioGlue::TestAdapter.new      }
  let(:builder) { AudioGlue::Builder.new(adapter) }

  context 'Template with local files' do
    let(:template_class) do
      Class.new(AudioGlue::Template) do
        head do
          format 'wav'
          rate 96000
          channels 1
        end

        body do
          - file('hi')

          if @smalltalk
            - file('how_are_you')
          end

          - file('bye')
        end

      end
    end


    it 'should build audio without smalltalk' do
      template = template_class.new
      builder.build(template).should == 'hi,bye'
    end

    it 'should build audio with smalltalk' do
      template = template_class.new(:smalltalk => true)
      builder.build(template).should == 'hi,how_are_you,bye'
    end
  end
end
