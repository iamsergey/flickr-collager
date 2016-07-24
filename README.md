# Flickr Collager

A simple Flickr collage maker based on keywords

## Installation

Build the gem:

```bash
rake build
```

Then install it:

```bash
rake install
```

And don't forget to set Flickr API key:
```bash
export FLICKR_API_KEY=yourkey
```

## Usage

You can use it as a command line tool, by passing a keywords and an output file like:

```bash
flickr-collager cat dog mouse "black rabbit" > collage.jpg
```

Or in your application like:

```ruby
Flickr::Collager.generate keywords: ['cat', 'dog', 'mouse', 'rabbit'],
                          size: 6,
                          width: 1000,
                          height: 600,
                          tile: '3x2',
                          padding: 2
                          io: file_or_io
```

If there's not enough keywords or images found, it will use random keywords from the standard dictionary to get more.

## Testing

```bash
rspec
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

