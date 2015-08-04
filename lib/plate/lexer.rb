module Plate
  KEYWORDS = %w(p div)

  class Lexer
    attr_accessor :current_indent, :indent_stack, :tokens

    def dedent
      indent_stack.pop
      self.current_indent = indent_stack.last || 0
      tokens << [:DEDENT, current_indent]
    end

    def tokenize(code)
      code.chomp!
      code.gsub!(/^\s*\/\/.*\n/, '')
      self.tokens = []

      self.current_indent = 0
      self.indent_stack = []

      i = 0
      while i < code.size
        chunk = code[i..-1]

        if i == 0 && front_matter = chunk[/\A---\n(.*?)---/m, 1]
          tokens << [:FRONT_MATTER, front_matter]
          tokens << [:NEWLINE, "\n"]
          i += front_matter.size + 8

        elsif identifier = chunk[/\A([a-z][\w:\/\. \-]*)/, 1]
          if KEYWORDS.include?(identifier)
            tokens << [identifier.upcase.to_sym, identifier]
          elsif identifier =~ /\A\w+\z/
            tokens << [:IDENTIFIER, identifier]
          else
            tokens << [:STRING, identifier]
          end
          i += identifier.size

        elsif klass = chunk[/\A\.([\w\-\.]+)/, 1]
          tokens << [:CLASS, klass]
          i += klass.size + 1

        elsif style = chunk[/\A@([\w\-]+)/, 1]
          tokens << [:STYLE, style]
          i += style.size + 1

        elsif script = chunk[/\A\$([\w\-]+)/, 1]
          tokens << [:SCRIPT, script]
          i += script.size + 1

        elsif value = chunk[/\A:([^\n]*)/, 1]
          tokens << [":", ":"]
          tokens << [(value.strip =~ /\A[a-z]\w*\z/ ? :IDENTIFIER : :STRING), value.strip]
          i += value.size + 1

        elsif attrs = chunk[/\A(\s*\{.*)\}/, 1]
          tokens << ["{", "{"]
          attrs.gsub(/\A.*{/, '').split(/,\s*/).each_with_index do |attr, i|
            unless i.zero?
              tokens << [",", ","]
            end
            tokens << [:ATTRIBUTE, attr]
          end
          tokens << ["}", "}"]
          tokens << [:TERMINATOR, " "]
          i += attrs.size + 1

        elsif header = chunk[/\A(#+\s*)/, 1]
          tokens << [:HEADER, header.strip]
          i += header.size

        elsif highlight = chunk[/\A(```.+?```)/m, 1]
          tokens << ["```", "```"]
          tokens << [:HIGHLIGHT, highlight.gsub(/\A```\n/, '').gsub(/\n.*```\z/, '')]
          tokens << ["```", "```"]
          i += highlight.size

        elsif string = chunk[/\A((?:[^\n\[\]\(\)!\\]|\\.)(?:[^\n\[\]\(\)\\]|\\.)*)/, 1]
          tokens << [:STRING, string]
          i += string.size

        elsif indent = chunk[/\A\n( *)/m, 1]
          if indent.size.odd? || 
            (indent.size > current_indent && indent.size != current_indent + 2)
            raise "Bad indent, #{current_indent} -> #{indent.size}: #{chunk[/\A\n(.*)\n/, 1]}"
          end

          if indent.size > current_indent
            self.current_indent = indent.size
            indent_stack.push(current_indent)
            tokens << [:INDENT, indent.size]
          elsif indent.size == current_indent
            tokens << [:NEWLINE, "\n"]
          elsif indent.size < current_indent
            begin
              dedent
            end while indent.size < current_indent
            tokens << [:NEWLINE, "\n"]
          end
          i += indent.size + 1

        #elsif chunk.match(/\A\n/)
        #  tokens << [:NEWLINE, "\n"]
        #  i += 1

        elsif open = chunk[/\A(!?\[)/, 1]
          tokens << [:TERMINATOR, " "]
          tokens << [open, open]
          i += open.size 

        elsif close = chunk[/\A(\))/, 1]
          tokens << [close, close]
          tokens << [:TERMINATOR, " "]
          i += 1

        #elsif chunk.match(/\A\s/)
        #  tokens << [:TERMINATOR, " "]
        #  tokens << [:STRING, " "]
        #  i += 1

        else
          value = chunk[0, 1]
          tokens << [value, value]
          i += 1
        end
      end

      if current_indent > 0
        begin
          dedent
        end while current_indent > 0
        tokens << [:NEWLINE, "\n"]
      end
      tokens
    end
  end
end
