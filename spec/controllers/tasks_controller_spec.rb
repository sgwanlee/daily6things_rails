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

  describe "Patch update" do
    context "incompleted tasks < 6" do
      context "update completed" do
        before(:each) do
          @task = create(:task)
        end
        it "changes complete" do
          expect{
            xhr :patch, :update, id: @task.id, task: { complete: 1}
          }.to change{@task.reload.complete}.from(false).to(true)
        end
        it "changes completed_at" do
          expect{
            xhr :patch, :update, id: @task.id, task: { complete: 1}
          }.to change{@task.reload.completed_at}.from(nil).to(Time)
        end
      end
      context "update incompleted" do
        before(:each) do
          @task = create(:task, complete: true, completed_at: Time.zone.now)
        end
        it "changes complete" do
          expect{
            xhr :patch, :update, id: @task.id, task: { complete: 0}
          }.to change{@task.reload.complete}.from(true).to(false)
        end
        it "changes completed_at" do
          expect{
            xhr :patch, :update, id: @task.id, task: { complete: 0}
          }.to change{@task.reload.completed_at}.to(nil)
        end
      end
    end
    context "incompleted tasks == 6" do
      before(:each) do
          @task = create(:task, complete: true, completed_at: Time.zone.now)
          6.times do 
            task = create(:task)
          end
        end
      context "update incompleted" do
        it "does not change .complete" do
          expect{
            xhr :patch, :update, id: @task.id, task: { complete: 0}
          }.not_to change{Task.uncompleted.count}
        end
        it "does not change .completed_at" do
          expect{
            xhr :patch, :update, id: @task.id, task: { complete: 0}
          }.not_to change{@task.reload.completed_at}
        end
      end
      context "update completed" do
        before(:each) do
          @task = Task.uncompleted.first
        end
        it "changes complete" do
          expect{
            xhr :patch, :update, id: @task.id, task: { complete: 1}
          }.to change{@task.reload.complete}.from(false).to(true)
        end
        it "changes completed_at" do
          expect{
            xhr :patch, :update, id: @task.id, task: { complete: 1}
          }.to change{@task.reload.completed_at}.from(nil).to(Time)
        end
      end
    end
  end
end
