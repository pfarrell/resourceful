class Field
  attr_accessor :name, :codeType, :dbType

  def initialize(name, hsh)
    @name = name
    @codeType = hsh['codeType']
    @dbType = hsh['dbType']
  end

  def snake_case
    underscore(@name)
  end

  def underscore(camel_cased_word)
       camel_cased_word.to_s.gsub(/::/, '/').
         gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
         gsub(/([a-z\d])([A-Z])/,'\1_\2').
         tr("-", "_").
         downcase
  end

  def sample_data(i)
    case @codeType
    when "Long"
      "#{i}L"
    when "String"
      "\"test_#{@name}\""
    end
  end
end

class Model
  attr_accessor :yaml, :db_table, :package, :name, :model_fields, :link_fields

  def initialize(hsh) @name = hsh['name'].capitalize
    @db_table = hsh['dbTable']
    @package = 'com.cursor'
    @model_fields = hsh['modelFields'] ? hsh['modelFields'].map{|a| a.map{|k,v| Field.new(k, v)} }.flatten : []
    @link_fields = hsh['linkFields'] ? hsh['linkFields'].map{|a| a.map{|k,v| Field.new(k, v)} }.flatten : []
  end

  def fields
    @link_fields + @model_fields
  end
end
