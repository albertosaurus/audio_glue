require 'spec_helper'

describe AudioGlue::BaseAdapter do
  let(:snippet_packet) { double(:snippet_packet) }
  let(:adapter)        { described_class.new     }

  it 'should have snippet_packet attribute' do
    adapter.snippet_packet = snippet_packet
    adapter.snippet_packet.should == snippet_packet
  end

  describe '#build' do
    it 'should raise AbstractMethodCallError' do
      expect { adapter.build }.
        to raise_error(AudioGlue::AbstractMethodCallError, 'build')
    end
  end
end
