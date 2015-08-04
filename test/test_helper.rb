require 'simplecov'
SimpleCov.start do
  add_filter "parser.rb"
end

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'plate'

require 'minitest/autorun'

require 'active_support'
require 'active_support/core_ext'

def front_matter
  <<-EOD.strip_heredoc
    title: test

    sub: Sub
    fonts:
      - Open Sans
      - Roboto

    items:
      - name: item1
        link: link1
        image: image1.png
      - name: item2
        link: link2
        image: image2.png
  EOD
end

def code
  c = <<-EOD.strip_heredoc
    # Main
      @font-weight: normal
    ## sub
    p
      \\(Powered by [link](https://github.com/tnantoka/plate) {blank, btn} gem.\\)
    div
      ![](image.gif) {spin}
    p
      @color: #333
      [link i-external](url) {}

    .container
      .center
        @background: #eee
        .btn
          $click: alert(sub)
          button

    ```
    code1
    code2
    ```

    .container
      ```
      code3
      code4
      ```

    .list-group
      .list-group-item
        $repeat: items
        # [name](link)
        [![](image)](link)

  EOD
  "---\n#{front_matter}---\n#{c}"
end

def format_html(html)
  html
    .gsub(/\n/, '')
    .gsub(/>\s+/, '>')
    .gsub(/\s+</, '<')
    .gsub(/>\s+</, '><')
    .gsub(/>/, ">\n")
end

