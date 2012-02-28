class User
  attr_accessor :name, :username, :password_digest

  def initialize(attributes={})
    attributes.each do |key, value|
      send "#{key}=", value 
    end
  end


end
