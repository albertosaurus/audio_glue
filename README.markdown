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

Glue template is a template file(e.g. like ERB) which defines how
an output audio should be built.

In terms of ruby it's a subclass of `AudioGlue::Template`.

There 2 to define a glue template.

Inherit from `AudioGlue::Template`:

```ruby
class HelloWorldTemplate < AudioGlue::Template
  # Specify characteristics of an output audio file
  head do
    format :mp3
    rate 44100
    channels 2
  end

  # Lets concatenate 2 mp3 files
  body do
    - file('/sounds/hello.mp3')                              # Local file

    if @say_name
      - url('http://some-service.com/my-name-is-glue.mp3')   # Remote file
    end
  end
end
```

Or you can define a file with `.glue` extension, e.g. `/path/to/templates/hello_world.glue`:

```ruby
head {
  format :mp3
  rate 44100
  channels 2
}

body {
  - file('/sounds/hello.mp3')
  if @say_name
    - url('http://some-service.com/my-name-is-glue.mp3')
  end
}
```

And then load it with `AudioGlue::TemplateLoader`:

```ruby
# Create instance of loader with basic directory, where templates are located
loader = TemplateLoader.new('/path/to/templates')

# Load and cache the template
loader.load('hello_world')  # => anonymous subclass of AudioGlue::Template
```

Finally let's build an audio:

```ruby
# Create initialized template
template = HelloWorldTemplate.new(:say_name => true)

# Initiate builder with an adapter
adapter = AudioGlue::PlainSoxAdapter.new
builder = AudioGlue::Builder.new(adapter)

# Process template to get audio data
audio = builder.build(template)  # => audio as a binary string

# Lets write the result to a local file
File.binwrite('/hello_world.mp3', audio)
```


## Credits

* [Sergey Potapov](https://github.com/greyblake)

## Copyright

Copyright (c) 2013 TMX Credit.
