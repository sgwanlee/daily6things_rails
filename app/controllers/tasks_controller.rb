class TasksController < ApplicationController

  def create
    respond_to do |format|
      if Task.got_six_tasks?
        @task = Task.create!(task_params)
        @result = :success
        format.js
      else
        @result = :failed
        format.js
      end
    end
  end

  def update
    @task = Task.find(params[:id])
    @task.update_attributes!(task_params)
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
    params.require(:task).permit(:name, :complete)
  end
end
