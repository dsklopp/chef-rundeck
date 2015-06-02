actions :create, :delete, :update

default_action :create

attribute :name, :kind_of => String, :required => true
attribute :token, :kind_of => String, :required => true
attribute :project, :kind_of => String, :required => true
attribute :description, :kind_of => String, :required => true
attribute :scriptfile, :kind_of => String, :required => true
attribute :scriptargs, :kind_of => String, :required => true

#attr_accessor :exists
