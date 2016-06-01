require "rails_helper"

RSpec.describe InstancesController, type: :routing do
  describe "routing" do

    it "routes to #usage" do
      expect(:get => "/instances/usage").to route_to("instances#usage")
    end

    it "routes to #processes" do
      expect(:get => "/instances/processes").to route_to("instances#processes")
    end

    it "routes to #status" do
      expect(:get => "/instances/instance_id/status").to route_to("instances#status", :id => "instance_id")
    end

    it "routes to #create" do
      expect(:post => "/instances/instance_id").to route_to("instances#create", :id => "instance_id")
    end

    it "routes to #start" do
      expect(:post => "/instances/instance_id/start").to route_to("instances#start", :id => "instance_id")
    end

    it "routes to #stop" do
      expect(:post => "/instances/instance_id/stop").to route_to("instances#stop", :id => "instance_id")
    end

  end
end
