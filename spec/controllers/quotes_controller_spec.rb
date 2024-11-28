require 'rails_helper'

RSpec.describe QuotesController, type: :controller do
  describe "GET #index" do
    it "assigns the default quote and renders the index template" do
      get :index
      expect(assigns(:quote)).to eq("Click the button to generate a quote.")
      expect(response).to render_template(:index)
    end
  end

  describe "POST #generate" do
    it "assigns a random quote and renders the quote partial" do
      post :generate, xhr: true
      expect(assigns(:quote)).to be_present
      expect(response).to render_template(partial: "_quote")
    end
  end
end
