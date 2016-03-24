Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Rewrite non-canonical requests to canonical host (also removes trailing slashes, thanks to Rails)
  if canonical_domain = Rails.configuration.x.canonical_domain.presence
    constraints(host: Regexp.new("^(?!#{Regexp.escape(canonical_domain)})")) do
      match :via => [:get, :post], "/(*path)" => redirect(host: canonical_domain)
    end
  end

  class TrailingSlashMatcher
    def matches?(request)
      uri = request.env["REQUEST_URI"].to_s
      uri != '/' && uri.end_with?("/")
    end
  end
  constraints(TrailingSlashMatcher.new) do
    match :via => [:get, :post], "/(*path)" => redirect { |params, req| params[:path].chomp('/') }
  end

  namespace :admin do
    get 'labels', to: 'labels#index'
    get 'labels/tote'
    get 'labels/tote/print', to: 'labels#tote_print'
    get 'labels/meal'
    get 'labels/ingredient'
    get 'labels/ingredient/print', to: 'labels#ingredient_print'

    get 'email/menu'
    get 'email/product'

    get 'raw_reports/outbound_shipments'
  end

  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  mount Spree::Core::Engine, :at => '/'

  # Load custom Spree routes
  Spree::Core::Engine.add_routes do
    namespace :account, module: :user do
      resource :meal_preference, path: "preferences", only: [:show, :create]
      resource :address, only: [:show, :create]
    end
  end

  # Fall back to static pages
  get '/:page', to: 'static_pages#show', as: 'static_page', constraints: lambda { |req|
      Rails.configuration.x.static_pages.include? req.path_parameters[:page]
  }

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
