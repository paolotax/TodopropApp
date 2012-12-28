class Cliente
  
  include Formotion::Formable

  form_property :titolo, :string
  form_property :comune, :string
  form_property :frazione, :string

  form_property :cliente_tipo, :picker, items: ["Scuola Primaria", "Cartoleria", "Ditta"]
  form_property :provincia, :picker, items: ["RA", "RE", "MO"]

  form_title "Modifica Cliente"

  attr_accessor :id, :titolo, :comune, :frazione, :cliente_tipo, :indirizzo, :cap, :provincia, 
                :telefono, :email, :appunti

  def initialize(attributes = {})
    attributes.each_pair do |key, value|
      self.send("#{key}=", value) if self.respond_to?(key)
    end
  end

  def citta
    self.frazione.blank? ? self.comune : self.frazione
  end
  
  def self.fetchTodopropaClienti(token, &callback)
    AFMotion::Client.shared.get("api/v1/clienti.json") do |result|
      if result.success?
        clienti = []
        result.object.each do |attributes|
          clienti << Cliente.new(attributes)
        end
        callback.call(clienti, nil)
      else
        callback.call([], result.error)
      end
    end
  end

  def fetchTodopropaAppuntiCliente(&callback)
    AFMotion::Client.shared.get("api/v1/clienti/#{@id}.json") do |result|
      if result.success?
        appunti = []
        result.object[:appunti].each do |attributes|
          puts attributes[:appunto]
          appunti << Appunto.new(attributes[:appunto])
        end
        callback.call(appunti, nil)
      else
        callback.call([], result.error)
      end
    end
  end


end