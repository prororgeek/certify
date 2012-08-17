module Certify
  class Certificate < ActiveRecord::Base
    # set the table name
    self.table_name=  'certify_certificates'

    # accessor
    attr_accessible :authority, :ssldata, :uniqueid, :serial, :key_pair

    # associations
    belongs_to :authority, :inverse_of => :certificates
    belongs_to :key_pair, :inverse_of => :certificates

    # validates
    validates :uniqueid, :uniqueness => true
    validates :uniqueid, :ssldata, :presence => true

    # handler
    after_initialize :generate_unique_id

    def to_x509!
      OpenSSL::X509::Certificate.new(self.ssldata)
    end

    def to_x509
      begin
        to_x509!
      rescue
        nil
      end
    end

    def to_pem
      self.ssldata
    end

    def to_p12!(options = {})
      raise "Missing key pair to generate the PKCS12 file" unless self.key_pair

      pkey = key_pair.to_x509
      cert = self.to_x509!

      password = options[:password]
      password = "test" unless password

      friendly_key = options[:display]
      friendly_key = "key" unless friendly_key

      OpenSSL::PKCS12::create(password, friendly_key, pkey, cert, [ self.authority.root_certificate ])
    end

    def to_p12(password)
      begin
        to_p12!(password)
      rescue
        nil
      end
    end

    def serial
      if to_x509
        to_x509.serial
      else
        0
      end
    end

    def self.find_by_serial(serial)
      Certificate.find(serial)
    end
  end
end