Ccni::Application.routes.draw do
  root to: 'application#index'
  scope :session do
    match '/change_password' => 'session#change_password', via: [:get]
    match '/reset_password' => 'session#reset_password', via: [:post]
  end
  namespace :templates do
    namespace :loader do
      scope :uploaders do
        match '/data_grid_files' => 'uploaders#data_grid_files', via: [:get]
        match '/data_socket' => 'uploaders#data_socket', via: [:get]
      end
    end
    namespace :data_tables do
      scope :results do
        match '/data_grid_results' => 'results#data_grid_results', via: [:get]
        match '/data_grid_results_details' => 'results#data_grid_results_details', via: [:get]
        match '/data_grid_results_details_dda' => 'results#data_grid_results_details_dda', via: [:get]
      end
      scope :status do
        match '/widgets' => 'status#widgets', via: [:get]
        match '/ships' => 'status#ships', via: [:get]
      end
    end
  end
  namespace :api do
    namespace :v1 do
      resources :settings
      namespace :results do
        scope :empty_od do
          match '/empty_xlsx' => 'empty_od#empty_xlsx', via: [:get]
        end
        scope :week do
          match '/' => 'week#index', via: [:get]
          match '/list_week_leg' => 'week#list_week_leg', via: [:get]
          match '/list_vessel' => 'week#list_vessel', via: [:get]
          match '/list_services' => 'week#list_services', via: [:get]
          match '/list_voyage' => 'week#list_voyage', via: [:get]
          match '/list_origin' => 'week#list_origin', via: [:get]
          match '/list_destination' => 'week#list_destination', via: [:get]
          match '/list_month' => 'week#list_month', via: [:get]
          match '/search' => 'week#search', via: [:get]
        end
        scope :status do
          match '/list_services' => 'status#list_services', via: [:get]
          match '/containers' => 'status#containers', via: [:get]
          match '/' => 'status#status', via: [:get]
          match '/search' => 'status#search', via: [:get]
          match '/list_leg' => 'status#list_leg', via: [:get]
        end
        scope :demands do
          match '/unq_cap' => 'demands#unq_cap', via: [:get]
          match '/filter_travel' => 'demands#filter_travel', via: [:get]
          match '/filter_por_onu' => 'demands#filter_por_onu', via: [:get]
          match '/filter_pod_onu' => 'demands#filter_pod_onu', via: [:get]
          match '/search' => 'demands#search', via: [:get]
          match '/detail' => 'demands#detail', via: [:get]
          match '/dda' => 'demands#dda', via: [:get]
          match '/results' =>  'demands#results', via: [:get]
          match '/generate_xlsx' =>  'demands#generate_xlsx', via: [:get]
        end
        scope :stocks do
          match '/list_containers' => 'stocks#list_containers', via: [:get]
          match '/list_countries' => 'stocks#list_countries', via: [:get]
          match '/list_ports' => 'stocks#list_ports', via: [:get]
          match '/search' => 'stocks#search', via: [:get]
        end
      end
      namespace :process do
        scope :socket do
          match '/execute' => 'socket#execute', via: [:get]
          match '/ping' => 'socket#ping', via: [:get]
          match '/eo' => 'socket#eo', via: [:get]
          match '/vb' => 'socket#vb', via: [:get]
        end
        scope :empty_od do
          match '/status_xlsx' => 'empty_od#status_xlsx', via: [:get]
        end
        scope :iz_files do
          match '/' => 'iz_files#index', via: [:get]
          match '/reload_csv' => 'iz_files#reload_csv', via: [:get]
          match '/status' => 'iz_files#status', via: [:get]
          match '/read_log' => 'iz_files#read_log', via: [:get]
          match '/status_xlsx' => 'iz_files#status_xlsx', via: [:get]
        end
        scope :status do
          match '/' => 'status#index', via: [:get]
          match '/routes' => 'status#routes', via: [:get]
        end
      end
      namespace :maps do
         scope :ports do
           match '/' => 'ports#index', via: [:get]
           match '/teus' => 'ports#teus', via: [:get]
           match '/origin' => 'ports#origin', via: [:get]
         end
        scope :empty do
          match '/group_containers' => 'empty#group_containers', via: [:get]
          match '/coordinates' => 'empty#coordinates', via: [:get]
        end
      end
      namespace :loader do
        scope :uploaders do
           match '/list' => 'uploaders#list', via: [:get]
        end
        scope :itineraries do
          match '/travels' => 'itineraries#travels', via: [:get]
        end
        resources :itineraries
        scope :demands do
          match '/filter' => 'demands#filter', via: [:get]
          match '/unique' => 'demands#unique', via: [:get]
          match '/travels' => 'demands#travels', via: [:get]
          match '/get_viaje1_by_nave1' => 'demands#get_viaje1_by_nave1', via: [:get]
          match '/ports' => 'demands#ports', via: [:get]
          match '/status' => 'demands#status', via: [:get]
          match '/move' => 'demands#move', via: [:get]
        end
        resources :demands
        scope :cap_viajes do
          match '/unq_cap' => 'cap_viajes#unq_cap', via: [:get]
          match '/' => 'cap_viajes#index', via: [:get]
          match 'travels_by_ship' => 'cap_viajes#travels_by_ship', via: [:get]
          match 'routes_by_ship_travel' => 'cap_viajes#routes_by_ship_travel', via: [:get]
        end
      end
      namespace :attribute do
        scope :definitions_mtp do
          match '/get_top_25' => 'definitions_mtp#get_top_25', via: [:get]
        end
      end
      namespace :enterprise do
        scope :location_definitions_mtp do
          match '/get_ports' => 'location_definitions_mtp#get_ports', via: [:get]
        end
      end
      namespace :purchase do
        scope :activity_mtp do
          match '/get_top_10' => 'activity_mtp#get_top_10', via: [:get]
        end
        resources :origin_destination
      end
      namespace :inventory do
        resources :containers
      end
      namespace :conversion do
        scope :services do
          match '/route' => 'services#route', via: [:get]
        end
        resources :services
      end
      namespace :main do
        scope :iz_files do
          match '/list' => 'iz_files#list', via: [:get]
          match '/upload_csv' => 'iz_files#upload_csv', via: [:post]
        end
        resources :iz_files
        resources :users
        resources :roles
      end
    end
  end
  namespace :maps do
    scope :ships do
      match '/' => 'ships#index', via: [:get]
    end
  end
  namespace :backend do
    scope :results do
      match '/' => 'results#index', via: [:get]
      match '/demand' => 'results#demand', via: [:get]
      match '/empty' => 'results#empty', via: [:get]
      match '/loader_itinerary' => 'results#loader_itinerary', via: [:get]
      match '/loader_demand' => 'results#loader_demand', via: [:get]
      match '/loader_capacity' => 'results#loader_capacity', via: [:get]
      match '/loader_cost' => 'results#loader_cost', via: [:get]
      match '/loader_inventory_container' => 'results#loader_inventory_container', via: [:get]
      match '/iz_dda_final_detail' => 'results#iz_dda_final_detail', via: [:get]
    end
    scope :process do
      match '/' => 'process#index', via: [:get]
      match '/routes' => 'process#routes', via: [:get]
    end
    scope :setting do
      match '/' => 'setting#index', via: [:get]
      match '/icons' => 'setting#icons', via: [:get]
      match '/iframe' => 'setting#iframe', via: [:get]
    end
    namespace :charts do
      scope :stocks do
        match '/' => 'stocks#index', via: [:get]
        match '/list_containers' => 'stocks#list_containers', via: [:get]
      end
    end
    namespace :data_tables do
      scope :week do
        match '/' => 'week#index', via: [:get]
      end
      scope :status do
        match '/' => 'status#index', via: [:get]
      end
      scope :demands do
        match '/' => 'demands#index', via: [:get]
      end
      scope :results do
        match '/' => 'results#index', via: [:get]
      end
      scope :main do
        match '/one' => 'main#one', via: [:get]
        match '/two' => 'main#two', via: [:get]
        match '/three' => 'main#three', via: [:get]
        match '/loader' => 'main#loader', via: [:get]
      end
      resources :cap_viajes
    end
    namespace :dashboard do
      scope :legs do
        match '/analytics' => 'legs#analytics', via: [:get]
        match '/shipment' => 'legs#shipment', via: [:get]
      end
      scope :main do
        match '/' => 'main#index', via: [:get]
      end
      resources :legs
      resources :routes
    end
    namespace :main do
      resources :users
    end
    namespace :loader do
      resources :logger
      resources :admin
      scope :uploaders do
        match '/' => 'uploaders#index', via: [:get]
        match '/file' => 'uploaders#file', via: [:get]
        match '/log' => 'uploaders#log', via: [:get]
      end
      scope :downloads do
        match '/' => 'downloads#index', via: [:get]
      end
      scope :itineraries do
        match '/step_i' => 'itineraries#step_i', via: [:get]
        match '/step_ii' => 'itineraries#step_ii', via: [:post]
        match '/step_iii' => 'itineraries#step_iii', via: [:post]
      end
      scope :capabilities do
        match '/step_i' => 'capabilities#step_i', via: [:get]
        match '/step_ii' => 'capabilities#step_ii', via: [:post]
        match '/step_iii' => 'capabilities#step_iii', via: [:post]
      end
      scope :scripts do
        match '/' => 'scripts#index', via: [:get]
      end
    end
  end
  devise_for :rbo_users do
    get 'logout' => 'backend/main/users#destroy_session', :as => :logout
  end

end