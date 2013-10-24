# AudioGlue

[![Build Status](https://travis-ci.org/TMXCredit/audio_glue.png?branch=master)](https://travis-ci.org/TMXCredit/audio_glue)

Audio template engine (aka ERB/HAML for audio).

## Usage

An example:

```ruby
  require 'audio_glue'

  # We need to use one of the adapters.
  # This one comes from the audio_glue-sox_adapter gem:
  require 'audio_glue/sox_adapter'


  # Create a template class:
  class HelloWorldTemplate < AudioGlue::Template
    # Specify the characteristics of an output audio file:
    head do
      format :mp3
      rate 44100
      channels 2
    end

    # Lets concatenate 2 mp3 files:
    body do
      - file("/sounds/hello.mp3")                              # Local file

      if @say_name
        - url("http://some-service.com/my-name-is-glue.mp3")   # Remote file
      end
    end
  end

  # Initialize a template:
  template = HelloWorldTemplate.new(:say_name => true)

  # Optionally, build using an adapter:
  adapter = AudioGlue::PlainSoxAdapter.new
  builder = AudioGlue::Builder.new(adapter)

  # Process a template to get audio data:
  audio = builder.build(template)  # => audio as a binary string

  # Write the result to a local file:
  File.binwrite("/hello_world.mp3", audio)
```

### Templates

A glue template is a template file (e.g. like ERB or HAML) which defines how
the output audio should be built.
In Ruby terms, it's a subclass of `AudioGlue::Template`.

#### Glue templates

In the example above, the template inherits from `AudioGlue::Template`.
But you can also store templates in `.glue` files.
For example `/path/to/templates/hello_world.glue`:

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
  # Create an instance of the loader with a basic directory,
  # where templates are located:
  loader = TemplateLoader.new("/path/to/templates")

  # Load and cache the template:
  loader.get("hello_world")  # => anonymous subclass of AudioGlue::Template
```

#### Glue Syntax

Each glue template has 2 sections:

* `head` - contains the parameters of the output file (`format`, `rate`, `channels`)
* `body` - specifies how to build the output

The `body` references the audio snippets that will be used to build the output
audio. There a few types of snippets:

* `file` - points to an audio file in the local file system
* `url` - contains a URL to a remote audio file

To make a snippet be added to the output it should have a dash prefix (`-`).


### Custom adapters

You may want to create your own adapter to concatenate audio files, if you
think the existing one is not efficient, or if you want to add some caching.

The responsibility of adapters is to build audio data from
`AudioGlue::SnippetPacket`. The snippet packet is a collection of audio
snippets and output file characteristics(format, rate, channels).

A very simple adapter could look like this:

```ruby
  # Doesn't support :url snippets, only files in local file system.
  # Doesn't handle rate and channels.
  class SimpleAdapter < AudioGlue::BaseAdapter
    # Only this method is required to be implemented.
    def build(snippet_packet)
      # Extract file paths from snippets.
      # Ensure only :file snippets are present.
      file_paths = snippet_packet.snippets.map do |snippet|
        unless snippet.type == :file
          raise(AudioGlue::Error, "Only file snippets are supported")
        end
        snippets.source
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
