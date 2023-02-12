require "rails_helper"

RSpec.describe SurveyProjectsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/survey_projects").to route_to("survey_projects#index")
    end

    it "routes to #new" do
      expect(get: "/survey_projects/new").to route_to("survey_projects#new")
    end

    it "routes to #show" do
      expect(get: "/survey_projects/1").to route_to("survey_projects#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/survey_projects/1/edit").to route_to("survey_projects#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/survey_projects").to route_to("survey_projects#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/survey_projects/1").to route_to("survey_projects#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/survey_projects/1").to route_to("survey_projects#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/survey_projects/1").to route_to("survey_projects#destroy", id: "1")
    end
  end
end
