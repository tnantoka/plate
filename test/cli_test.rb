require 'test_helper'

module Plate
  class CLITest < Minitest::Test
    def test_compile_hello
      output = './tmp/hello'
      FileUtils.rm_rf(output)
      CLI.new.invoke(:compile, ['test/fixtures/src/hello.plt'], o: output)
      assert_equal(
        format_html(File.read('test/fixtures/compiled/hello/index.html')),
        format_html(File.read("#{output}/index.html"))
      )

      assert_equal(
        File.read('test/fixtures/compiled/hello/app.js'),
        File.read("#{output}/assets/js/app.js")
      )

      assert_equal(
        File.read('test/fixtures/compiled/hello/app.css'),
        File.read("#{output}/assets/css/app.css")
      )
    end

    def test_compile_image
      output = './tmp/image'
      FileUtils.rm_rf(output)
      CLI.new.invoke(:compile, ['test/fixtures/src/image'], o: output)
      assert_equal(
        format_html(File.read('test/fixtures/compiled/image/index.html')),
        format_html(File.read("#{output}/index.html"))
      )

      assert_equal(
        File.read('test/fixtures/src/image/image.png'),
        File.read("#{output}/image.png")
      )
    end

    def test_compile_font
      assert_html('font')
    end

    def test_compile_highlight
      assert_html('highlight')
    end

    def test_compile_example
      assert_html('example')
    end

    def test_compile_list
      assert_html('list')
    end

    private
      def assert_html(name)
        output = "./tmp/#{name}"
        FileUtils.rm_rf(output)
        CLI.new.invoke(:compile, ["test/fixtures/src/#{name}.plt"], o: output)
        assert_equal(
          format_html(File.read("test/fixtures/compiled/#{name}/index.html")),
          format_html(File.read("#{output}/index.html"))
        )
      end      
  end
end
