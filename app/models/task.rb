class Task < ActiveRecord::Base
  
  def self.today_and_uncompleted
    t = Task.arel_table
    #1. created at today & completed
    #2. created at before today & uncompleted
    Task.where(t[:created_at].in(Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).and(t[:complete].eq(true)).or(t[:complete].eq(false))).order(complete: :asc, priority: :desc)
  end

  def self.got_six_tasks?
    self.today_and_uncompleted.count < 6
  end

  def increase_priority
    self.update_attributes!(priority: self.priority + 1)
  end

  def decrease_priority
    new_priority = if self.priority == 0 then 0 else self.priority - 1 end
    self.update_attributes!(priority: new_priority)
  end
end