require 'simplecov'
SimpleCov.start

require "minitest/autorun"
require "minitest/pride"

require_relative "../lib/chisel"


class ChiselTest < Minitest::Test
  attr_reader :chisel

  def setup
    input_file = "./lib/sample_input.markdown"
    @chisel = Chisel.new(input_file)
  end

  def test_it_gets_the_input_text_from_the_input_file
    input_file = "./lib/sample_input.markdown"
    actual = chisel.get_input_text(input_file)
    expected = "#Hello, *world*\n\nHello, **world**\n"
    assert_equal expected, actual
  end

  def test_it_gets_the_chunked_text_from_the_chunk_maker
    actual = chisel.get_chunks
    expected = ["#Hello, *world*", "Hello, **world**\n"]
    assert_equal expected, actual
  end

  def test_it_gets_rendered_text_from_the_renderer
    actual = chisel.get_rendered
    expected = ["<h1>Hello, *world*</h1>", "<p>Hello, **world**\n</p>"]
    assert_equal expected, actual
  end

  def test_it_gets_emphasized_text_back_from_the_emphasizer
    actual = chisel.get_emphasis
    expected = ["<h1>Hello, <em>world</em></h1>", "<p>Hello, <strong>world</strong>\n</p>"]
    assert_equal expected, actual
  end

  def test_it_gets_links_formatted_by_the_link_maker
    input_files = "./lib/sample_link_input.markdown"
    chisel_link = Chisel.new(input_files)

    actual = chisel_link.get_links
    expected = ["<p>\"This is <a href=\"http://example.com/\" title=\"Title\">an example</a>inline link. " +
    "<a href=\"http://example.net/\">This link</a> has no title attribute.\"\n</p>"]
    assert_equal expected, actual
  end

  def test_it_looks_like_the_above
    input_files = "./lib/test_sample_link.markdown"
    chisel_link = Chisel.new(input_files)

    actual = chisel_link.get_links
    expected = ["<p><a href=\"http://example.net/\">This link</a> has no title attribute.\n</p>"]

    assert_equal expected, actual
  end

  def test_it_returns_a_formatted_string_from_the_formatter
    actual = chisel.get_formatted
    expected = "<h1>Hello, <em>world</em></h1>\n<p>Hello, <strong>world</strong>\n</p>"

    assert_equal expected, actual
  end

  def test_it_sends_the_html_to_the_output_file
    input_file = "./lib/sample_input.markdown"
    output_file = "./lib/sample_output.html"
    output_chisel = Chisel.new(input_file, output_file)

    actual = output_chisel.write_output_file
    expected = "<h1>Hello, <em>world</em></h1>\n<p>Hello, <strong>world</strong>\n</p>"
    assert_equal expected, actual
  end
end
