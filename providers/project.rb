require 'net/http'
action :create do
	#if @current_resource.exists
#		Chef::Log.info "#{ @new_resource } already exists - nothing to do."
#	else
		converge_by("Create #{ @new_resource }") do
			create_project
		end
#	end
end

def create_project
   token = new_resource.token
	uri = URI.parse("http://192.168.17.118:4440")
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = false
	#request = Net::HTTP::Get.new("/api/1/projects?authtoken=" + token)
	request = Net::HTTP::Post.new("/api/11/projects")
   request.add_field("X-Rundeck-Auth-Token", token)
   request.add_field("Content-Type", "application/json")
   create_data = '{ "name": ' + new_resource.name + ', "config": {} }'
   request.body = create_data
	response = http.request(request)
end
