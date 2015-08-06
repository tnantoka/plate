---
title: Plate
background: '#eee'

fonts:
  - Yantramanav:100

examples:
  - title: Hello
    image: examples/hello.png
    link: examples/hello/index.html
    src: https://github.com/tnantoka/plate/tree/master/test/fixtures/src/hello.plt
    desc: Basic template, Script
  - title: Image
    image: examples/image.png
    link: examples/image/index.html
    src: https://github.com/tnantoka/plate/tree/master/test/fixtures/src/image/index.plt
    desc: Image, Spin
  - title: List
    image: examples/list.png
    link: examples/list/index.html
    src: https://github.com/tnantoka/plate/tree/master/test/fixtures/src/list.plt
    desc: Repeat, Theme
  - title: Highlight
    image: examples/highlight.png
    link: examples/highlight/index.html
    src: https://github.com/tnantoka/plate/tree/master/test/fixtures/src/highlight.plt
    desc: Syntax highlight
  - title: Font
    image: examples/font.png
    link: examples/font/index.html
    src: https://github.com/tnantoka/plate/tree/master/test/fixtures/src/font.plt
    desc: Font Awesome, Google Fonts
  - title: Example
    image: examples/example.png
    link: examples/example/index.html
    src: https://github.com/tnantoka/plate/tree/master/test/fixtures/src/example.plt
    desc: The example above

bootstrap:
  radius: 0
---

div
  @background: #333
  @height: 20px
  //@position: fixed
  @top: 0
  @left: 0
  @right: 0
  @z-index: 1

.center
  @padding-top: 50px
  .jumbotron
    @background: transparent
    .container
      ![](logo.png) {spin-180}
      # Plate
        @font-family: 'Yantramanav', sans-serif
        @font-size: 80px
      p
        A little language to create one page websites.
  .jumbotron
    @background: background
    .container
      .row
        .6
          ### [example.plt](https://github.com/tnantoka/plate/tree/master/test/fixtures/src/example.plt) {inherit}
          .text-left
            ```
            ---
            message: hello
            ---
            .container
              @background: #f9f9f9
              # Hello, world
              p
                .btn
                  $click: alert(message) 
                  Click me
            ```
        .6
          ### [index.html](https://github.com/tnantoka/plate/tree/gh-pages/examples/example/index.html) {inherit}
          .text-left
            ```
            <div class="container"
                 style="background: #f9f9f9">
              <h1>Hello, world</h1>
              <p>
                <button class="btn btn-default"
                        v-on="click: alert(message)">
                  Click me
                </button>
              </p>
            </div>
            ```
  .container
    ## Examples
    .row
      .4
        $repeat: examples
        .thumbnail.hover
          [![](image)](link)
          .caption
            ### [title](link) {inherit}
            p
              desc
            p
              [Source](src) {blank, btn-sm}
  div
    @background: background
    @padding-top: 60px
    @padding-bottom: 60px
    @margin-top: 30px
    .container
      .row
        .5.offset-1
          [i-pencil-square-o Try it now](http://try-plate.herokuapp.com/) {blank, btn-lg-block}
        .5
          [i-github Fork me on GitHub](https://github.com/tnantoka/plate) {blank, btn-lg-block}
  .clearfix
    @background: #333
    @color: #fff
    @margin-bottom: 0
    @padding-top: 20px
    @padding-bottom: 30px
    .container
      .pull-right
        .text-right
          p
            Generate by [Plate](https://github.com/tnantoka/plate) {blank, inherit}. 
            \([Source](https://github.com/tnantoka/plate/tree/master/website/index.plt) {blank, inherit}\)
      .text-left
        p
          \(c\) 2015 [\@tnantoka](https://twitter.com/tnantoka) {blank, inherit}
