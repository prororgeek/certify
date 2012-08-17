module Certify
  class KeyPair < ActiveRecord::Base
    # set the table name
    self.table_name=  'certify_key_pairs'

    # associations
    belongs_to :authority, :inverse_of => :key_pairs
    has_many :certificates, :dependent => :destroy, :inverse_of => :key_pair

    # validations
    validates :ssldata, :presence => true

    # attribute accessors
    attr_accessible :authority_id, :ssldata, :uniqueid

    # handler
    after_initialize :generate_unique_id
    before_validation :generate_new_key

    # generates a new private key
    def generate_new_key
      self.ssldata = OpenSSL::PKey::RSA.new(2048).to_pem unless self.ssldata
    end

    def to_x509
      OpenSSL::PKey::RSA.new(self.ssldata)
    end

    def to_pem
      to_x509.to_pem
    end

    def generate_csr(subject_name)
      Csr.new(:key => self, :subject => subject_name)
    end

  end
end