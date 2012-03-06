require_relative './password_hasher'

module TimetablesOnRails
  class Authentification

    # == TimetablesOnRails::Authentification.authenticate
    # Authenticate a given resource on a given password hash field.
    #
    # == Example
    # class Company
    #   attr_accessor :password_hash
    # end
    #
    # company = Company.new
    # company.password_hash = PasswordHasher.hash 'secret'
    # Authentification.authenticate company, :password_hash, 'secret' # true
    # Authentification.authenticate company, :password_hash, 'bad secret' # false
    #
    def self.authenticate(resource, password_hash_field, password) 
      hash = resource.send password_hash_field
      PasswordHasher.compare hash, password
    end

  end
end
