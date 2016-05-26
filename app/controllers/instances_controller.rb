class InstancesController < ApplicationController
  before_action :set_instance, only: [:show, :update, :destroy]

  # GET /instances
  # GET /instances.json
  def usage
    #get all usage in the last 24h for all machines
    #@instances = Instance.all
    
    #render json: @instances
  end

  # POST /instances
  # POST /instances.json
  def create
    # add entry on DynDB
    #if @instance.save
    #  render json: @instance, status: :created, location: @instance
    #else
    #  render json: @instance.errors, status: :unprocessable_entity
    #end
  end
end
