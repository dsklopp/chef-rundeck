require 'net/http'
require 'rexml/document'
action :create do
if @current_resource.exists
		Chef::Log.info "#{ @new_resource }:#{@new_resource.name} already exists in project #{@new_resource.project} - nothing to do."
	else
		converge_by("Create #{ @new_resource }") do
			create_job
		end
	end
end

def create_job
   token = new_resource.token
	uri = URI.parse("http://#{node['rundeck']['hostname']}:#{node['rundeck']['port']}")
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
   request.set_form_data('xmlBatch' => formdata, 'dupeOption' => 'update')
	response = http.request(request)
end

def list_job(token, project)
   uri = URI.parse("http://192.168.17.118:4440")
   http = Net::HTTP.new(uri.host, uri.port)
   http.use_ssl = false
   request = Net::HTTP::Get.new("/api/2/project/#{project}/jobs")
   request.add_field("X-Rundeck-Auth-Token", token)
	response = http.request(request)
   return response.body
end

def job_exists?(token, project, name)
   xml_data=list_job(token, project)
   doc = REXML::Document.new(xml_data)
   doc.elements.each("result/jobs/job/name") do |element|
      if element.text == name
         return true
      end
   end
   return false
end

def load_current_resource
   @current_resource = Chef::Resource::RundeckJob.new(@new_resource.name)
   if job_exists?(@new_resource.token, @new_resource.project, @new_resource.name)
      @current_resource.exists = true
   end
end
