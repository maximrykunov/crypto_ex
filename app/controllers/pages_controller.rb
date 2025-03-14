class PagesController < ApplicationController
  allow_unauthenticated_access

  def index
    p current_user
  end
end