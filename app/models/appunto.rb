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
    
    oauth2 = Motion::OAuth2.new("8998b6c2ff708d83964c1991f99941b6e59f990a5545d266f9cab8756a3a664c", :OAuth) 

    oauth2.get 'http://localhost:3000/api/v1/appunti.json' do |res|
      @res = res
      puts @res.body
      # case
      # when res.success?
      #   if res.json?
      #     puts res.body
      #   else
      #     puts res.body
      #   end
      # when res.redirect?
      #   # ignore
      # when res.error?
      #   puts res.body
      #   puts res.error.code # => OAuth2 error code as Symbol, or :unknown
      #   puts res.error.description # => OAuth2 error description, or nil
      # end
    end






    # AFMotion::Client.shared.get("api/v1/appunti.json") do |result|
    #   if result.success?
    #     appunti = []
    #     result.object.each do |attributes|
    #       appunti << Appunto.new(attributes)
    #     end
    #     callback.call(appunti, nil)
    #   else
    #     callback.call([], result.error)
    #   end
    # end
  end
  
end