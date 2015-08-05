require 'test_helper'

module Plate
  class CompilerTest < Minitest::Test
    def test_compile
      compiled = <<-EOD.strip_heredoc
        <h1 style="font-weight: normal">Main</h1>
        <h2>{{sub}}</h2>
        <p>(Powered by <a href="https://github.com/tnantoka/plate" target="_blank" class="btn btn-default">link</a> gem.)</p>
        <div><img src="image.gif" style="-webkit-animation: spin 1.5s linear infinite; animation: spin 1.5s linear infinite" /></div>
        <p style="color: #333"><a href="url">link <i class="fa fa-external-link"></i></a></p>
        <div class="container">
          <div class="text-center" style="background: #eee">
            <button class="btn btn-default" v-on="click: alert(sub)">button</button>
          </div>
        </div>
        <pre class="prettyprint">code1code2</pre>
        <div class="container">
          <pre class="prettyprint">code3code4</pre>
        </div>
        <div class="list-group">
          <div class="list-group-item" v-repeat="items">
            <h1><a href="{{link}}">{{name}}</a></h1>
            <a href="{{link}}"><img src="{{image}}" /></a>
          </div>
        </div>
      EOD

      assert_equal(
        format_html(compiled),
        format_html(::Plate::Compiler.new.compile(code))
      )
    end

    def test_fonts
      fonts = <<-EOD.strip_heredoc
        <link href="http://fonts.googleapis.com/css?family=Open+Sans" rel="stylesheet">
        <link href="http://fonts.googleapis.com/css?family=Roboto" rel="stylesheet">
      EOD
 
      compiler = ::Plate::Compiler.new
      compiler.compile(code)
      assert_equal(
        format_html(fonts),
        format_html(compiler.fonts)
      )
    end
  end
end
