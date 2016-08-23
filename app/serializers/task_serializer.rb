class TaskSerializer < ActiveModel::Serializer
  attributes :completed_at
  def completed_at 
    {self: object.completed_at.strftime("%Y-%m-%d")}
  end
end