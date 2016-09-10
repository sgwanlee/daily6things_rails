require 'rails_helper'

feature "create tasks" do
  before(:each) do
    @user = create(:user, password: "ABCDE123", password_confirmation: "ABCDE123")
  end
  scenario "it creates a new task", js: true do
    log_in_as(@user, password: "ABCDE123")

    fill_in "task[name]", with: "Task1"
    find('#task_input').native.send_keys(:return)
    expect(page).to have_content("Task1")
    visit date_path(1)
    expect(page).to have_content("Task1")
  end

  context "with 6 uncompleted tasks" do
    before(:each) do
      6.times { create(:task) }
    end
    scenario "it doesn't create a new task", js: true do
      log_in_as(@user, password: "ABCDE123")

      fill_in "task[name]", with: "Task1"
      find('#task_input').native.send_keys(:return)
      expect(page).to have_content("You've already got 6 tasks today")
      expect(page).to have_selector(".alert")
    end
  end
end