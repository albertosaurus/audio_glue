require 'spec_helper'

describe 'Using loader and builder together' do
  let(:adapter) { AudioGlue::TestAdapter.new      }
  let(:builder) { AudioGlue::Builder.new(adapter) }

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

    builder.build(template).should ==
      'hi,how_are_you,bye'
  end
end
