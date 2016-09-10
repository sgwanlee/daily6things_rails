require 'rails_helper'

feature "update tasks" do
  before(:each) do
    @user = create(:user, password: "ABCDE123", password_confirmation: "ABCDE123")
    5.times { create(:task, user: @user)}
    @task = create(:task, name: "Task1", user: @user)
  end
  context "tring to complete a task" do
    scenario "it completes a task", js: true do
      log_in_as(@user, password: "ABCDE123")

      find(:css, "form#edit_task_#{@task.id} input#task_complete-#{@task.id}").set(true)
      within("#today-completed-tasks") do
        expect(page).to have_content("Task1")
      end
      visit date_path(1)
      within("#today-completed-tasks") do
        expect(page).to have_content("Task1")
      end
    end
  end
  
  context "trying to undo a completed task" do
    scenario "it move a task back to to-do list", js: true do
      @task.complete = true
      @task.completed_at = Time.now
      @task.save
      
      log_in_as(@user, password: "ABCDE123")

      find(:css, "form#edit_task_#{@task.id} input#task_complete-#{@task.id}").set(false)
      within("#incompleted-tasks") do
        expect(page).to have_content("Task1")
        # expect(find("form#edit_task_#{@task.id}")).to have_content("Task1")
      end
    end

    scenario "it generates error when has already 6 uncompleted tasks", js: true do
      @task.complete = true
      @task.completed_at = Time.now
      @task.save
      create(:task, user: @user)

      log_in_as(@user, password: "ABCDE123")

      find(:css, "form#edit_task_#{@task.id} input#task_complete-#{@task.id}").set(false)

      expect(page).to have_content("You've already got 6 tasks today")
      expect(page).to have_selector(".alert")
    end
  end
end