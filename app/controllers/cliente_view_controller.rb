class ClienteViewController < UIViewController
  
  attr_accessor :cliente, :appunti

  def loadView 
    views = NSBundle.mainBundle.loadNibNamed("cliente_view", owner:self, options:nil)
    self.view = views[0]
  end

  def bind_cliente(cliente)
    @cliente = cliente
    self.navigationItem.title = "Cliente: #{@cliente.id}"
    puts "appunti...... #{self.appunti}"
  end

  def load_appunti
    @cliente.fetchTodopropaAppuntiCliente do |appunti, error|
      if (error)
          UIAlertView.alloc.initWithTitle("Error",
            message:error.localizedDescription,
            delegate:nil,
            cancelButtonTitle:nil,
            otherButtonTitles:"OK", nil).show
      else
        self.appunti = appunti
        @table_view.reloadData if @table_view
      end
    end
  end
  
  def viewDidLoad
    super

    self.navigationItem.rightBarButtonItem = 
              UIBarButtonItem.alloc.initWithTitle("Menu", style: UIBarButtonItemStyleBordered, 
                                                         target:self, 
                                                         action:'showActionSheet:')

    @appunti = []
    @data = { 
              cliente: [{
                    fieldName: "Cliente",
                    value: @cliente.titolo
                  },{
                    fieldName: "Indirizzo",
                    value: @cliente.indirizzo
                  },{
                    fieldName: "Città",
                    value: "#{@cliente.cap} #{@cliente.citta} #{@cliente.provincia}"
                }]
            }

    load_appunti

    @table_view = view.viewWithTag(7)
    @table_view.dataSource = self
    @table_view.delegate = self

  end

  def viewDidUnload
    super
    # Release any retained subviews of the main view.
  end

  def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
    interfaceOrientation == UIInterfaceOrientationPortrait
  end

  def makeCall(sender)
    url = NSURL.URLWithString("tel://#{@cliente.telefono.split(" ").join}")
    UIApplication.sharedApplication.openURL(url);
  end  

  def sendEmail(sender)
    url = NSURL.URLWithString("mailto://#{@cliente.email}")
    UIApplication.sharedApplication.openURL(url);
  end  

  def nuovoAppunto(sender)
    nuovo_appunto_controller = FormAppuntoController.alloc.init
    nuovo_appunto_controller.bindCliente @cliente
    self.navigationController.pushViewController(nuovo_appunto_controller, animated:true)
  end 

  def showActionSheet(sender)
    self.navigationItem.rightBarButtonItem.enabled = false
    actionSheet = RDActionSheet.alloc.initWithCancelButtonTitle("Annulla",
                                                       primaryButtonTitle:"Nuovo Appunto",
                                                       destroyButtonTitle: nil,
                                                        otherButtonTitles:"Telefona", "Invia email", "Naviga", nil)

    actionSheet.callbackBlock = lambda { |result, buttonIndex|
      
      case result
        when RDActionSheetButtonResultSelected
          case buttonIndex
            when 3
              nuovoAppunto nil
            when 2
              puts "not implemented"
            when 1
              sendEmail nil
            when 0
              makeCall nil
          end      

        when RDActionSheetResultResultCancelled
          puts buttonIndex
      end  

      self.navigationItem.rightBarButtonItem.enabled = true
    }
    actionSheet.showFrom self.view;

    actionSheet.buttons.each do |button|
      if button.titleLabel.text == "Telefona"
        button.enabled = !@cliente.telefono.blank?
      end
      if button.titleLabel.text == "Invia email"
        button.enabled = !@cliente.email.blank?
      end
    end
  end 



  ## TableView delegate

  def numberOfSectionsInTableView(tableView)
    2
  end

  def tableView(table_view, numberOfRowsInSection:section)
    if section == 0
      @data[:cliente].count
    else
      @appunti.count
    end  
  end

  def tableView(table_view, cellForRowAtIndexPath:indexPath)

    if (indexPath.section == 0)
      
      cell = table_view.dequeueReusableCellWithIdentifier('cliCell')
      unless cell
        cell = UITableViewCell.alloc.initWithStyle(:value1.uitablecellstyle, reuseIdentifier:'cliCell')
      end
      cell.textLabel.text =       @data[:cliente][indexPath.row][:fieldName]
      cell.detailTextLabel.text = @data[:cliente][indexPath.row][:value]
      return cell
    
    else
      
      cell = table_view.dequeueReusableCellWithIdentifier('appCliCell')
      unless cell
        views = NSBundle.mainBundle.loadNibNamed("appunto_cliente_cell", owner:nil, options:nil)
        cell = views[0]
      end
      
      cell.appunto = @appunti[indexPath.row]
      return cell
    end
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)

    if (indexPath.section == 1)
      AppuntoClienteCell.heightForCellWithAppunto(@appunti[indexPath.row])
    else
      44
    end
  end

  def tableView(table_view, didSelectRowAtIndexPath:indexPath)
    table_view.deselectRowAtIndexPath(indexPath, animated:true)
  end


end
