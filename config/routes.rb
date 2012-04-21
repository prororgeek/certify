Certify::Engine.routes.draw do

  resources :authorities

  scope "authorities/:certify_authority_id" do
    resources :certificates
  end

  root :to => "authorities#index"
end
