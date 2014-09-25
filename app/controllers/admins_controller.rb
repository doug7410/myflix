class AdminsController < ApplicationController
  before_filter :require_user
  before_filter :ensure_admin
end