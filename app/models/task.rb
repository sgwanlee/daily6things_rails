class Task < ActiveRecord::Base
  scope :uncompleted, -> { where(complete: false).order(priority: :desc)}
  scope :completed, -> {where(complete: true).order(completed_at: :desc)}
  scope :created_today, -> {where(created_at: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).order(priority: :desc)}

  def self.created_today_or_uncompleted
    t = Task.arel_table
    Task.where(t[:created_at].in(Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).and(t[:complete].eq(true)).or(t[:complete].eq(false))).order(complete: :asc, priority: :desc)
  end

  def increase_priority
    self.update_attributes!(priority: self.priority + 1)
    self
  end

  def decrease_priority
    new_priority = if self.priority == 0 then 0 else self.priority - 1 end
    self.update_attributes!(priority: new_priority)
    self
  end
end