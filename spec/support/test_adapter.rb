# Adapter for tests. It doesn't have to deal with real audio files.
# All it does is join snippet sources.
class AudioGlue::TestAdapter < AudioGlue::BaseAdapter
  # :nodoc:
  def build(snippet_packet)
    snippet_packet.snippets.map { |snippet| snippet.source }.join(',')
  end
end
