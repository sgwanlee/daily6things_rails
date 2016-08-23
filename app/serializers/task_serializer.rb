class TaskSerializer < ActiveModel::Serializer
  def Date 
    object.completed_at.strftime("%Y-%m-%d")
  end
  attributes :Date
end