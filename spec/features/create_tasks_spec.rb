require 'rails_helper'

feature "create tasks" do
  scenario "it creates a new task", js: true do
    visit root_path
    fill_in "task[name]", with: "Task1"
    find('#task_input').native.send_keys(:return)
    expect(page).to have_content("Task1")
    visit root_path
    expect(page).to have_content("Task1")
  end

  context "with 6 uncompleted tasks" do
    before(:each) do
      6.times { create(:task) }
    end
    scenario "it doesn't create a new task", js: true do
      visit root_path
      fill_in "task[name]", with: "Task1"
      find('#task_input').native.send_keys(:return)
      expect(page).to have_content("You've already got 6 tasks today")
      expect(page).to have_selector(".alert")
    end
  end
end