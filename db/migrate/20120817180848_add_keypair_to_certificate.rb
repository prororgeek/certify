class AddKeypairToCertificate < ActiveRecord::Migration
  def change
    add_column :certify_certificates, :key_pair_id, :integer
  end
end
