require 'test_helper'

class PlateTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Plate::VERSION
  end

  def test_preview
    html = '<h1>Header</h1>'
    src = '# Header'
    assert_equal html, ::Plate.preview(src)
  end
end
