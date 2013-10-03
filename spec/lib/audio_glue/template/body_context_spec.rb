require 'spec_helper'

describe AudioGlue::Template::BodyContext do
  let(:packet) { double(:snippet_packet) }

  describe '.new' do
    it 'should set instance variables from hash' do
      body = described_class.new(packet, :a => 10, :b => 20)
      body.instance_variable_get('@a').should == 10
      body.instance_variable_get('@b').should == 20
    end
  end

  describe '#file' do
    it 'should return a snippet of :file type' do
      body = described_class.new(packet)
      snippet = body.file('/path/in.mp3')

      snippet.type.should == :file
      snippet.location.should == '/path/in.mp3'
      snippet.snippet_packet.should == packet
    end
  end

  describe '#url' do
    it 'should return a snippet of :url type' do
      body = described_class.new(packet)
      snippet = body.url('http://s.com/sound.mp3')

      snippet.type.should == :url
      snippet.location.should == 'http://s.com/sound.mp3'
      snippet.snippet_packet.should == packet
    end
  end
end
