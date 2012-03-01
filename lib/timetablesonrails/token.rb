require 'securerandom'

module TimetablesOnRails
  class Token
    def self.generate
			SecureRandom.urlsafe_base64
    end
  end
end
