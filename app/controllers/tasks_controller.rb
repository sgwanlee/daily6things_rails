class TasksController < ApplicationController

  def create
    respond_to do |format|
      format.js {
        @uncompleted_tasks_count = Task.uncompleted.count
        if @uncompleted_tasks_count < 6
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
        @uncompleted_tasks_count = Task.uncompleted.count
      }
    end
  end

  def destroy
    @task = Task.destroy(params[:id])
    @uncomplted_tasks_count = Task.uncompleted.count
    respond_to do |format|
      format.js
    end
  end


  #increate priority
  def up
    @task = Task.find(params[:task_id])
    @task.increase_priority
    respond_to do |format|
      format.js
    end
  end

  #decreate priority
  def down
    @task = Task.find(params[:task_id])
    @task.decrease_priority
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
    params.require(:task).permit(:name, :complete, :priority, :completed_at)
  end
end
