class CreateCertifyAuthorities < ActiveRecord::Migration
  def change
    create_table :certify_authorities do |t|
      t.string :uniqueid
      t.text :rsakey
      t.text :sslcert
      t.timestamps
    end
  end
end
