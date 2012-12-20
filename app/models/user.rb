class User
  attr_accessor :id, :username, :password #, :avatar_url

  def initialize(attributes = {})
    self.id = attributes["id"].to_i
    self.username = attributes["username"]
    self.username = attributes["password"]
    #self.avatar_url = attributes.valueForKeyPath("avatar_image.url")
  end
end