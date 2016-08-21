class DatesController < ApplicationController
  def show
    @date = Time.zone.now.strftime("%Y-%m-%d")
    @task = Task.new
    @tasks = Task.uncompleted

    @incompleted_tasks = Task.uncompleted
    @today_completed_tasks = Task.created_today.completed
  end
end
