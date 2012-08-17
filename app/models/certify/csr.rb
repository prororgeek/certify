module Certify
  class Csr
    @x509_csr = nil
    @key_pair = nil

    #
    # The initializer supports the following two use cases
    #
    # 1. Generate the CSR from existing CSR
    #     csr = Csr.new(:data => File.read('YOURPEMFILE'))
    #
    # 2. Generate the CSR with the help of an existing RSA kay in the database
    #     csr =Csr.new(:key => key_obj, :subject => "/DC=org/DC=ruby-lang/CN=Ruby CA")
    #
    def initialize(options = {})
      if options[:data]
        @x509_csr = OpenSSL::X509::Request.new(options[:data])

      else
        # generate the subject name
        subjectX509 = OpenSSL::X509::Name.parse options[:subject]

        # save the key pair which was used for that
        @key_pair = options[:key]

        # generate the csr
        @x509_csr   = OpenSSL::X509::Request.new
        @x509_csr.version = 0
        @x509_csr.subject = subjectX509
        @x509_csr.public_key = @key_pair.to_x509.public_key
        @x509_csr = @x509_csr.sign @key_pair.to_x509, OpenSSL::Digest::SHA1.new
      end
    end

    def to_x509
      @x509_csr
    end

    def key_pair
      @key_pair
    end

  end
end
