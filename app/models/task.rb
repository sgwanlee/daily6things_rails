class Task < ActiveRecord::Base
  scope :uncompleted, -> { where(complete: false).order(priority: :desc)}
  scope :completed, -> {where(complete: true).order(completed_at: :desc)}
  scope :completed_today, -> {where(completed_at: (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)).order(priority: :desc)}
  validate :uncompleted_tasks_should_less_than_6

  def self.created_today_or_uncompleted
    t = Task.arel_table
    Task.where(t[:created_at].in(Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).and(t[:complete].eq(true)).or(t[:complete].eq(false))).order(complete: :asc, priority: :desc)
  end

  def increase_priority
    self.priority = priority + 1
    self.save
    self
  end

  def decrease_priority
    new_priority = if self.priority == 0 then 0 else self.priority - 1 end
    self.priority = new_priority
    self.save
    self
  end

  def set_priority_from_index(index)
    tasks = Task.uncompleted
    tasks.each_with_index do |task, i|
      if task == self
        next
      end

      if i == index
        self.priority = task.priority + 1
        self.save
      elsif i < index
        task.priority += 1
        task.save
      else
        task.priority -= 1
        task.save
      end
    end
  end

  def completed?
    self.complete == true
  end

  private

  def uncompleted_tasks_should_less_than_6
    if self.new_record?
      if not Task.uncompleted.count <= 6
        errors.add(:task_limit, "already 6 tasks")
        false
      end
    else
      if not self.completed?
        if not Task.uncompleted.pluck(:id).include?(self.id)
          if not Task.uncompleted.count < 6
            errors.add(:task_limit, "already 6 tasks")
            false
          end
        end
      end
    end
  end
end