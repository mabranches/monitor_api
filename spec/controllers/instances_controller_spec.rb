require 'rails_helper'

RSpec.describe InstancesController, type: :controller do

  let(:valid_attributes) {
    {
       "id" => 'test_id',
      "instance_id"=>"test_id",
      "disk"=>"51",
      "mem"=>"9",
      "cpu"=>"1",
      "process"=>{"user"=>"root", "pid"=>"1", "cpu"=>"0.0", "mem"=>"0.0", "command"=>"/sbin/init"}
    }
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }

  describe "GET #usage" do
    it "should return all usage from last 24h" do
     # instance = Instance.create! valid_attributes
     # get :usage, {}, valid_session
     # expect(assigns(:instances)).to eq([instance])
    end
  end

  describe "get #processes" do
    it "should return all processes" do
    end
  end
  describe "get #status" do
    it "should return the machine status" do
    end
  end

  describe "get #report" do
    it "should return a report" do
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new usage" do
        expect {
          post :create, {:id => "test_id", :instance => valid_attributes}, valid_session
          #post :create,  valid_attributes, valid_session
        }.to change(Usage, :count).by(1)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved instance as @instance" do
        #post :create, {:instance => invalid_attributes}, valid_session
        #expect(assigns(:instance)).to be_a_new(Instance)
      end

    end
  end

  describe "POST #stop" do
  end

  describe "POST #start" do
  end
end
