require 'thor'

module Plate
  class CLI < Thor
    include Thor::Actions

    source_root File.dirname(__FILE__)

    desc 'version', 'Prints the version information'
    # :nocov:
    def version
      say "Plate version #{Plate::VERSION}"
    end
    # :nocov:

    DEPENDENCIES = %w(
      bootstrap
      font-awesome
      jquery
      google-code-prettify
      vue
    )

    desc 'compile SOURCE', 'Compiles the plate scripts'
    option :o, type: :string, desc: 'Output directory', default: './plate'
    def compile(source)
      output = options[:o]
      skeleton = File.expand_path('../../../skeleton/app', __FILE__)
      vendor = File.expand_path('../../../skeleton/vendor', __FILE__)

      plt, dir = read_plt(source)

      compiler = Compiler.new
      compiler.compile(plt)

      directory(skeleton, output)
      DEPENDENCIES.each do |d|
        directory(File.join(vendor, d), File.join(output, 'vendor', d))
      end

      build_html(output, compiler)
      build_js(output, compiler)
      build_css(output, compiler, vendor)

      if dir
        directory(File.join(Dir.pwd, source), output)
        remove_file(File.join(Dir.pwd, output, 'index.plt'))
      end

    end

    private
      def read_plt(source)
        dir = File.directory?(source)
        path = dir ? File.join(source, 'index.plt') : source
        [File.read(path), dir]
      end 

      def build_html(output, compiler)
        body = compiler.body
        meta = compiler.meta
        title = meta['title']
        data = JSON.dump(compiler.meta)
        head = compiler.fonts

        path = File.join(output, 'index.html')
        build(path, binding)
      end

      def build_js(output, compiler)
        path = File.join(output, 'assets', 'js', 'app.js')
        build(path, binding)
      end

      def build_css(output, compiler, vendor)
        meta = compiler.meta
        bootstrap = meta['bootstrap'] || {}

        path = File.join(output, 'assets', 'css', 'app.css')
        build(path, binding)

        theme = bootstrap['theme']
        unless theme.nil?
          name = 'bootstrap.min.css'
          path = File.join(Dir.pwd, output, 'vendor', 'bootstrap', 'dist', 'css', name)
          remove_file(path)
          copy_file(File.join(vendor, 'bootswatch', theme, name), path)
        end
      end

      def build(path, b)
        erb = File.read(path)
        rendered = ERB.new(erb).result(b)
        File.write(path, rendered)
      end
  end
end
