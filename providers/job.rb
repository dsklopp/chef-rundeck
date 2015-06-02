require 'net/http'
action :create do
#if @current_resource.exists
#		Chef::Log.info "#{ @new_resource } already exists - nothing to do."
#	else
		converge_by("Create #{ @new_resource }") do
			create_job
		end
#	end
end

def create_job
   token = new_resource.token
	uri = URI.parse("http://192.168.17.118:4440")
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = false
	request = Net::HTTP::Post.new("/api/1/jobs/import")
   request.add_field("X-Rundeck-Auth-Token", token)
   request.add_field("Content-Type", "application/json")
   formdata = %{ 
<joblist>
  <job>
    <loglevel>INFO</loglevel>
    <sequence keepgoing='false' strategy='step-first'>
      <command>
        <scriptfile>#{new_resource.scriptfile}</scriptfile>
        <scriptargs>#{new_resource.scriptargs}</scriptargs>
      </command>
    </sequence>
    <description>
#{new_resource.description}
    </description>
    <name>#{new_resource.name}</name>
    <context>
      <project>#{new_resource.project}</project>
    </context>
  </job>
</joblist>
   }
   Chef::Log.error(request.to_s)
   request.set_form_data('xmlBatch' => formdata, 'dupeOption' => 'update')
	response = http.request(request)
end


