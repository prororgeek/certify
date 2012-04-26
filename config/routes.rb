Rails.application.routes.draw do
  namespace :certify do
    resources :authorities

    scope "authorities/:certify_authority_id" do
      resources :certificates
    end
  end
end
