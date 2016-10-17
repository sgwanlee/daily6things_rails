require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  before(:each) do
    @user = create(:user)
    log_in_as(@user)
  end
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
        6.times { create(:task, user_id: @user.id)}
      end
      it "genereates error message" do
        expect(@user.tasks.uncompleted.count).to eq(6)
        expect{
          xhr :post, :create, task: { name: "new_task", user_id: @user.id}
        }.not_to change(Task, :count)
        expect(response.code).to eq("200")
      end
    end
  end
  describe "Post replace" do
    context "4th to 1st" do
      it "changes priorities of uncompleted tasks" do
      end
    end
    context "1st to 4th" do
      it "changes priorities of uncompleted tasks" do
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
