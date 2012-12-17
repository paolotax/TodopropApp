class CredentialStore

  attr_accessor :auth_token

  SERVICE_NAME = "todopropa"
  AUTH_TOKEN_KEY = "auth_token"
  
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
    NSNotificationCenter.defaultCenter.postNotificationName('token-changed', object:self)
  end

  private 

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