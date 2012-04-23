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

      # create the certificate
      cert = ca.certificates.build
      cert.csr = csr

      # validate
      assert cert.valid?, cert.errors.full_messages.join('; ')
      assert cert.save

      #validate the fields of the certificate
    end
  end
end
