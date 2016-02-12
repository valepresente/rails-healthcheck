Healthcheck::Engine.routes.draw do
  root to: "healthcheck#index"
  get '/status.svg', to: 'healthcheck#graph', format: 'svg'
end
