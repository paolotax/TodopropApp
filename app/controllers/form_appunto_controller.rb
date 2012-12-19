class FormAppuntoController < Formotion::FormController
  
  attr_accessor :cliente

  def init
    @form = Formotion::Form.new({
      title: "Nuovo Appunto",
      sections: [{
        rows: [{
          title: "Cliente",
          type: :static
        },{
          title: "Destinatario",
          type: :string,
          placeholder: "destinatario",
          key: :destinatario
        }, {
          title: "Appunto",
          type: :text,
          placeholder: "inserisci l'appunto qui",
          row_height: 100,
          key: :note
        }]
      }, {
        rows: [{
          title: "Salva",
          type: :submit,
        }]
      }] 
    })
    @form.on_submit do
      self.salva_appunto
    end
    super.initWithForm(@form)
  end

  def bindCliente(cliente)
    @cliente = cliente
    clienteIndexPath = NSIndexPath.indexPathForRow(0, inSection:0)
    clienteIndexCell = self.tableView.cellForRowAtIndexPath clienteIndexPath
    clienteIndexCell.subviews[2].text = "#{@cliente.titolo}"
  end

  def viewDidLoad
    super
    self.title = "Nuovo Appunto"
    self.navigationItem.rightBarButtonItem = 
      UIBarButtonItem.alloc.initWithTitle("Salva", style:UIBarButtonItemStyleDone, 
                                                   target:self, 
                                                   action:'salva_appunto')
  end

  def salva_appunto
    appunto = @form.render

    data = { 
      appunto: {
        cliente_id: @cliente.id,
        destinatario: appunto[:destinatario],
        note: appunto[:note]
      }
    }

    AFMotion::Client.shared.post("api/v1/appunti", data) do |result|
      if result.success?
        self.navigationController.popViewControllerAnimated true
      else
        puts result.error
      end
    end
  end
end