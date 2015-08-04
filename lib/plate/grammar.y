class Plate::Parser

token FRONT_MATTER
token HEADER 
token NEWLINE TERMINATOR
token STRING
token IDENTIFIER
token INDENT DEDENT
token P
token DIV
token CLASS
token STYLE SCRIPT ATTRIBUTE
token HIGHLIGHT

rule
  Program:
    /* nothing */                          { result = Nodes.new([]) }
  | Expressions                            { result = val[0] }
  ;
  
  Expressions:
    Expression                             { result = Nodes.new(val) }
  | Expressions Terminator Expression      { result = val[0] << val[2] }
  | Expressions Terminator                 { result = val[0] }
  | Terminator                             { result = Nodes.new([]) }
  ;

  Expression:
    Literal
  | FrontMatter
  | Header
  | Link 
  | Image
  | GetLocal
  | Paragraph
  | Div
  | Class
  | Style
  | Script
  | Attribute
  | Code
  ;

  Terminator:
    NEWLINE
  | TERMINATOR
  ;

  FrontMatter:
    FRONT_MATTER                           { result = FrontMatterNode.new(val[0]) }
  ;
  
  Literal:
    STRING                                 { result = StringNode.new(val[0]) }
  ;
  
  Header:
    HEADER Terminator Expression Block     { result = HeaderNode.new(val[0].size, val[2], val[3]) }
  | HEADER Expression Block                { result = HeaderNode.new(val[0].size, val[1], val[2]) }
  | HEADER Terminator Expression           { result = HeaderNode.new(val[0].size, val[2], Nodes.new([])) }
  | HEADER Expression                      { result = HeaderNode.new(val[0].size, val[1], Nodes.new([])) }
  ;

  Link:
    "[" LinkContent "]" "(" Expression ")" 
      Terminator Attributes                { result = LinkNode.new(val[1], val[4], val[7]) }
  | "[" LinkContent "]" "(" Expression ")" 
      Terminator                           { result = LinkNode.new(val[1], val[4], []) }
  | "[" LinkContent "]" "(" Expression ")" { result = LinkNode.new(val[1], val[4], []) }
  ;

  LinkContent:
    Terminator Expression                  { result = val[1] }
  | Expression                             { result = val[0] }
  ;

  Image:
    "![" "]" "(" Expression ")" 
      Terminator Attributes                { result = ImageNode.new(val[3], val[6]) }
  | "![" "]" "(" Expression ")" 
      Terminator                           { result = ImageNode.new(val[3], []) }
  | "![" "]" "(" Expression ")"            { result = ImageNode.new(val[3], []) }
  ;

  Code:
    "```" HIGHLIGHT "```"                  { result = HighlightNode.new(val[1]) }
  ;

  Paragraph:
    P Block                                { result = ParagraphNode.new(val[1]) }
  ;

  Div:
    DIV Block                              { result = DivNode.new(val[1]) }
  ;

  Class:
    CLASS Block                            { result = ClassNode.new(val[0], val[1]) }
  ;

  GetLocal:
    IDENTIFIER                             { result = GetLocalNode.new(val[0]) }
  ;

  Block:
    INDENT Terminator Expressions DEDENT   { result = val[2] }
  | INDENT Expressions DEDENT              { result = val[1] }
  ;

  Attributes:
    "{" "}"                                { result = [] }
  | "{" AttrList "}"                       { result = val[1] }
  ;

  AttrList:
    Expression                             { result = val }
  | AttrList "," Expression                { result = val[0] << val[2] }
  ;

  Style:
    STYLE ":" Expression                   { result = StyleNode.new(val[0], val[2]) }
  ;

  Script:
    SCRIPT ":" Expression                  { result = ScriptNode.new(val[0], val[2]) }
  ;

  Attribute:
    ATTRIBUTE                              { result = AttributeNode.new(val[0]) }
  ;
end

---- header
require 'plate/lexer'
require 'plate/nodes'

---- inner
  def parse(code)
    @tokens = Lexer.new.tokenize(code)
    do_parse
  end
  
  def next_token
    @tokens.shift
  end
