require "rails_helper"

RSpec.describe SurveyTokensController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/survey_tokens").to route_to("survey_tokens#index")
    end

    it "routes to #new" do
      expect(get: "/survey_tokens/new").to route_to("survey_tokens#new")
    end

    it "routes to #show" do
      expect(get: "/survey_tokens/1").to route_to("survey_tokens#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/survey_tokens/1/edit").to route_to("survey_tokens#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/survey_tokens").to route_to("survey_tokens#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/survey_tokens/1").to route_to("survey_tokens#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/survey_tokens/1").to route_to("survey_tokens#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/survey_tokens/1").to route_to("survey_tokens#destroy", id: "1")
    end
  end
end
