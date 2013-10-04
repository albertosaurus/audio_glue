# AudioGlue

Audio template engine(aka ERB for audio).


## Dependencies

* SoX (for sox adapter)

### Debian / Ubuntu

```bash
apt-get install sox
```

### Mac

```bash
# Note: flac must be installed before sox so it will link during compilation.
# One of the following:
sudo port install flac sox
brew install flac sox
```

## Usage

There is an example:

```ruby
# Create a template class
class HelloWorldTemplate < AudioGlue::Template
  # Specify characteristics of an output audio file
  head do
    format :mp3
    rate 44100
    channels 2
  end

  # Lets concatenate 2 mp3 files
  body do
    - file("/sounds/hello.mp3")                              # Local file

    if @say_name
      - url("http://some-service.com/my-name-is-glue.mp3")   # Remote file
    end
  end
end

# Create initialized template
template = HelloWorldTemplate.new(:say_name => true)

# Initiate builder with an adapter
adapter = AudioGlue::PlainSoxAdapter.new
builder = AudioGlue::Builder.new(adapter)

# Process template to get audio data
audio = builder.build(template)  # => audio as a binary string

# Write the result to a local file
File.binwrite("/hello_world.mp3", audio)
```

### Templates

Glue template is a template file(e.g. like ERB) which defines how
an output audio should be built.
In terms of ruby it's a subclass of `AudioGlue::Template`.

#### Glue templates

In example above template inherits from `AudioGlue::Template`, but you can also
store them in `.glue` files. For example `/path/to/templates/hello_world.glue`:

```ruby
head {
  format :mp3
  rate 44100
  channels 2
}

body {
  - file("/sounds/hello.mp3")
  if @say_name
    - url("http://some-service.com/my-name-is-glue.mp3")
  end
}
```

And then we can load it with `AudioGlue::TemplateLoader`:

```ruby
# Create instance of loader with basic directory, where templates are located
loader = TemplateLoader.new("/path/to/templates")

# Load and cache the template
loader.get("hello_world")  # => anonymous subclass of AudioGlue::Template
```

#### Glue Syntax

Glue template has 2 sections:
* `head` - contains parameters of output file (`format`, `rate`, `channels`).
* `body` - specifies how to build output

Body contains audio snippets which should be used to build the audio.
There few types of snippets:
* `file` - points to an audio file in the local file system
* `url` - contains a URL to a remote audio file

To make a snippet be added to the output it should have a dash prefix (`-`).


### Custom adapters

You might want to create your own adapter which concatenates audio files, if you think
the existing one is not efficient or you wanna add some caching.

The responsibility of adapters is to build audio data from `AudioGlue::SnippetPacket`.
Snippet packet is a collection of audio snippets and output file
characteristics(format, rate, channels).

A very simple adapter could look like this:

```ruby
# Doesn't support :url snippets. Only files in local file system.
# Doesn't handle rate and channels.
class SimpleAdapter < AudioGlue::BaseAdapter
  # Only this method is required to be implemented.
  def build
    # Extract file paths from snippets. Ensure only :file snippets are present.
    file_paths = @snippet_packet.snippets.map do |snippet|
      raise(AudioGlue::Error, "Only file snippets are supported") unless snippet.type == :file
      snippets.location
    end

    # Build cat command
    command = "cat #{file_paths.join(' ')}"

    # Concatenate files and return result
    %{command}
  end
end
```


## Credits

* [Sergey Potapov](https://github.com/greyblake)

## Copyright

Copyright (c) 2013 TMX Credit.
