class AuthApiClient < AFHTTPClient

  @@instance = nil
  BASE_URL = "http://todopropa.com"

  def init
    AFMotion::Client.build_shared(BASE_URL) do
      header "Accept", "application/json"
      operation :json
    end
  end
  
  def self.shared_client
    return @@instance unless @@instance.nil?
    @@instance =  AuthApiClient.alloc.initWithBaseURL(NSURL.URLWithString(BASE_URL))
    @@instance.registerHTTPOperationClass(AFJSONRequestOperation)
    @@instance.setDefaultHeader("Accept", value:"application/json")
    @@instance
  end

  def set_auth_token_header
    store = CredentialStore.alloc.init
    auth_token = store.auth_token
    self.setDefaultHeader("Authorization", value:"Bearer #{auth_token}")
  end

  def tokenChanged(notification)
    self.set_auth_token_header
  end

end