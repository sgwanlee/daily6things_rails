class DatesController < ApplicationController
  def index
    @incompleted_tasks = Task.uncompleted
    @completed_tasks = Task.completed
    # calendar
    serialization = ActiveModel::Serializer::TaskSerializer.new(Task.completed, {})
    @data = serialization.to_json
    debugger
  end

  def show
    @date = Time.zone.now.strftime("%Y-%m-%d")
    @task = Task.new
    @tasks = Task.uncompleted

    @incompleted_tasks = Task.uncompleted
    @today_completed_tasks = Task.created_today.completed
  end

end
