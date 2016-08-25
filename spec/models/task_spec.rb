require 'rails_helper'

RSpec.describe Task, type: :model do

  before(:each) do
    @task = create(:task)
  end

  it "increases priority by 1" do
    priority = @task.priority
    @task.increase_priority.reload
    expect(@task.priority).to eq(priority + 1)
  end

  it 'decreases priority by 1' do
    priority = @task.priority
    @task.decrease_priority.reload
    expect(@task.priority).to eq(if priority == 0 then 0 else priority - 1 end)
  end

  it 'provides tasks completed today' do
    @task_completed_1_day_ago = create(:task, created_at: 1.day.ago, completed_at: 1.day.ago)
    @task_completed_today = create(:task, completed_at: Time.zone.now)
    expect(Task.completed_today.count).to eq(1)
    expect(Task.completed_today.first).to eq(@task_completed_today)
  end
end
