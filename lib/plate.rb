require "plate/version"
require "plate/cli"
require "plate/lexer"
require "plate/parser"
require "plate/compiler"

module Plate
  class << self
    def preview(src)
      compiler = Compiler.new
      compiler.compile(src)
    end
  end
end
