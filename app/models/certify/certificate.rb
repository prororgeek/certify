module Certify
  class Certificate < ActiveRecord::Base
    # accessor
    attr_accessible :certify_authority, :ssldata, :uniqueid

    # associations
    belongs_to :authority, :inverse_of => :certificates

    # validates
    validates :uniqueid, :uniqueness => true
    validates :uniqueid, :ssldata, :presence => true

    # handler
    after_initialize :generate_unique_id

    # set the csr where you want to generate a certificate from
    def csr=(csrpem)
      # read the csr
      csr = OpenSSL::X509::Request.new(csrpem)

      # get the ca_cert
      ca = self.authority
      ca_cert = ca.root_certificate
      ca_key = ca.private_key

      # generate a new cert
      csr_cert = OpenSSL::X509::Certificate.new
      csr_cert.serial = 0
      csr_cert.version = 2
      csr_cert.not_before = Time.now
      csr_cert.not_after = Time.now + 600

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

      self.ssldata = csr_cert.to_pem
    end
  end
end
