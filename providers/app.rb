action :create do
  r = []

  new_resource.updated_by_last_action r.any?(&:updated_by_last_action?)
end
