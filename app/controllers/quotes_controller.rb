class QuotesController < ApplicationController
  def index
    @quote = "Click the button to generate a quote."
  end

  def generate
    quotes = [
      "Believe you can and you're halfway there.",
      "The only way to do great work is to love what you do.",
      "Life is what happens when you're busy making other plans.",
      "Don't watch the clock; do what it does. Keep going.",
      "The best way to predict the future is to invent it."
    ]
    @quote = quotes.sample

    render partial: "quote", locals: { quote: @quote }
  end
end
