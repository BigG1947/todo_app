Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'welcome#index'

  resources :todo_lists, except: :new do
    resources :tasks, shallow: true, except: %i[index new show]
  end
end
