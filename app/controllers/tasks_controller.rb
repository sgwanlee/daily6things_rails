class TasksController < ApplicationController
  before_action :change_complete_params, only: [:update]
  before_action :require_login

  def create
    respond_to do |format|
      format.js {
        @uncompleted_tasks_count = current_user.tasks.uncompleted.count
        if @uncompleted_tasks_count < 6
          task_params["priority"] = current_user.tasks.uncompleted.map(&:priority).min
          @task = Task.create!(task_params)
          @uncompleted_tasks_count += 1
          @result = :success
        else
          @result = :failed
          flash[:danger] = "You've already got 6 tasks today"
        end
      }
    end
  end

  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      format.js {
        if @task.update_attributes(task_params)
          if @task.reload.complete == true
            @task.completed_at = Time.zone.now
          else
            @task.completed_at = nil
          end
          @task.save
          @result = :success
        else
          @result = :fail
          flash[:danger] = "You've already got 6 tasks today"
        end
        @uncompleted_tasks_count = current_user.tasks.uncompleted.count
      }
    end
  end

  def destroy
    @task = Task.destroy(params[:id])
    @uncomplted_tasks_count = current_user.tasks.uncompleted.count
    respond_to do |format|
      format.js
    end
  end

  def replace
    @task = Task.find(params[:task_id])
    @task.set_priority_from_index(params[:index].to_i)
    respond_to do |format|
      format.js
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :complete, :priority, :completed_at, :user_id)
  end

  def change_complete_params
    key = params[:task].keys.find { |e| /^complete.*/ =~ e}
    val = params[:task][key]
    params[:task].delete(key)
    params[:task][:complete] = val
  end
end
