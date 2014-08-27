class RelationshipsController < ApplicationController
  before_action :require_user
  def index
    @relationships = current_user.following_relationships
  end

  def destroy
    relationship = Relationship.find(params[:id])
    
    if relationship.follower == current_user
      flash[:success] = "You are no longer following #{relationship.leader.full_name}"
      relationship.destroy
    end

    redirect_to people_path
  end

  def create
      leader = User.find(params[:id])     
      Relationship.create(follower: current_user, leader_id: params[:id]) unless current_user.follows?(leader) || current_user == leader

    redirect_to people_path
  end
end