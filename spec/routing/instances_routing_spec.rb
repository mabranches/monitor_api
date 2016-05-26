require "rails_helper"

RSpec.describe InstancesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/instances").to route_to("instances#index")
    end

    it "routes to #new" do
      expect(:get => "/instances/new").to route_to("instances#new")
    end

    it "routes to #show" do
      expect(:get => "/instances/1").to route_to("instances#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/instances/1/edit").to route_to("instances#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/instances").to route_to("instances#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/instances/1").to route_to("instances#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/instances/1").to route_to("instances#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/instances/1").to route_to("instances#destroy", :id => "1")
    end

  end
end
