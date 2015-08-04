require 'test_helper'

module Plate
  class LexterTest < Minitest::Test
    def test_tokenize
      tokens = [
        [:FRONT_MATTER, front_matter], [:NEWLINE, "\n"],
        [:HEADER, '#'], [:STRING, 'Main'],
          [:INDENT, 2],
            [:STYLE, "font-weight"], [":", ":"], [:IDENTIFIER, "normal"],
          [:DEDENT, 0], [:NEWLINE, "\n"],
        [:HEADER, '##'], [:IDENTIFIER, 'sub'], [:NEWLINE, "\n"],
        [:P, "p"],
          [:INDENT, 2],
            [:STRING, "\\(Powered by "], [:TERMINATOR, " "],
            ["[", "["], [:IDENTIFIER, "link"], ["]", "]"],
            ["(", "("], [:STRING, "https://github.com/tnantoka/plate"], [")", ")"], [:TERMINATOR, " "],
            ["{", "{"], [:ATTRIBUTE, "blank"], [",", ","], [:ATTRIBUTE, "btn"], ["}", "}"], [:TERMINATOR, " "],
            [:STRING, " gem.\\)"],
          [:DEDENT, 0], [:NEWLINE, "\n"],
        [:DIV, "div"],
          [:INDENT, 2],
            [:TERMINATOR, " "],
            ["![", "!["], ["]", "]"], ["(", "("], [:STRING, "image.gif"], [")", ")"], [:TERMINATOR, " "],
            ["{", "{"], [:ATTRIBUTE, "spin"], ["}", "}"], [:TERMINATOR, " "],
          [:DEDENT, 0], [:NEWLINE, "\n"],
        [:P, "p"],
          [:INDENT, 2],
            [:STYLE, "color"], [":", ":"], [:STRING, "#333"], [:NEWLINE, "\n"],
            [:TERMINATOR, " "],
            ["[", "["], [:STRING, "link i-external"], ["]", "]"],
            ["(", "("], [:IDENTIFIER, "url"], [")", ")"], [:TERMINATOR, " "],
            ["{", "{"], ["}", "}"], [:TERMINATOR, " "],
          [:DEDENT, 0], [:NEWLINE, "\n"],
        [:NEWLINE, "\n"],
        [:CLASS, "container"],
          [:INDENT, 2],
            [:CLASS, "center"],
              [:INDENT, 4],
                [:STYLE, "background"], [":", ":"], [:STRING, "#eee"], [:NEWLINE, "\n"],
                [:CLASS, "btn"],
                  [:INDENT, 6],
                    [:SCRIPT, "click"], [":", ":"], [:STRING, "alert(sub)"], [:NEWLINE, "\n"],
                    [:IDENTIFIER, "button"],
                  [:DEDENT, 4],
              [:DEDENT, 2],
          [:DEDENT, 0], [:NEWLINE, "\n"],
        [:NEWLINE, "\n"],
        ["```", "```"], [:HIGHLIGHT, "code1\ncode2"], ["```", "```"], [:NEWLINE, "\n"],
        [:NEWLINE, "\n"],
        [:CLASS, "container"],
          [:INDENT, 2],
            ["```", "```"], [:HIGHLIGHT, "  code3\n  code4"], ["```", "```"],
          [:DEDENT, 0], [:NEWLINE, "\n"],
        [:NEWLINE, "\n"],
        [:CLASS, "list-group"],
          [:INDENT, 2],
            [:CLASS, "list-group-item"],
              [:INDENT, 4],
                [:SCRIPT, "repeat"], [":", ":"], [:IDENTIFIER, "items"], [:NEWLINE, "\n"],
                [:HEADER, "#"], [:TERMINATOR, " "],
                ["[", "["], [:IDENTIFIER, "name"], ["]", "]"], ["(", "("], [:IDENTIFIER, "link"], [")", ")"],
                [:TERMINATOR, " "],
                [:NEWLINE, "\n"],
                [:TERMINATOR, " "], ["[", "["],
                [:TERMINATOR, " "],
                ["![", "!["], ["]", "]"], ["(", "("], [:IDENTIFIER, "image"], [")", ")"],
                [:TERMINATOR, " "], ["]", "]"],
                ["(", "("], [:IDENTIFIER, "link"], [")", ")"],
                [:TERMINATOR, " "],
              [:DEDENT, 2],
          [:DEDENT, 0], [:NEWLINE, "\n"]
      ]

      assert_equal(
        format_tokens(tokens),
        format_tokens(::Plate::Lexer.new.tokenize(code))
      )
    end

    def test_bad_indent
      code0 = <<-EOD.strip_heredoc
        # Main
        ## sub
      EOD
      code1 = <<-EOD.strip_heredoc
        # Main
         ## sub
      EOD
      code2 = <<-EOD.strip_heredoc
        # Main
            ## sub
      EOD
      code3 = <<-EOD.strip_heredoc
        # Main
          ## sub
         ## sub
      EOD

      [code0].each do |code|
        ::Plate::Lexer.new.tokenize(code)
      end

      [code1, code2, code3].each do |code|
        assert_raises RuntimeError do
          ::Plate::Lexer.new.tokenize(code)
        end
      end
    end

    private
      def format_tokens(tokens)
        tokens.inspect.gsub(/, \[/, "\n[")
      end
  end
end


