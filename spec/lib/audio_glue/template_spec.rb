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
        template.inspect.should include('@variables={:a=>12}')
      end
    end

    context 'anonymous class' do
      it 'should contain AudioGlue::Template' do
        template = Class.new(AudioGlue::Template).new
        template.inspect.should == "<AudioGlue::Template @variables={}>"
      end

      it 'should show path if it presents' do
        template_class = Class.new(AudioGlue::Template)
        template_class.path = "/oh.glue"
        template = template_class.new(:g => 9.8)
        template.inspect.should == '<AudioGlue::Template(path="/oh.glue") @variables={:g=>9.8}>'
      end
    end
  end
end
