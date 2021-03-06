class AppuntiTableViewController < UITableViewController
  
  attr_accessor :appunti
  attr_accessor :activityIndicatorView

  def self.controller
    @controller ||= AppuntiTableViewController.alloc.initWithNibName(nil, bundle: nil)
  end


  def reload
    self.activityIndicatorView.startAnimating
    self.navigationItem.rightBarButtonItem.enabled = true

    Appunto.fetchTodopropaAppunti do |appunti, error|
      if (error)
        UIAlertView.alloc.initWithTitle("Error",
          message:error.localizedDescription,
          delegate:nil,
          cancelButtonTitle:nil,
          otherButtonTitles:"OK", nil).show
      else
        self.appunti = appunti
      end

      self.activityIndicatorView.stopAnimating
      self.navigationItem.rightBarButtonItem.enabled = true
      
      doneReloadingTableViewData

    end
  end

  def appunti
    @appunti ||= []
  end

  def appunti=(appunti)
    @appunti = appunti
    self.tableView.reloadData
    @appunti
  end

  def loadView
    super

    self.activityIndicatorView = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhite)
    self.activityIndicatorView.hidesWhenStopped = true
  end

  def viewDidLoad
    super
    self.title = "Appunti"
    self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithCustomView(self.activityIndicatorView)
    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemRefresh, target:self, action: 'reload')
    self.tableView.rowHeight = 70
    self.reload
  end

  def viewDidUnload
    self.activityIndicatorView = nil
    super
  end
  
  def viewDidAppear(animated)
    view.reloadData

    @refreshHeaderView ||= begin
      rhv = RefreshTableHeaderView.alloc.initWithFrame(CGRectMake(0, 0 - self.tableView.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
      rhv.delegate = self
      rhv.refreshLastUpdatedDate    
      tableView.addSubview(rhv)
      rhv
    end

  end

  def tableView(tableView, numberOfRowsInSection:section)
    self.appunti.count
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    @@identifier ||= "Cell"
    cell = tableView.dequeueReusableCellWithIdentifier(@@identifier) || begin
      AppuntoTableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:@@identifier)
    end
    cell.appunto = self.appunti[indexPath.row]
    cell
  end

  def tableView(tableView, willDisplayCell:cell, forRowAtIndexPath:indexPath)
    if cell.appunto.stato == "completato"
      cell.backgroundColor = UIColor.groupTableViewBackgroundColor
    end  
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    AppuntoTableViewCell.heightForCellWithPost(self.appunti[indexPath.row])
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated:true)
  end

  ## PullToRefresh
 
  def reloadTableViewDataSource
    @reloading = true
  end
  
  def doneReloadingTableViewData
    
    @reloading = false
    @refreshHeaderView.refreshScrollViewDataSourceDidFinishLoading(self.tableView)
  end
  
  def scrollViewDidScroll(scrollView)
    @refreshHeaderView.refreshScrollViewDidScroll(scrollView)
  end
  
  def scrollViewDidEndDragging(scrollView, willDecelerate:decelerate)
    @refreshHeaderView.refreshScrollViewDidEndDragging(scrollView)
  end
  
  def refreshTableHeaderDidTriggerRefresh(view)
    self.reloadTableViewDataSource
    self.performSelector('reload', withObject:nil, afterDelay:0)
  end
    
  def refreshTableHeaderDataSourceIsLoading(view)
    @reloading
  end
  
  def refreshTableHeaderDataSourceLastUpdated(view)
    NSDate.date
  end

end