class Model
  def initialize(id)
    @id = id
  end
  
  def ==(other)
    @id.to_s == other.id.to_s
  end
  
  attr_reader :id
  
  def self.property(name)
    klass = self.name.downcase
    self.class_eval <<-RUBY
      def #{name}
        _#{name}
      end
      
      def _#{name}
        redis.get("#{klass}:id:" + id.to_s + ":#{name}")
      end
      
      def #{name}=(val)
        redis.set("#{klass}:id:" + id.to_s + ":#{name}", val)
      end
    RUBY
  end
end  

class Message < Model
  def self.create(user, content)
    message_id = redis.incr("message:id")
    message = Message.new(message_id)
    message.content = content
    message.user = user
    #message.created_at = Time.now.to_s
    redis.push_head("messages", message_id)
  end
 
  def self.all
    redis.sort("messages", "DESC").map do |message_id|
      Message.new(message_id)
    end
  end

  property :content
  property :user
  #property :created_at

  #def created_at
  #  Time.parse(_created_at)
  #end
end









