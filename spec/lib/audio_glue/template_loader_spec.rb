require 'spec_helper'

describe AudioGlue::TemplateLoader do
  let(:loader) { described_class.new(TEMPLATE_FIXTURES_PATH) }

  describe '.new' do
    it 'should set the base path' do
      loader = described_class.new('/glue_templates')
      loader.base_path.should == '/glue_templates'
    end

    it 'should instantiate the empty cache' do
      loader.cache.should == {}
    end
  end


  describe '#get' do
    context 'error' do
      context 'the template does not exist' do
        it 'should raise LoadTemplateError' do
          file_path = File.join(TEMPLATE_FIXTURES_PATH, 'none.glue')
          expect { loader.get('none') }.
            to raise_error(AudioGlue::LoadTemplateError, /#{file_path}/)
        end
      end

      context 'the template has invalid ruby syntax' do
        it 'should raise LoadTemplateError' do
          expect { loader.get('syntax_error') }.
            to raise_error( AudioGlue::LoadTemplateError,
                            %r{syntax error, unexpected end-of-input} )
        end
      end

      context 'the template has an invalid method' do
        it 'should raise LoadTemplateError' do
          expect { loader.get('global_no_method') }.
            to raise_error(
                 AudioGlue::LoadTemplateError,
                 /undefined local variable or method `alien_is_here'/
               )
        end
      end

      context 'the head has an undefined method call' do
        it 'should raise LoadTemplateError' do
          expect { loader.get('head_bad_attribute') }.
            to raise_error( AudioGlue::LoadTemplateError,
                            /undefined method `bad_attribute'/ )
        end
      end
    end

    context 'success' do
      it 'should load the template and return it' do
        template = loader.get('valid')

        template.should be_a Class
        template.ancestors.should include(AudioGlue::Template)

        template.format.should   == :mp3
        template.rate.should     == 22050
        template.channels.should == 1
      end

      it 'should cache the loaded template' do
        template1 = loader.get('valid')
        template2 = loader.get('valid')
        template1.object_id.should == template2.object_id
      end

      it 'should set the template path' do
        template = loader.get('valid')
        template.path.should == template_fixture('valid.glue')
      end

      it 'should mix the helper module if it is present' do
        helper   = Module.new
        loader   = described_class.new( TEMPLATE_FIXTURES_PATH,
                                        :helper => helper )
        template = loader.get('valid')
        template.ancestors.should include(helper)
      end
    end
  end

  describe '#reset_cache!' do
    it 'should clear the cache' do
      loader.get('valid')
      loader.cache.should_not be_empty
      loader.reset_cache!
      loader.cache.should be_empty
    end
  end

  describe '#absolute_path' do
    it 'should build the absolute path to the template file' do
      loader = described_class.new('/base/path')
      loader.send(:absolute_path, 'template_a').
             should == '/base/path/template_a.glue'
    end
  end
end
