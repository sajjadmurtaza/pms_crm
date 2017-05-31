Rails.application.routes.draw do

  namespace :core do
    get 'ui/render_tab/:tab_key' => 'ui#render_tab', as: :ui_render_tab
    get 'workflow/:source_type/:source_id/validate_transition/:target_state' => 'workflow#validate_transition', as: :workflow_validate_transition
    get 'workflow/:source_type/:source_id/perform_action/:initial_state/:target_state/:action_name' => 'workflow#perform_action', as: :workflow_perform_action
    post 'workflow/:source_type/:source_id/perform_action_frontend/:action_name' => 'workflow#perform_action_frontend', as: :workflow_perform_action_frontend
    get 'workflow/:source_type/:source_id/make_transition/:initial_state/:target_state' => 'workflow#make_transition', as: :workflow_make_transition
  end

  scope module: 'core' do
    resources :skills
    resources :roles
    resources :comments do
      member do
        get :cancel
      end
    end
    resources :invoices
    resources :quotes
    get 'project_logs' => 'activity_logs#project_log'
    get 'lead_logs' => 'activity_logs#lead_log'
    get 'invoice_logs' => 'activity_logs#invoice_log'
  end

  scope module: 'workspace' do
    resources :calendars do
      member do
        get :share
      end
    end
    resources :events do
      collection do
        get :show_task
      end
    end
    resources :audits
    resources :calendar_entries
    resources :user_assignments
    get 'switch_task_completed' => 'user_assignments#switch_task_completed'
    get 'completed_tasks' => 'user_assignments#completed_tasks'

  end

  get 'logout' => 'sessions#destroy', :as => 'logout'
  get 'login' => 'sessions#new', :as => 'login'
  get 'enumerations/sort' => 'enumerations#sort'
  get '/dashboard/tab_content' => 'dashboard#tab_content'
  post '/update_task' => 'pms/projects#update_task'


  resources :sessions
  resources :enumerations do
    get :sort, on: :collection
    collection do
    end
  end

  scope module: 'directory' do
    resources :contacts
    resources :resources
    resources :users
    resources :accounts
  end

  scope module: 'crm' do
    resources :leads
    get '/quick_note/:note_type_id/:notable_id/:notable_type' => 'leads#quick_note', as: :quick_note
    post '/create_quick_note' => 'leads#create_quick_note', as: :create_quick_note
  end

  scope module: 'core' do
    resources :notes do
      collection do
        get :search
        get :tab_content
      end
      member do
        get :cancel
      end
    end
  end

  scope module: 'pms' do
    resources :projects
    resources :tasks
    resources :task_lists do
      collection do
        get :edit_task
        get :delete_task
        post :create_task
        post :update_task
        get :switch_task_completion
      end
      member do
        get :cancel
        get :add_task
      end

    end
  end

  namespace :admin do
    get 'settings', action: 'edit', controller: 'settings', :as => :settings
    post 'settings', action: 'update', controller: 'settings'
    resources :note_types do
      member do
        get :make_default
      end
    end
    resources :custom_fields
    resources :organization_units
  end

  root :to => 'workspace/calendars#index'

  #------------------------------API Routes----------------------------------------
  scope module: 'api' do
    scope module: 'crm' do
      post 'api/leads' => 'leads#create'
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
