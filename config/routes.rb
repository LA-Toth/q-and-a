Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root 'title#index'

  get 'question', to: 'question#index'

  get 'question_state', to: 'question_state#index'
  get 'question_state/first_topic'
  get 'question_state/next_topic'
  get 'question_state/next_topic_question'
  get 'question_state/next_question'
end
