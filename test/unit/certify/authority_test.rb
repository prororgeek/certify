require 'test_helper'

module Certify
  class AuthorityTest < ActiveSupport::TestCase
    test "create standard ca" do
      # create a new model
      ca = Authority.new(:commonname => "applimit", :organization => "app.limit UG", :city => "Filderstadt", :state => "BW", :country => "DE", :email => "info@applimit.com")

      # validate
      assert ca.valid?, ca.errors.full_messages.join('; ')
      assert ca.save
      assert_equal "applimit", ca.commonname
      assert_equal "app.limit UG", ca.organization
      assert_equal "Filderstadt", ca.city
      assert_equal "BW", ca.state
      assert_equal "DE", ca.country
      assert_equal "info@applimit.com", ca.email
    end
  end
end
