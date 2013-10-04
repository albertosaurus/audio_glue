require 'spec_helper'

describe AudioGlue::Template do

  describe '.inspect' do
    context 'class has a name' do
      before do
        class TestTemplate < AudioGlue::Template
        end
      end

      after do
        Object.send(:remove_const, :TestTemplate)
      end

      it 'should inspect with standard mechanism' do
        TestTemplate.inspect.should == "TestTemplate"
      end
    end

    context 'anonymous class' do
      it 'should show AudioGlue::Template' do
        template = Class.new(AudioGlue::Template)
        template.inspect.should == "<AudioGlue::Template(class)>"
      end

      it 'should show path if it presents' do
        template = Class.new(AudioGlue::Template)
        template.path = '/path/to/template.glue'
        template.inspect.should == '<AudioGlue::Template(class) path="/path/to/template.glue">'
      end
    end
  end


  describe '#inspect' do
    context' class has a name' do
      before do
        class TestTemplate < AudioGlue::Template
        end
      end

      after do
        Object.send(:remove_const, :TestTemplate)
      end

      it 'should inspect with standard mechanism' do
        template = TestTemplate.new(:a => 12)
        template.inspect.should include('TestTemplate')
        template.inspect.should include('@a=12')
      end
    end

    context 'anonymous class' do
      it 'should contain AudioGlue::Template' do
        template = Class.new(AudioGlue::Template).new
        template.inspect.should == "<AudioGlue::Template>"
      end

      it 'should show path if it presents' do
        template_class = Class.new(AudioGlue::Template)
        template_class.path = "/oh.glue"
        template = template_class.new(:g => 9.8)
        template.inspect.should == '<AudioGlue::Template(path="/oh.glue") @g=9.8>'
      end
    end
  end

  describe '#file' do
    it 'should return a snippet of :file type' do
      template = described_class.new
      snippet  = template.send(:file, '/path/in.mp3')

      snippet.type.should == :file
      snippet.location.should == '/path/in.mp3'
    end
  end

  describe '#url' do
    it 'should return a snippet of :url type' do
      template = described_class.new
      snippet  = template.send(:url, 'http://s.com/sound.mp3')

      snippet.type.should == :url
      snippet.location.should == 'http://s.com/sound.mp3'
    end
  end
end
