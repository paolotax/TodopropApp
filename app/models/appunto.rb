class Appunto
  attr_accessor :id, :destinatario, :cliente_nome, :note, :stato

  def initialize(attributes = {})
    self.id           = attributes["id"].to_i
    self.destinatario = attributes["destinatario"]
    self.note         = attributes["note"].to_s
    self.stato        = attributes["stato"]
    self.cliente_nome = attributes["cliente_nome"]
    #self.cliente      = Cliente.new(attributes[:cliente])
  end

  def self.fetchTodopropaAppunti(&callback)
    AFMotion::Client.shared.get("api/v1/appunti.json?auth_token=B2L4q6unF1ZjVVQKXFY3") do |result|
      
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
end