actions :create, :destroy
default_action :create

attribute :app, required: true, kind_of: String
attribute :port, required: true, kind_of: Integer
attribute :data_path, required: true, kind_of: String
attribute :war
