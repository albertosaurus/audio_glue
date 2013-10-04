require 'spec_helper'

describe AudioGlue::TemplateLoader do
  describe '.new' do
    it 'should set base path' do
      loader = described_class.new('/glue_templates')
      loader.base_path.should == '/glue_templates'
    end

    it 'should instantiate empty cache' do
      loader = described_class.new('/')
      loader.cache.should == {}
    end
  end

  describe '#absolute_path' do
    it 'should builds absolute path to template file' do
      loader = described_class.new('/base/path')
      loader.send(:absolute_path, 'template_a').should == '/base/path/template_a.glue'
    end
  end


  describe '#load' do
    let(:loader) { described_class.new(TEMPLATE_FIXTURES_PATH) }

    context 'error' do
      context 'template does not exist' do
        it 'should raise LoadTemplateError' do
          file_path = File.join(TEMPLATE_FIXTURES_PATH, 'none.glue')
          expect { loader.get('none') }.
            to raise_error(AudioGlue::LoadTemplateError, /#{file_path}/)
        end
      end

      context 'template has invalid ruby syntax' do
        it 'should raise LoadTemplateError' do
          expect { loader.get('syntax_error') }.
            to raise_error(AudioGlue::LoadTemplateError, %r{syntax error, unexpected end-of-input})
        end
      end

      context 'template has invalid method' do
        it 'should raise LoadTemplateError' do
          expect { loader.get('global_no_method') }.
            to raise_error(AudioGlue::LoadTemplateError, /undefined local variable or method `alien_is_here'/)
        end
      end

      context 'head has undefined method call' do
        it 'should raise LoadTemplateError' do
          expect { loader.get('head_bad_attribute') }.
            to raise_error(AudioGlue::LoadTemplateError, /undefined method `bad_attribute'/)
        end
      end
    end

    context 'success' do
      it 'should load template and return it' do
        template = loader.get('valid')

        template.should be_a Class
        template.ancestors.should include(AudioGlue::Template)

        template.format.should   == :mp3
        template.rate.should     == 22050
        template.channels.should == 1
      end

      it 'should cache loaded template' do
        template1 = loader.get('valid')
        template2 = loader.get('valid')
        template1.object_id.should == template2.object_id
      end

      it 'should set template path' do
        template = loader.get('valid')
        template.path.should == template_fixture('valid.glue')
      end

      it 'should mix helper module if it is present' do
        helper = Module.new
        loader = described_class.new(TEMPLATE_FIXTURES_PATH, :helper => helper)
        template = loader.get('valid')
        template.ancestors.should include(helper)
      end
    end
  end

end
