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
    labelTitolo    = view.viewWithTag(1)
    labelIndirizzo = view.viewWithTag(2)
    labelComune    = view.viewWithTag(3)
    buttonChiama   = view.viewWithTag(4)
    buttonEmail    = view.viewWithTag(5)
    buttonNuovoAppunto = view.viewWithTag(6)

    labelTitolo.text    = @cliente.titolo
    labelIndirizzo.text = @cliente.indirizzo
    labelComune.text    = "#{@cliente.cap} #{@cliente.citta} #{@cliente.provincia}"

    buttonChiama.addTarget(self, action:'makeCall:', forControlEvents:UIControlEventTouchUpInside)
    buttonEmail.addTarget(self, action:'sendEmail:', forControlEvents:UIControlEventTouchUpInside)
    buttonNuovoAppunto.addTarget(self, action:'nuovoAppunto:', forControlEvents:UIControlEventTouchUpInside)

    if @cliente.telefono.blank?
      buttonChiama.enabled = false
    end

    if @cliente.email.blank?
      buttonEmail.enabled = false
    end

  end

  def viewDidUnload
    super
    # Release any retained subviews of the main view.
  end

  def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
    interfaceOrientation == UIInterfaceOrientationPortrait
  end

  def makeCall(sender)
    url = NSURL.URLWithString("tel://#{@cliente.telefono}")
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

end
