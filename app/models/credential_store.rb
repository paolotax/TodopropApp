class CredentialStore

  attr_accessor :auth_token, :username, :password

  SERVICE_NAME   = "todopropa"
  AUTH_TOKEN_KEY = "auth_token"
  USERNAME_KEY   = "username"
  PASSWORD_KEY   = "password"

  def is_logged_in?
    !self.auth_token.nil?    
  end  

  def clear_saved_credentials
    self.auth_token = nil
  end
  
  def auth_token
    self.secureValueForKey AUTH_TOKEN_KEY
  end

  def auth_token=(auth_token)
    self.setSecureValue(auth_token, forKey:AUTH_TOKEN_KEY)
    #NSNotificationCenter.defaultCenter.postNotificationName('token-changed', object:self)
  end

  def username
    self.secureValueForKey USERNAME_KEY
  end

  def username=(username)
    self.setSecureValue(username, forKey:USERNAME_KEY)
  end

  def password
    self.secureValueForKey PASSWORD_KEY
  end

  def password=(password)
    self.setSecureValue(password, forKey:PASSWORD_KEY)
  end

  def setSecureValue(value, forKey:key)
    if (value) 
      SSKeychain.setPassword(value, forService:SERVICE_NAME, account:key)
    else
      SSKeychain.deletePasswordForService(SERVICE_NAME, account:key)
    end
  end    

  def secureValueForKey(key)
    return SSKeychain.passwordForService(SERVICE_NAME, account:key)
  end

end