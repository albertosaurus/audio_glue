require 'spec_helper'

describe AudioGlue::BaseAdapter do
  let(:snippet_packet) { double(:snippet_packet) }
  let(:adapter)        { described_class.new     }

  describe '#build' do
    it 'should raise AbstractMethodCallError' do
      expect { adapter.build(snippet_packet) }.
        to raise_error(AudioGlue::AbstractMethodCallError, 'build')
    end
  end
end
