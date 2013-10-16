# Adapter for tests. It doesn't have a deal with real audio files,
# all it does is just joining snippet sources.
class AudioGlue::TestAdapter < AudioGlue::BaseAdapter
  # :nodoc:
  def build(snippet_packet)
    snippet_packet.snippets.map { |snippet| snippet.source }.join(',')
  end
end
