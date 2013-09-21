require 'spec_helper'

describe AudioGlue::Template do
  describe '#new' do
    it 'should set instance variables from hash' do
      template = described_class.new(:age => 23, :name => 'John Johnovich')

      template.instance_variable_get('@age').should == 23
      template.instance_variable_get('@name').should == 'John Johnovich'
    end
  end

  describe '#file' do
    it 'should build file snippet' do
      template = described_class.new
      file_snippet = template.file('/a.mp3')

      file_snippet.should be_a AudioGlue::Snippet
      file_snippet.type.should == :file
      file_snippet.location.should == '/a.mp3'
    end
  end
end
