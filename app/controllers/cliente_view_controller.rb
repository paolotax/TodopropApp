class ClienteViewController < UIViewController
  
  attr_accessor :cliente

  def loadView 
    views = NSBundle.mainBundle.loadNibNamed("cliente_view", owner:self, options:nil)
    self.view = views[0]
  end

  def bind_cliente(cliente)
    @cliente = cliente
    self.navigationItem.title = "Cliente: #{@cliente.id}"
  end

  def viewDidLoad
    super
    # labelTitolo    = view.viewWithTag(1)
    # labelIndirizzo = view.viewWithTag(2)
    # labelComune    = view.viewWithTag(3)
    # buttonChiama   = view.viewWithTag(4)
    # buttonEmail    = view.viewWithTag(5)
    # buttonNuovoAppunto = view.viewWithTag(6)

    # labelTitolo.text    = @cliente.titolo
    # labelIndirizzo.text = @cliente.indirizzo
    # labelComune.text    = "#{@cliente.cap} #{@cliente.citta} #{@cliente.provincia}"

    # buttonChiama.addTarget(self, action:'makeCall:', forControlEvents:UIControlEventTouchUpInside)
    # buttonEmail.addTarget(self, action:'sendEmail:', forControlEvents:UIControlEventTouchUpInside)
    # buttonNuovoAppunto.addTarget(self, action:'nuovoAppunto:', forControlEvents:UIControlEventTouchUpInside)

    self.navigationItem.rightBarButtonItem = 
              UIBarButtonItem.alloc.initWithTitle("Menu", style: UIBarButtonItemStyleBordered, 
                                                         target:self, 
                                                         action:'showActionSheet:')

    @data = [{
        fieldName: "Cliente",
        value: @cliente.titolo
      },{
        fieldName: "Indirizzo",
        value: @cliente.indirizzo
      },{
        fieldName: "Città",
        value: "#{@cliente.cap} #{@cliente.citta} #{@cliente.provincia}"
    }]

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
    
    actionSheet.subviews.each do |view|
      p view
      if view.class == UIButton && view.titleLabel.text == "Telefona"
        view.enabled = !@cliente.telefono.nil?
      end
    end

  end 


  def tableView(table_view, cellForRowAtIndexPath:index_path)
    cell = table_view.dequeueReusableCellWithIdentifier('Cell')

    unless cell
      cell = UITableViewCell.alloc.initWithStyle(:value1.uitablecellstyle,   # !?
                                 reuseIdentifier:'Cell')
    end

    cell.textLabel.text = @data[index_path.row][:fieldName]
    cell.detailTextLabel.text = @data[index_path.row][:value]
    
    return cell
  end

  def tableView(table_view, numberOfRowsInSection:section)
    3
  end

  def tableView(table_view, didSelectRowAtIndexPath:index_path)
    table_view.deselectRowAtIndexPath(index_path, animated:true)
  end

end
