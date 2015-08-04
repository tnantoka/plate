# Plate

A little language to create one page web sites.

## Installation

```
$ gem install plate-lang
```

## Usage

```
$ plate
```

## Development

### Example

```
$ bundle exec plate compile test/fixtures/src/hello.plt
$ open plate/index.html
```

### Test

```
$ bundle exec rake

$ bundle exec rake TEST=test/lexer_test.rb 
```

### Github Pages

#### Examples

```
# Install a font: skeleton/vendor/font-awesome/fonts/fontawesome-webfont.ttf 
$ bundle exec rake examples
```

#### Build

```
$ bundle exec plate compile website -o .
```

## Acknowledgements

This is my first lang with an awesome e-book "[Create Your Own Programming Language](http://createyourproglang.com/)".

## License

MIT

## Author

[@tnantoka](https://twitter.com/tnantoka)

