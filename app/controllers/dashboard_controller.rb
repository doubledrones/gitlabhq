class DashboardController < ApplicationController
  respond_to :js, :html

  def index
    @projects = current_user.projects.all
    @active_projects = @projects.select(&:last_activity_date).sort_by(&:last_activity_date).reverse

    respond_to do |format|
      format.html
      format.js { no_cache_headers }
    end
  end

  # Get authored or assigned open merge requests
  def merge_requests
    @projects = current_user.projects.all
    @merge_requests = MergeRequest.where("author_id = :id or assignee_id = :id", :id => current_user.id).opened.order("created_at DESC").limit(40)

    respond_to do |format|
      format.html
      format.js { no_cache_headers }
    end
  end

  # Get only assigned issues
  def issues
    @projects = current_user.projects.all
    @user   = current_user
    @issues = current_user.assigned_issues.opened.order("created_at DESC").limit(40)

    @issues = @issues.includes(:author, :project)

    respond_to do |format|
      format.html
      format.js { no_cache_headers }
      format.atom { render :layout => false }
    end
  end
end
