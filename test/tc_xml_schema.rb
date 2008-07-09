require "libxml"
require 'test/unit'

class TestSchema < Test::Unit::TestCase
  def setup
    xp = XML::Parser.new
    @doc = XML::Document.file('model/shiporder.xml')
  end
  
  def teardown
    @doc = nil
  end
  
  def schema
    document = XML::Document.file('model/shiporder.xsd')
    schema = XML::Schema.document(document)
  end

  def test_from_doc
    assert_instance_of(XML::Schema, schema)
  end
  
  def test_valid
    assert(@doc.validate_schema(schema))
  end
  
  def test_invalid
    new_node = XML::Node.new('invalid', 'this will mess up validation')
    @doc.root.child_add(new_node)
    
    messages = Hash.new
    assert(!@doc.validate_schema(schema) do |message, error|
      messages[message] = error
    end)

    expected = {"Element 'invalid': This element is not expected. Expected is ( item ).\n" => true}
    assert_equal(expected, messages)
  end
end
