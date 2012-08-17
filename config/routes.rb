Rails.application.routes.draw do
  namespace :certify do
    resources :authorities

    scope "authorities/:certify_authority_id" do
      resources :certificates
      scope "certificates" do
        match ":id/download" => "certificates#download", :as => :certificate_download
      end

      resources :key_pairs
      scope "key_pairs" do
        match ":id/download" => "key_pairs#download", :as => :key_pairs_download
      end

    end
  end
end
