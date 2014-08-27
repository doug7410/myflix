class RelationshipsController < ApplicationController
  before_action :require_user
  def index
    @relationships = Relationship.where(follower: current_user)
  end

  def destroy
    relationship = Relationship.find(params[:id])
    
    if relationship.follower == current_user
      flash[:success] = "You are no longer following #{relationship.leader.full_name}"
      relationship.destroy
    end

    redirect_to people_path
  end
end