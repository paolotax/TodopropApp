class LoginController < Formotion::FormController
  
  attr_accessor :credential_store, :parent_controller

  def init

    @credential_store = CredentialStore.new

    @form = Formotion::Form.new({
      title: "Accesso",
      sections: [{
        rows: [{
          title: "Nome utente",
          type: :string,
          value: @credential_store.username,
          placeholder: "nome",
          key: :username,
          auto_correction: :no,
          auto_capitalization: :none
        }, {
          title: "Password",
          type: :string,
          value: @credential_store.password,
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
    @form.on_submit do
      self.login
    end
    super.initWithForm(@form)
  end

  def viewDidLoad
    super
     self.navigationItem.rightBarButtonItem = 
      UIBarButtonItem.alloc.initWithTitle("Accedi", style:UIBarButtonItemStyleDone, 
                                                   target:self, 
                                                   action:'login')
  end

  def login

    app_id = "36e1b9ed802dc7ee45e375bf318924dc3ae0f0f842c690611fde8336687960eb"
    secret = "11ab577f8fabf2ac33bdd75e951fc6507ef7bc21ef993c2a77a1383bed438224"

    data = {
      grant_type: 'password',
      client_id: app_id,
      client_secret: secret,
      username: @form.render[:username],
      password: @form.render[:password]
    }

    AFMotion::Client.shared.post("oauth/token", data) do |result|
      if result.success?
        token = result.object['access_token']

        @credential_store.username = @form.render[:username]
        @credential_store.password = @form.render[:password]
        @credential_store.auth_token = "#{token}"        

        AFMotion::Client.shared.setDefaultHeader("Authorization", value: "Bearer #{token}")
        self.navigationController.dismissModalViewControllerAnimated(true)
        @parent_controller.reload

      else
        puts result.error
      end
    end
  end


end