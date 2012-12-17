class AppDelegate
  attr_accessor :navigationController, :window
  
  def application(application, didFinishLaunchingWithOptions:launchOptions)

    AFMotion::Client.build_shared("http://localhost:3000") do
      header "Accept", "application/json"
      authorization(token: "914226733ed1b75b3610bbf6cec046610ef104106fd325adb557fd07c9b5ae5d")
      operation :json
    end

    url_cache = NSURLCache.alloc.initWithMemoryCapacity(4 * 1024 * 1024, diskCapacity:20 * 1024 * 1024, diskPath:nil)
    NSURLCache.setSharedURLCache(url_cache)

    AFNetworkActivityIndicatorManager.sharedManager.enabled = true

    #viewController = ClientiTableViewController.alloc.initWithStyle(UITableViewStylePlain)

    # self.navigationController = UINavigationController.alloc.initWithRootViewController(viewController)
    # self.navigationController.navigationBar.tintColor = UIColor.darkGrayColor

    # self.window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    # self.window.backgroundColor = UIColor.whiteColor
    # self.window.rootViewController = self.navigationController
    # self.window.makeKeyAndVisible

    # true
    
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @navigation_controller = UINavigationController.alloc.initWithRootViewController(AppuntiTableViewController.controller)
    @window.rootViewController = @navigation_controller
    @window.makeKeyAndVisible

    # @login = LoginController.alloc.init
    # @login_navigation = UINavigationController.alloc.initWithRootViewController(@login)

    # ClientiTableViewController.controller.presentModalViewController(@login_navigation, animated:false)


  end
end
