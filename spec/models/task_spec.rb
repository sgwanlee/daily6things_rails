require 'rails_helper'

RSpec.describe Task, type: :model do

  before(:each) do
    @task = create(:task, complete: false)
    @user = @task.user
  end

  it "increases priority by 1" do
    @task = create(:task, complete: false)
    @user = @task.user
    priority = @task.priority
    @task.increase_priority.reload
    expect(@task.priority).to eq(priority + 1)
  end

  it 'decreases priority by 1' do
    @task = create(:task, complete: false)
    @user = @task.user
    priority = @task.priority
    @task.decrease_priority.reload
    expect(@task.priority).to eq(if priority == 0 then 0 else priority - 1 end)
  end

  it 'provides tasks completed today' do
    @task = create(:task, complete: false)
    @user = @task.user
    @task_completed_1_day_ago = create(:task, created_at: 1.day.ago, completed_at: 1.day.ago)
    @task_completed_today = create(:task, completed_at: Time.zone.now)
    expect(Task.completed_today.count).to eq(1)
    expect(Task.completed_today.first).to eq(@task_completed_today)
  end

  context "with 6 uncompleted tasks" do
    context "changing completed task into uncompleted" do
      it "is not valid " do
        @task = create(:task, complete: false)
        @user = @task.user
        @task.complete = true
        @task.save
        6.times { create(:task, user_id: @user.id)}
        @task.complete = false
        @task.valid?
        expect(@task.errors[:task_limit]).to include("already 6 tasks")
      end
    end
    context "changing priority" do
      it "increases priority by 1" do
        @task = create(:task, complete: false)
        @user = @task.user
        5.times { create(:task, user_id: @user.id) }
        priority = @task.priority
        @task.increase_priority.reload
        expect(@task.priority).to eq(priority + 1)
      end
      it 'decreases priority by 1' do
        @task = create(:task, complete: false)
        @user = @task.user
        5.times { create(:task, user_id: @user.id) }
        priority = @task.priority
        @task.decrease_priority.reload
        expect(@task.priority).to eq(if priority == 0 then 0 else priority - 1 end)
      end
    end
  end

  context "with less than 6 uncompleted tasks" do
    context "changing completed task into uncompleted" do
      it "is valid " do
        @task = create(:task, complete: false)
        @user = @task.user
        @task.complete = true
        @task.save
        @task.complete = false
        expect(@task).to be_valid
      end
    end
    context "with 6 uncompleted tasks including other user's tasks" do
      context "adding new task" do
        it "is valid" do
          @task = create(:task, complete: false)
          @user = @task.user
          @other_user = create(:user)
          4.times { create(:task, user_id: @user.id) }
          @other_user_task = create(:task, user_id: @other_user.id)
          expect(@user.tasks.uncompleted.count).to eq(5)
          task = build(:task, user_id: @user.id)
          expect(task).to be_valid
        end
      end
    end
  end
end
