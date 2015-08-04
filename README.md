# Plate

[![Circle CI](https://circleci.com/gh/tnantoka/plate.svg?style=svg)](https://circleci.com/gh/tnantoka/plate)
[![Code Climate](https://codeclimate.com/github/tnantoka/plate/badges/gpa.svg)](https://codeclimate.com/github/tnantoka/plate)
[![Test Coverage](https://codeclimate.com/github/tnantoka/plate/badges/coverage.svg)](https://codeclimate.com/github/tnantoka/plate/coverage)

A little language to create one page websites.

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

