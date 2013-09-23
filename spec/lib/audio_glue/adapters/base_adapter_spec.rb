require 'spec_helper'

describe AudioGlue::BaseAdapter do
  let(:snippet_packet) { double(:snippet_packet)             }
  let(:adapter)        { described_class.new(snippet_packet) }

  describe '.new' do
    it 'should initialize snippet_packet' do
      adapter.snippet_packet.should == snippet_packet
    end
  end

  describe '#write' do
    it 'should raise AbstractMethodCallError' do
      expect { adapter.write('/file/path') }.
        to raise_error(AudioGlue::AbstractMethodCallError, 'write')
    end
  end

  describe '#build' do
    it 'should raise AbstractMethodCallError' do
      expect { adapter.build }.
        to raise_error(AudioGlue::AbstractMethodCallError, 'build')
    end
  end
end
