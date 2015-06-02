actions :create, :delete, :update

default_action :create

attribute :name, :kind_of => String, :required => true
attribute :config, :kind_of => Hash, :required => false
attribute :token, :kind_of => String, :required => true

#attr_accessor :exists
