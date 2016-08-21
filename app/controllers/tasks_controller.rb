class TasksController < ApplicationController

  def create
    respond_to do |format|
      format.js {
        if Task.uncompleted.count < 6
          @task = Task.create!(task_params)
          @result = :success
        else
          @result = :failed
        end
      }
    end
  end

  def update
    @task = Task.find(params[:id])
    @task.update_attributes!(task_params)
    if @task.reload.complete == true
      @task.completed_at = Time.zone.now
    else
      @task.completed_at = nil
    end
    @task.save

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @task = Task.destroy(params[:id])
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

  private
  def task_params
    params.require(:task).permit(:name, :complete, :priority, :completed_at)
  end
end
