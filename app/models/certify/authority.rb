module Certify
  class Authority < ActiveRecord::Base
    # make this attributes accessable in forms and so on
    attr_accessible :commonname, :organization, :city, :state, :country, :email

    # virtual attributes
    attr_writer :commonname, :organization, :city, :state, :country, :email

    # associations
    has_many :certificates, :dependent => :destroy, :inverse_of => :authority

    # validates
    validates :uniqueid, :uniqueness => true
    validates :commonname, :city, :state, :country, :organization, :email, :presence => true
    validates_format_of :commonname, :with => /^[\w\-@]*$/, :message => "Only letters or numbers allowed"
    validates_length_of :country, :maximum => 2
    validates_format_of :country, :with => /^[a-zA-Z]*$/, :message => "Only letters allowed"
    validates_email_format_of :email

    # handler
    after_initialize :generate_unique_id
    before_create :generate_new_ca

    # property accessors
    def private_key
      OpenSSL::PKey::RSA.new(self.rsakey) if self.rsakey
    end

    def root_certificate
      OpenSSL::X509::Certificate.new(self.sslcert) if self.sslcert
    end

    def commonname
      if root_certificate
        subject_hash["CN"]
      else
        @commonname
      end
    end

    def organization
      if root_certificate
        subject_hash["O"]
      else
        @organization
      end
    end

    def city
      if root_certificate
        subject_hash["L"]
      else
        @city
      end
    end

    def state
      if root_certificate
        subject_hash["ST"]
      else
        @state
      end
    end

    def country
      if root_certificate
        subject_hash["C"]
      else
        @country
      end
    end

    def email
      if root_certificate
        subject_hash["emailAddress"]
      else
        @email
      end
    end

    #
    # This method builds the subject hash from the x509 name
    def subject_hash
      # get the array from the name
      dataArray = self.root_certificate.subject.to_a

      # create the result hash
      dataHash = Hash.new()

      # go through
      dataArray.each do |item|
        dataHash[item[0]] = item[1]
      end

      # emit
      dataHash
    end

    # builds a new CA
    def generate_new_ca()
      # generate the root key pair
      root_key = OpenSSL::PKey::RSA.new 2048 # the CA's public/private key
      self.rsakey = root_key.to_pem

      # generate the CA name
      ca_name_str = "/C=#{country}/ST=#{state}/O=#{organization}/L=#{city}/CN=#{commonname}/emailAddress=#{email}"

      # parse the name
      ca_name = OpenSSL::X509::Name.parse  ca_name_str

      # generate the root certificate
      root_ca = OpenSSL::X509::Certificate.new
      root_ca.version = 2 # cf. RFC 5280 - to make it a "v3" certificate
      root_ca.serial = 1
      root_ca.subject = ca_name
      root_ca.issuer = root_ca.subject # root CA's are "self-signed"
      root_ca.public_key = root_key.public_key
      root_ca.not_before = Time.now
      root_ca.not_after = root_ca.not_before + 2 * 365 * 24 * 60 * 60 # 2 years validity
      ef = OpenSSL::X509::ExtensionFactory.new
      ef.subject_certificate = root_ca
      ef.issuer_certificate = root_ca
      root_ca.add_extension(ef.create_extension("basicConstraints","CA:TRUE",true))
      root_ca.add_extension(ef.create_extension("keyUsage","keyCertSign, cRLSign", true))
      root_ca.add_extension(ef.create_extension("subjectKeyIdentifier","hash",false))
      root_ca.add_extension(ef.create_extension("authorityKeyIdentifier","keyid:always",false))
      root_ca.sign(root_key, OpenSSL::Digest::SHA256.new)

      # store the root ca
      self.sslcert = root_ca.to_pem
    end

    def self.find_by_commonname(cn)
      result= Array.new()

      Authority.all.each do |a|

        if a.commonname.eql?(cn)
          result.append(a)
        end

      end

      result
    end
  end
end
