class DatesController < ApplicationController
  def show
    @date = Time.zone.now.strftime("%Y-%m-%d")
    @task = Task.new
    @tasks = Task.today_and_uncompleted
  end
end
