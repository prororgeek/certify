module Certify
  class Certificate < ActiveRecord::Base
    # set the table name
    self.table_name=  'certify_certificates'

    # accessor
    attr_accessible :certify_authority, :ssldata, :uniqueid, :serial

    # associations
    belongs_to :authority, :inverse_of => :certificates

    # validates
    validates :uniqueid, :uniqueness => true
    validates :uniqueid, :ssldata, :presence => true

    # handler
    after_initialize :generate_unique_id

    def sslcertificate
      OpenSSL::X509::Certificate.new(self.ssldata) if self.ssldata
    end

    def serial
      if sslcertificate
        sslcertificate.serial
      else
        0
      end
    end

    def self.sign_csr_for_ca(csr_in_pem_format, ca)
      # create a new certificate record to get a unique db id
      certificate = ca.certificates.build(:ssldata => "Certificate pending")
      if !certificate.save
        nil
      end

      # read the csr
      csr = OpenSSL::X509::Request.new(csr_in_pem_format)

      # get the ca_cert
      ca_cert = ca.root_certificate
      ca_key = ca.private_key

      # generate a new cert
      csr_cert = OpenSSL::X509::Certificate.new
      csr_cert.serial = certificate.id
      csr_cert.version = 2
      csr_cert.not_before = Time.now
      csr_cert.not_after = Time.now + (365 * 24 * 60 * 60)

      csr_cert.subject = csr.subject
      csr_cert.public_key = csr.public_key
      csr_cert.issuer = ca_cert.subject

      extension_factory = OpenSSL::X509::ExtensionFactory.new
      extension_factory.subject_certificate = csr_cert
      extension_factory.issuer_certificate = ca_cert

      extension_factory.create_extension 'basicConstraints', 'CA:FALSE'
      extension_factory.create_extension 'keyUsage',
                                         'keyEncipherment,dataEncipherment,digitalSignature'
      extension_factory.create_extension 'subjectKeyIdentifier', 'hash'

      csr_cert.sign ca_key, OpenSSL::Digest::SHA1.new

      # update certificate attribute
      certificate.update_attributes(:ssldata => csr_cert.to_pem)

      # emit result
      certificate
    end

    def self.find_by_serial(serial)
      Certificate.find(serial)
    end
  end
end