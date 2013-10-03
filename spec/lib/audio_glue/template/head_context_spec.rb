require 'spec_helper'

describe AudioGlue::Template::HeadContext do
  let(:template) { Class.new(AudioGlue::Template) }
  let(:head)     { described_class.new(template)  }

  describe '#format' do
    it 'should set format of template' do
      head.format 'ogg'
      template.format.should == 'ogg'
    end
  end

  describe '#rate' do
    it 'should set format of template' do
      head.rate 8000
      template.rate.should == 8000
    end
  end

  describe '#channels' do
    it 'should set format of template' do
      head.channels 2
      template.channels.should == 2
    end
  end
end
