require 'test_helper'

module Certify
  class AuthorityTest < ActiveSupport::TestCase
    test "create standard ca" do
      # create a new model
      ca = Authority.new(:commonname => "company", :organization => "company Inc.", :city => "Town", :state => "BW", :country => "DE", :email => "info@company.com")

      # validate
      assert ca.valid?, ca.errors.full_messages.join('; ')
      assert ca.save
      assert_equal "company", ca.commonname
      assert_equal "company Inc.", ca.organization
      assert_equal "Town", ca.city
      assert_equal "BW", ca.state
      assert_equal "DE", ca.country
      assert_equal "info@company.com", ca.email
    end

    test "find a non existing certificate by serial" do
      # create a new model
      ca = Authority.new(:commonname => "company", :organization => "company Inc.", :city => "Town", :state => "BW", :country => "DE", :email => "info@company.com")

      # find
      cert = ca.find_certificate_by_serial(34)
      assert cert.nil?
      end
  end
end
