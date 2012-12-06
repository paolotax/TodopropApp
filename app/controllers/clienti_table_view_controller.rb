class ClientiTableViewController < UITableViewController
  
  attr_accessor :clienti 
  attr_accessor :search_results
  attr_accessor :activityIndicatorView

  def reload
    self.activityIndicatorView.startAnimating
    self.navigationItem.rightBarButtonItem.enabled = true

    if @clienti.blank?
      Cliente.fetchTodopropaClienti do |clienti, error|
        if (error)
          UIAlertView.alloc.initWithTitle("Error",
            message:error.localizedDescription,
            delegate:nil,
            cancelButtonTitle:nil,
            otherButtonTitles:"OK", nil).show
        else
          self.clienti = clienti
          self.search_results = clienti.clone
        end

        self.activityIndicatorView.stopAnimating
        self.navigationItem.rightBarButtonItem.enabled = true
      end
    else
      self.search_results = @clienti.clone
      self.activityIndicatorView.stopAnimating
      self.navigationItem.rightBarButtonItem.enabled = true
      self.title = "Clienti"
    end
  end

  def clienti
    @clienti ||= []
  end

  def clienti=(clienti)
    @clienti = clienti
    @clienti
  end

  def search_results
    @search_results ||= []
  end

  def search_results=(search_results)
    @search_results = search_results
    self.tableView.reloadData
    @search_results
  end

  def loadView
    super

    self.activityIndicatorView = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhite)
    self.activityIndicatorView.hidesWhenStopped = true
  end

  def viewDidLoad
    super
    self.title = "Clienti"

    self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithCustomView(self.activityIndicatorView)
    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemRefresh, target:self, action: 'reload')

    self.tableView.rowHeight = 70
    
    search_bar = UISearchBar.alloc.initWithFrame([[0,0],[200,44]])
    search_bar.tintColor = UIColor.darkGrayColor
    search_bar.placeholder = "cerca clienti..."
    search_bar.delegate = self
    #view.addSubview(search_bar)
    self.navigationItem.titleView = search_bar

    self.reload
  end

  def searchBarSearchButtonClicked(search_bar)
    @search_results.clear
    search_bar.resignFirstResponder
    navigationItem.title = "Clienti...'#{search_bar.text}'"
    search_for(search_bar.text)
    search_bar.text = ""
  end

  def search_for(text)
    @search_results = @clienti.select do |c| 
      condition = text.downcase
      c.comune.downcase.include?( condition ) ||
        c.titolo.downcase.include?( condition) ||
          c.frazione.downcase.include? (condition)
    end  

    view.reloadData
  end

  def viewDidUnload
    self.activityIndicatorView = nil
    super
  end

  def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
    interfaceOrientation == UIInterfaceOrientationPortrait
  end

## Table view data source

  def numberOfSectionsInTableView(tableView)
    # Return the number of sections.
    1
  end

  def tableView(tableView, numberOfRowsInSection:section)
    # Return the number of rows in the section.
    self.search_results.count
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    @@identifier ||= "Cell"

    cell = tableView.dequeueReusableCellWithIdentifier(@@identifier) || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:@@identifier)
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      cell
    end

    cliente = self.search_results[indexPath.row]
    cell.textLabel.text = cliente.titolo
    cell.detailTextLabel.text = cliente.citta
    cell 
  end

## Table view delegate

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    cliente_view_controller = ClienteViewController.alloc.init
    cliente = self.search_results[indexPath.row]
    cliente_view_controller.bind_cliente(cliente)
    self.navigationController.pushViewController(cliente_view_controller, animated:true)
  end

end
