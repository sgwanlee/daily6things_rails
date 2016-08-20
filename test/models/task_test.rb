require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @task_completed = Task.create!(name: "test", completed: true)
    @task_incompleted = Task.create!(name: "test", completed: false)
  end

  test 'should increase priority by 1' do
    priority = @task_incompleted.priority
    @task_incompleted.increase_priority.reload
    assert_equal @task_incompleted.priority, priority + 1
  end

  test 'should decrease priority by 1' do
    priority = @task_incompleted.priority
    @task_incompleted.decrease_priority.reload
    assert_equal @task_incompleted.priority, priority - 1
  end
end
