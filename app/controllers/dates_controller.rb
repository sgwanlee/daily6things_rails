class DatesController < ApplicationController
  def index
    @incompleted_tasks = Task.uncompleted
    @completed_tasks = Task.completed
    # calendar
    @data = ActiveModel::ArraySerializer.new(Task.completed, each_serializer: TaskSerializer).to_json
  end

  def show
    @date = l(Time.zone.now, format: "%-m월%e일(%A)")
    @task = Task.new
    @tasks = Task.uncompleted

    @incompleted_tasks = Task.uncompleted
    @tasks_completed_today = Task.completed_today
  end

end
