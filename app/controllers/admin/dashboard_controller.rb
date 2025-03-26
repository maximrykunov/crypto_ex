class Admin::DashboardController < ApplicationController
  before_action :has_admin_role?

  def show
    @orders = Order.includes(:user)
    @completed_orders = Order.completed.count
    @all_orders = Order.count
    @completed_orders_fee = Order.completed.sum(:fee)
  end

  private

  def has_admin_role?
    redirect_to root_path unless current_user.admin?
  end
end
