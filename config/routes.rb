Rails.application.routes.draw do
  get 'instances/usage' => 'instances#usage'
  post 'instances/:id' => 'instances#create'
  post 'instances/:id/start' => 'instances#start'
  post 'instances/:id/stop' => 'instances#stop'
  get 'instances/:id/status' => 'instances#status'
  get 'instances/processes' => 'instances#processes'
  get 'instances/usage' => 'instances#usage_instance'
  get 'instances/processes' => 'instances#processes_instance'
end
