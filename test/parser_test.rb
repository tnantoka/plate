require 'test_helper'

module Plate
  class ParserTest < Minitest::Test
    def test_parse
      nodes = Nodes.new([
        FrontMatterNode.new(front_matter),
        HeaderNode.new(
          1,
          StringNode.new('Main'),
          Nodes.new([
            StyleNode.new('font-weight', GetLocalNode.new('normal'))
          ])
        ),
        HeaderNode.new(2, GetLocalNode.new('sub'), Nodes.new([])),
        ParagraphNode.new(
          Nodes.new([
            StringNode.new('\(Powered by '),
            LinkNode.new(
              GetLocalNode.new('link'), 
              StringNode.new('https://github.com/tnantoka/plate'),
              [
                AttributeNode.new('blank'),
                AttributeNode.new('btn'),
              ]
            ),
            StringNode.new(' gem.\)')
          ])
        ),
        DivNode.new(
          Nodes.new([
            ImageNode.new(
              StringNode.new('image.gif'),
              [
                AttributeNode.new('spin')
              ]
            ),
          ])
        ),
        ParagraphNode.new(
          Nodes.new([
            StyleNode.new('color', StringNode.new('#333')),
            LinkNode.new(
              StringNode.new('link i-external'), 
              GetLocalNode.new('url'),
              []
            )
          ])
        ),
        ClassNode.new(
          'container',
          Nodes.new([
            ClassNode.new(
              'center',
              Nodes.new([
                StyleNode.new('background', StringNode.new('#eee')),
                ClassNode.new(
                  'btn',
                  Nodes.new([
                    ScriptNode.new('click', StringNode.new('alert(sub)')),
                    GetLocalNode.new('button'),
                  ])
                )
              ])
            )
          ])
        ),
        HighlightNode.new("code1\ncode2"),
        ClassNode.new(
          'container',
          Nodes.new([
            HighlightNode.new("  code3\n  code4")
          ])
        ),
        ClassNode.new(
          'list-group',
          Nodes.new([
            ClassNode.new(
              'list-group-item',
              Nodes.new([
                ScriptNode.new('repeat', GetLocalNode.new('items')),
                HeaderNode.new(
                  1,
                  LinkNode.new(
                    GetLocalNode.new("name"),
                    GetLocalNode.new('link'),
                    []
                  ),
                  Nodes.new([])
                ),
                LinkNode.new(
                  ImageNode.new(
                    GetLocalNode.new('image'),
                    []
                  ),
                  GetLocalNode.new('link'),
                  []
                )
              ])
            )
          ])
        )
      ])
      
      assert_equal(
        format_nodes(nodes),
        format_nodes(Parser.new.parse(code))
      )
    end

    private
      def format_nodes(nodes)
        nodes.inspect.gsub(/, /, "\n")
      end
  end
end
