class AuthApiClient < AFHTTPClient

  BASE_URL = "http://localhost:3000"

  def self.shared_client

  end

# + (id)sharedClient {
#     static AuthAPIClient *__instance;
#     static dispatch_once_t onceToken;
#     dispatch_once(&onceToken, ^{
#         NSURL *baseUrl = [NSURL URLWithString:BASE_URL];
#         __instance = [[AuthAPIClient alloc] initWithBaseURL:baseUrl];
#     });
#     return __instance;
# }

  def init_with_base_url(url)

    # self = super.initWithBaseURL(url)
    # if self
    #   self.registerHTTPOperationClass(AFJSONRequestOperation.class)
    #   self.set_auth_token_header
    #   NSNotificationCenter.defaultCenter.addObserver(self,
    #                                              selector:"token_changed",
    #                                                  name:"token-changed",
    #                                                object:nil)
    # end
    # return self
  end

# - (id)initWithBaseURL:(NSURL *)url {
#     self = [super initWithBaseURL:url];
#     if (self) {
#         [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
#         [self setAuthTokenHeader];
        
#         [[NSNotificationCenter defaultCenter] addObserver:self
#                                                  selector:@selector(tokenChanged:)
#                                                      name:@"token-changed"
#                                                    object:nil];
#     }
#     return self;
# }

  def set_auth_token_header
    store = CredentialStore.new
    auth_token = store.auth_token
    self.setDefaultHeader("auth_token", value:auth_token)
  end

# - (void)setAuthTokenHeader {
#     CredentialStore *store = [[CredentialStore alloc] init];
#     NSString *authToken = [store authToken];
#     NSLog(@"setAuthToken %@", authToken);
#     [self setDefaultHeader:@"auth_token" value:authToken];
# }

def tokenChanged(notification)
  self.set_auth_token_header
end



end