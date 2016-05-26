require 'rails_helper'

RSpec.describe InstancesController, type: :controller do

  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }

  describe "GET #usage" do
    it "assigns all instances as @instances" do
      instance = Instance.create! valid_attributes
      get :usage, {}, valid_session
      expect(assigns(:instances)).to eq([instance])
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Instance" do
        expect {
          post :create, {:instance => valid_attributes}, valid_session
        }.to change(Instance, :count).by(1)
      end

      it "assigns a newly created instance as @instance" do
        post :create, {:instance => valid_attributes}, valid_session
        expect(assigns(:instance)).to be_a(Instance)
        expect(assigns(:instance)).to be_persisted
      end

      it "redirects to the created instance" do
        post :create, {:instance => valid_attributes}, valid_session
        expect(response).to redirect_to(Instance.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved instance as @instance" do
        post :create, {:instance => invalid_attributes}, valid_session
        expect(assigns(:instance)).to be_a_new(Instance)
      end

      it "re-renders the 'new' template" do
        post :create, {:instance => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end
end
