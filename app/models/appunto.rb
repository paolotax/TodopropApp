class Appunto
  
  PROPERTIES = [:id, :destinatario, :cliente_nome, :note, :stato]
  PROPERTIES.each { |prop|
    attr_accessor prop
  }
  
  def initialize(attributes = {})
    attributes.each { |key, value|
      if PROPERTIES.member? key.to_sym
        self.send((key.to_s + "=").to_s, value)
      end
    }
  end

  def self.fetchTodopropaAppunti(&callback)

    AFMotion::Client.shared.get("api/v1/appunti.json") do |result|
      if result.success?
        appunti = []
        result.object.each do |attributes|
          appunti << Appunto.new(attributes)
        end
        callback.call(appunti, nil)
      else
        callback.call([], result.error)
      end
    end
  end

  def self.autentica(username, password)



  end

  
end