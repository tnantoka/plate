require 'yaml'
require 'json'

module Plate
  class Compiler
    attr_accessor :body, :meta, :repeating
    def initialize
      @parser = Parser.new
      self.repeating = false
    end

    def compile(code)
      self.body = @parser
        .parse(code)
        .compile(self)
    end

    def fonts
      return '' if meta.nil? || meta['fonts'].nil?
      meta['fonts'].map { |font|
        "<link href=\"http://fonts.googleapis.com/css?family=#{CGI.escape(font)}\" rel=\"stylesheet\">"
      }.join("")
    end

    def repeating?
      repeating
    end
  end

  class Nodes
    def compile(compiler, parent = nil)
      nodes
        .map { |node| node.compile(compiler, parent) }
        .reject { |s| s.empty? }
        .join("")
    end
  end

  class StringNode
    def compile_icon(icon)
      c = case icon
          when 'i-external'
            'external-link'
          else
            icon.gsub(/\Ai\-/, '')
          end
      "<i class=\"fa fa-#{c}\"></i>"
    end

    def compile(compiler, parent = nil)
      value
        .gsub(/\\/, '')
        .gsub(/\i-[a-z0-9\-]+/) { |m| compile_icon(m) }
    end
  end

  class HighlightNode
    def compile(compiler, parent = nil)
      indent = code[/\A(\s*)/, 1]
      content = CGI.escapeHTML(code.gsub(/^#{indent}/, ''))
      "<pre class=\"prettyprint\">#{content}</pre>"
    end
  end

  class GetLocalNode
    def compile(compiler, parent = nil)
      if parent && parent.is_a?(StyleNode)
        compiler.meta[name].nil? ? name : compiler.meta[name]
      elsif parent && parent.is_a?(ScriptNode)
        name
      else
        r = (parent && parent.repeat?) || compiler.repeating?
        !r && compiler.meta[name].nil? ? name : "{{#{name}}}"
      end
    end
  end

  class AttributeNode
    def compile_value
      case value
      when 'blank'
        'target="_blank"'
      when /\Abtn/
        c = 'class="btn btn-default'
        c << ' btn-lg' if value =~ /\-lg/
        c << ' btn-sm' if value =~ /\-sm/
        c << ' btn-block' if value =~ /\-block/
        c + '"'
      when /spin(\-\d+\.*\d*)?/
        s = value.gsub(/spin\-?/, '')
        s = 1.5 if s.empty?
        "style=\"animation: spin #{s}s linear infinite\""
      when 'inherit'
        'style="color: inherit"'
      else
        ''
      end
    end

    def compile(compiler, parent = nil)
      compile_value
    end
  end

  class StyleNode
    def compile(compiler, parent = nil)
      parent.styles << "#{attribute}: #{value.compile(compiler, self)}"
      ''
    end
  end

  class ScriptNode
    def compile(compiler, parent = nil)
      b = body.compile(compiler, self)
      key, val = case event
            when /repeat/
              ['repeat', b]
            else
              ['on', "#{event}: #{b}"]
            end
      parent.scripts[key] = [] if parent.scripts[key].nil?
      parent.scripts[key] << val
      ''
    end
  end

  class FrontMatterNode
    def compile(compiler, parent = nil)
      meta = YAML.load(yaml)
      compiler.meta = meta
      ''
    end
  end

  class RichNode
    attr_accessor :parent

    def parent_repeat?
      parent && parent.repeat?
    end

    def repeat?
      parent_repeat? || !scripts['repeat'].nil?
    end

    def compile_body(compiler, parent)
      self.parent = parent
      compiler.repeating = repeat?

      content = body.compile(compiler, self)

      style = styles.empty? ? '' : " style=\"#{styles.join(';')}\""

      script = if scripts.empty?
        ''
      else
        scripts.map do |k, v|
          " v-#{k}=\"#{v.join(',')}\""
        end.join('')
      end

      compiler.repeating = parent_repeat?
      [content, style, script]
    end
  end

  class ClassNode
    def compile_tag
      case klass
      when /\A(?:btn)/
        'button'
      else
        'div'
      end
    end

    def compile_class
      klass.split('.').map { |k|
        case k
        when 'btn'
          k + ' btn-default'
        when 'center'
          "text-#{k}"
        when /\A\d\z/
          "col-sm-#{k}"
        else
          k
        end
      }.join(' ')
    end

    def compile(compiler, parent = nil)
      tag = compile_tag
      c = compile_class
      content, style, script = compile_body(compiler, parent)
      "<#{tag} class=\"#{c}\"#{style}#{script}>#{content}</#{tag}>"
    end
  end

  class ParagraphNode
    def compile(compiler, parent = nil)
      content, style, script = compile_body(compiler, parent)
      "<p#{style}#{script}>#{content}</p>"
    end
  end

  class DivNode
    def compile(compiler, parent = nil)
      content, style, script = compile_body(compiler, parent)
      "<div#{style}#{script}>#{content}</div>"
    end
  end

  class HeaderNode
    def compile(compiler, parent = nil)
      tag = "h#{level}"
      style, script = compile_body(compiler, parent)
      "<#{tag}#{style}#{script}>#{text.compile(compiler, self)}</#{tag}>"
    end
  end


  class AttributableNode
    def compile_attributes(compiler)
      attr = " #{attributes.map { |a| a.compile(compiler) }.join(' ')}"
      attr.gsub(/\A\s+\z/, '')
    end
  end

  class LinkNode
    def compile(compiler, parent = nil)
      content = text.compile(compiler)
      attr = compile_attributes(compiler)
      "<a href=\"#{href.compile(compiler)}\"#{attr}>#{content}</a>"
    end
  end

  class ImageNode
    def compile(compiler, parent = nil)
      attr = compile_attributes(compiler)
      "<img src=\"#{src.compile(compiler)}\"#{attr} />"
    end
  end
end
