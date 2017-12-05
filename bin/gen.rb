require 'byebug'
require 'yaml'
require 'erb'
require 'active_support/inflector'
require './lib/resourceful'

@src_dest = "/home/pfarrell/proj/nimbus/src/main/kotlin/com/cursor/"
@test_dest = "/home/pfarrell/proj/nimbus/src/test/kotlin/com/cursor/"

def generate(model, template_path, out_dir)
  puts "processing: #{template_path}"
  template = File.read(@templates + "/" + template_path)
  str = ERB.new(template).result(binding)
  File.write("#{out_dir}", str)
end

byebug

yml = YAML.load_file(ARGV[0])
@model = Model.new(yml)

@templates = "./lib/templates/#{ARGV[1]}/"

Dir.entries(@templates).select{|x| x.end_with?("erb")}.each do |template|
  basename = File.basename(template, ".erb")
  next if basename =~ /migration/
  camelcase = (basename == 'model') ? '' : basename.camelcase
  camelcase = (basename == 'dao') ? 'DAO' : camelcase
  dest = (basename =~ /_test/) ? @test_dest : @src_dest
  generate(@model, template, "#{dest}#{basename.gsub(/_test/, '').pluralize}/#{@model.name}#{camelcase}.kt")
end

template = File.read("./lib/templates/#{ARGV[1]}/migration.erb")
puts ERB.new(template).result(binding)
