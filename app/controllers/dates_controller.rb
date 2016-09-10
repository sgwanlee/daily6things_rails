class DatesController < ApplicationController
  before_action :require_login

  def index
    @incompleted_tasks = Task.uncompleted
    @completed_tasks = Task.completed
    # calendar
    @data = ActiveModel::ArraySerializer.new(Task.completed, each_serializer: TaskSerializer).to_json
  end

  def show
    @date = l(Time.zone.now, format: "%-m월%e일(%A)")
    @task = current_user.tasks.new
    @tasks = current_user.tasks.uncompleted

    @incompleted_tasks = current_user.tasks.uncompleted
    @tasks_completed_today = current_user.tasks.completed_today
  end
end
