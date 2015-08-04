module Plate
  class Nodes < Struct.new(:nodes)
    def <<(node)
      nodes << node
      self
    end
  end

  class LiteralNode < Struct.new(:value); end

  class StringNode < LiteralNode; end

  class HighlightNode < Struct.new(:code); end

  class GetLocalNode < Struct.new(:name); end

  class AttributeNode < Struct.new(:value); end

  class StyleNode < Struct.new(:attribute, :value); end

  class ScriptNode < Struct.new(:event, :body); end

  class FrontMatterNode < Struct.new(:yaml); end

  module Inspector
    def inspect_with(values)
      i = public_method(:inspect).super_method.call
      i.gsub(/>\z/, ", #{values.join(', ')}>")
    end
  end

  RichNode = Struct.new(:styles, :scripts, :body) do
    include Inspector

    def initialize(body)
      self.styles = []
      self.scripts = {}
      self.body = body
    end
  end

  class HeaderNode < RichNode
    attr_accessor :level, :text
    def initialize(level, text, body)
      super(body)
      self.level = level
      self.text = text
    end

    def inspect
      inspect_with([level, text])
    end
  end

  class ClassNode < RichNode
    attr_accessor :klass
    def initialize(klass, body)
      super(body)
      self.klass = klass
    end

    def inspect
      inspect_with([klass])
    end
  end

  class ParagraphNode < RichNode
    def initialize(body)
      super(body)
    end
  end

  class DivNode < RichNode
    def initialize(body)
      super(body)
    end
  end

  AttributableNode = Struct.new(:attributes) do
    include Inspector
  end

  class LinkNode < AttributableNode
    attr_accessor :text, :href 
    def initialize(text, href, attributes)
      self.text = text
      self.href = href
      self.attributes = attributes
    end

    def inspect
      inspect_with([text, href])
    end
  end

  class ImageNode < AttributableNode
    attr_accessor :src
    def initialize(src, attributes)
      self.src = src
      self.attributes = attributes
    end

    def inspect
      inspect_with([src])
    end
  end
end
