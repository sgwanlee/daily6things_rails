class DatesController < ApplicationController
  def index
    @incompleted_tasks = Task.uncompleted
    @completed_tasks = Task.completed
    # calendar
    @data = ActiveModel::ArraySerializer.new(Task.completed, each_serializer: TaskSerializer).to_json
  end

  def show
    @date = Time.zone.now.strftime("%Y-%m-%d")
    @task = Task.new
    @tasks = Task.uncompleted

    @incompleted_tasks = Task.uncompleted
    @today_completed_tasks = Task.created_today.completed
  end

end
