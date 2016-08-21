require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe "Post create" do
    context "uncompleted tasks < 6" do
      it "creates new task" do
        expect(Task.uncompleted.count).to be < 6
        expect{
          xhr :post, :create, task: { name: "new_task"}
        }.to change(Task, :count).by(1)
        expect(response.code).to eq("200")
      end
    end
    context "uncompleted tasks >= 6" do
      before(:each) do
        @tasks = create_list(:task, 6)
      end
      after(:each) do
        @tasks.each {|task| task.destroy}
      end
      it "genereates error message" do
        expect(Task.uncompleted.count).to eq(6)
        expect{
          xhr :post, :create, task: { name: "new_task"}
        }.not_to change(Task, :count)
        expect(response.code).to eq("200")
      end
    end
  end
  describe "Post up/down" do
    context "priority > 0" do
      before(:each) do
        @task = create(:task, priority: 1)
      end
      it "decreases priority" do
      expect{
          xhr :post, :down, task_id: @task.id
        }.to change{@task.reload.priority}.by(-1)
      end
      it "increases priority" do
      expect{
          xhr :post, :up, task_id: @task.id
        }.to change{@task.reload.priority}.by(1)
      end
    end
    context "priority = 0" do
      before(:each) do
        @task = create(:task, priority: 0)
      end
      it "doesn't decrease priority" do
      expect{
          xhr :post, :down, task_id: @task.id
        }.not_to change{@task.reload.priority}
      end
    end
  end
end
