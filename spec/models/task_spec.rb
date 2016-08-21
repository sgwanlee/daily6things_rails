require 'rails_helper'

RSpec.describe Task, type: :model do

  before(:each) do
    @task = create(:task)
  end

  after(:each) do
    @task.destroy
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
end
