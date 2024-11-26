Rails.application.routes.draw do
  root "quotes#index"
  post "generate_quote", to: "quotes#generate", as: :generate_quote
end
