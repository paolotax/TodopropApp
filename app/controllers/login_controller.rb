class LoginController < Formotion::FormController
  def init
    form = Formotion::Form.new({
      title: "Accesso",
      sections: [{
        rows: [{
          title: "Nome utente",
          type: :string,
          placeholder: "nome",
          key: :user
        }, {
          title: "Password",
          type: :string,
          placeholder: "password",
          key: :password,
          secure: true
        }, {
          title: "Ricordati?",
          type: :switch,
          key: :remember,
          value: true
        }]
      }, {
        rows: [{
          title: "Accedi",
          type: :submit,
        }]
      }]
    })
    form.on_submit do
      self.login
    end
    super.initWithForm(form)
  end

  def viewDidLoad
    super
    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Accedi", style: UIBarButtonItemStyleDone, target:self, action:'login')
  end

  def login
    [:user, :password, :remember].each { |prop|
      ClientiTableViewController.controller.send(prop.to_s + "=", form.render[prop])
    }
    self.navigationController.dismissModalViewControllerAnimated(true)
  end
end