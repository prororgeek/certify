require 'test_helper'

module Certify
  class KeyPairTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end

    test "generate new key" do
      # create a new model
      ca = Authority.new(:commonname => "company", :organization => "company Inc.", :city => "Town", :state => "BW", :country => "DE", :email => "info@company.com")

      # validate
      assert ca.valid?, ca.errors.full_messages.join('; ')
      assert ca.save

      # create a new key
      kp = ca.key_pairs.build
      assert kp.valid?, kp.errors.full_messages.join('; ')
      assert kp.save

    end

    test "generate new certificate in ca" do
      # create a new model
      ca = Authority.new(:commonname => "company", :organization => "company Inc.", :city => "Town", :state => "BW", :country => "DE", :email => "info@company.com")

      # validate
      assert ca.valid?, ca.errors.full_messages.join('; ')
      assert ca.save

      # create a new key
      kp = ca.key_pairs.build
      assert kp.valid?, kp.errors.full_messages.join('; ')
      assert kp.save

      # generate a csr
      csr = kp.generate_csr('CN=nobody/DC=example')

      # issue a certificate
      cert = ca.sign_csr(csr)
      assert cert.valid?
      assert cert.to_x509.verify(ca.private_key), cert.errors.full_messages.join('; ')

      # try to build a p12 file from that
      p12 = cert.to_p12(:password => "testpwd")
      assert p12
    end

    test "verify to_x509" do
      # generate a new key
      kp = KeyPair.new
      assert kp.save

      k1 = KeyPair.find_by_uniqueid(kp.uniqueid)
      k2 = KeyPair.find_by_uniqueid(kp.uniqueid)

      assert_equal k1.ssldata, k2.ssldata
      assert_equal k1.to_x509.to_pem, k2.to_x509.to_pem
    end
  end
end
