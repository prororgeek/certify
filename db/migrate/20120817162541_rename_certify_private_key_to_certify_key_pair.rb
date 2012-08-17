class RenameCertifyPrivateKeyToCertifyKeyPair < ActiveRecord::Migration
  def up
    rename_table :certify_private_keys, :certify_key_pairs
  end

  def down
    rename_table :certify_key_pairs, :certify_private_keys
  end
end
