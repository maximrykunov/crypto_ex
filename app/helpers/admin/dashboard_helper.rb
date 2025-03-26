module Admin::DashboardHelper
  def status_badge(status)
    st = case status
    when "completed" then "bg-success"
    when "cancelled" then "bg-danger"
    when "pending" then "bg-info"
    end
    content_tag(:span, status, class: "badge #{ st }")
  end
end
