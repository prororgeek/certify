require 'test_helper'

module Certify
  class CertificateTest < ActiveSupport::TestCase
    test "generate new certificate in ca" do
      # create a new model
      ca = Authority.new(:commonname => "company", :organization => "company Inc.", :city => "Town", :state => "BW", :country => "DE", :email => "info@company.com")

      # validate
      assert ca.valid?, ca.errors.full_messages.join('; ')
      assert ca.save

      # take a fix csr
      csr =
          "-----BEGIN CERTIFICATE REQUEST-----
MIIBuzCCASQCAQAwezELMAkGA1UEBhMCREUxCzAJBgNVBAgMAkJXMRQwEgYDVQQH
DAtGaWxkZXJzdGFkdDEVMBMGA1UECgwMYXBwLmxpbWl0IFVHMRAwDgYDVQQDDAdU
ZXN0Q1NSMSAwHgYJKoZIhvcNAQkBFhFpbmZvQGFwcGxpbWl0LmNvbTCBnzANBgkq
hkiG9w0BAQEFAAOBjQAwgYkCgYEAsIofquwQAGlr4MSy/fOO7/Dq6Y193aiR+6FD
UV5ULcIjGdtrjt4Miz5YlBBPa7P2cZ7GflztBCoY+W3dakgOmjAsav8VF6jAVTmO
sTGZMreRJfBZaxPqhPzd0O1Wp9R/DiUr7Peoglb+Lw41DXQaF5EZGNbzq0ns0Bpf
SDrm+3MCAwEAAaAAMA0GCSqGSIb3DQEBBQUAA4GBAJQQ6Me4SkTknSPVfP2jCuBH
rUI/OyKPRlLzIsANUlD2ubfZWa6um9MIoeMQvISwoz8TIgZ5WGzNHTi+/ONA2wv9
8WDoRm883erKUOb8ihHfeUCV6C/B4w4La4oJ10w1D3MnJAsEE8qs1++OVhKhG9lF
EUKCs2HmUX2HQTkA7EoO
-----END CERTIFICATE REQUEST-----"


      # create the cse object
      csr_obj = Csr.new(:data => csr)

      # create the certificate
      cert = ca.sign_csr(csr_obj)

      # validate
      assert cert.valid?, cert.errors.full_messages.join('; ')
      assert !cert.new_record?, "Record was not saved during generation"
      assert_equal cert.serial, cert.id
      assert !cert.to_p12(:password => "testpwd") # we have no associated private key in the database

      cert2 = Certificate.find_by_serial(cert.id)
      assert cert2, "Certificate not found"

      cert3 = ca.find_certificate_by_serial(cert.id)
      assert cert3, "Certificate not found"
    end
  end
end
