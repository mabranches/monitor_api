require 'rails_helper'

RSpec.describe InstancesController, type: :controller do
  before(:all) do
  end
  let(:valid_attributes) {
    {
       "id" => 'test_id',
      "disk"=> 51,
      "mem"=> 9,
      "cpu"=> 1,
      "process"=>{"user"=>"root", "pid"=>1, "cpu"=>0.0, "mem"=>0.0, "command"=>"/sbin/init"}
    }
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }
  before do
    @now = Time.parse("2016-05-01T:23:00:00Z")
    allow(Time).to receive(:now){@now}
    @date = Time.parse("2016-05-01T:20:23:32Z")

    usages = []
    usage = {"disk"=> 51, "mem"=> 9, "cpu"=> 1}

    usage["instance_id"] = "test_id"
    (1..3).each do
      new_usage = usage.dup
      new_usage["usage_time"] = @date.iso8601
      @date += 10.minutes
      usage["disk"] += 5
      usages << new_usage
    end

    usage["instance_id"] = "test_id2"
    (1..3).each do
      new_usage = usage.dup
      new_usage["usage_time"] = @date.iso8601
      @date += 10.minutes
      usage["cpu"] += 5
      usages << new_usage
    end

    processes = [
      {:instance_id=>"test_id", :process=>["root", "1", "0.0", "0.0", "command1"]},
      {:instance_id=>"test_id2", :process=>["root", "1", "0.0", "0.0", "command2"]}
    ]
    DynSpecData.create_usage_data(usages)
    DynSpecData.create_process_data(processes)
  end

  describe "GET #usage_instance" do
    it "should return all usage of an instance" do
      get :usage_instance, {:id => 'test_id'}, valid_session
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq(
        {"test_id"=>{"mem"=>["9.0", "9.0", "9.0"],
          "disk"=>["51.0", "56.0", "61.0"],
          "cpu"=>["1.0", "1.0", "1.0"],
          "usage_time"=>["2016-05-01T20:23:32Z", "2016-05-01T20:33:32Z", "2016-05-01T20:43:32Z"]}
        })

    end
  end


  describe "GET #usage" do
    it "should return all usage from last 24h" do
      get :usage, {}, valid_session
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq(
         {"test_id2"=>{
            "mem"=>["9.0", "9.0", "9.0"],
            "disk"=>["66.0", "66.0", "66.0"],
            "cpu"=>["1.0", "6.0", "11.0"],
            "usage_time"=>["2016-05-01T20:53:32Z", "2016-05-01T21:03:32Z", "2016-05-01T21:13:32Z"]},
          "test_id"=>{"mem"=>["9.0", "9.0", "9.0"],
            "disk"=>["51.0", "56.0", "61.0"],
            "cpu"=>["1.0", "1.0", "1.0"],
            "usage_time"=>["2016-05-01T20:23:32Z", "2016-05-01T20:33:32Z", "2016-05-01T20:43:32Z"]}
         })
    end
  end

  describe "get #:instance/processes" do
    it "should return all processes for an instance" do
      get :processes_instance, {:id => 'test_id'}, valid_session
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq(
        {"test_id"=>{"process"=>["root", "1", "0.0", "0.0", "command1"], "instance_id"=>"test_id"}}
      )
    end
  end
  describe "get #processes" do
    it "should return all processes" do
      get :processes, {}, valid_session
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq({
        "test_id2"=>{"process"=>["root", "1", "0.0", "0.0", "command2"], "instance_id"=>"test_id2"},
        "test_id"=>{"process"=>["root", "1", "0.0", "0.0", "command1"], "instance_id"=>"test_id"}
      })
    end
  end
  describe "get #status" do
    before do
      @ec2 = double('ec2')
      allow(@ec2).to receive_message_chain(:instance, :state, :name) {"state"}

      allow(Aws::EC2::Resource).to receive(:new){@ec2}
    end

    it "should return the machine status" do
      get :status, {id:'instance_id'}, valid_session
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['status']).to eq("state")

    end
    it "In case of an exception the status should be 'unknow'" do
      allow(@ec2).to receive_message_chain(:instance, :state, :name) {raise "some error"}
      get :status, {id:'instance_id'}, valid_session
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['status']).to eq("unknown")
    end
    it "In case of an exception a error should be written in log " do
      allow(@ec2).to receive_message_chain(:instance, :state, :name) {raise "some error"}
      logger = double('logger')
      expect(logger).to receive(:error).once
      allow(Rails).to receive(:logger){logger}

      get :status, {id:'instance_id'}, valid_session

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
          post :create, {:id => "test_id_post", :instance => valid_attributes}, valid_session
        }.to change(Usage, :count).by(1)
      end
      it "creates a new process list" do
        expect {
          post :create, {:id => "test_id_post", :instance => valid_attributes}, valid_session
        }.to change(ProcessList, :count).by(1)
      end
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
          post :create, {:id => "test_id_post", :instance => valid_attributes}, valid_session
        }.to change(Usage, :count).by(1)
      end
      it "creates a new process list" do
        expect {
          post :create, {:id => "test_id_post", :instance => valid_attributes}, valid_session
        }.to change(ProcessList, :count).by(1)
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
