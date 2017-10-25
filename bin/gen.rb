require 'byebug'
require 'yaml'
require 'erb'
require './lib/resourceful'

@dest = "/home/pfarrell/proj/nimbus/src/main/kotlin/com/cursor/"

def generate(model, template_path, out_dir)
 template = File.read(template_path)
 str = ERB.new(template).result(binding)
 File.write("#{@dest}#{out_dir}", str)
end


yml = YAML.load_file(ARGV[0])
@model = Model.new(yml)



generate(@model, "./lib/templates/model.erb", "models/#{@model.name}.kt")
generate(@model, "./lib/templates/dao.erb", "dao/#{@model.name}DAO.kt")
generate(@model, "./lib/templates/mapper.erb", "mappers/#{@model.name}Mapper.kt")
generate(@model, "./lib/templates/service.erb", "services/#{@model.name}Service.kt")
generate(@model, "./lib/templates/resource.erb", "resources/#{@model.name}Resource.kt")

template = File.read("./lib/templates/migration.erb")
puts ERB.new(template).result(binding)
