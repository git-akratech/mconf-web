class AddFullSmtpInfoTosite < ActiveRecord::Migration
  def self.up
    add_column :sites, :smtp_auto_tls, :boolean
    add_column :sites, :smtp_server, :string
    add_column :sites, :smtp_port, :integer
    add_column :sites, :smtp_use_tls, :boolean
    add_column :sites, :smtp_domain, :string
    add_column :sites, :smtp_auth_type, :string
    add_column :sites, :smtp_sender, :string
    rename_column :sites, :email, :smtp_login
    rename_column :sites, :email_password, :smtp_password
  end

  def self.down
    remove_column :sites, :smtp_auto_tls
    remove_column :sites, :smtp_server
    remove_column :sites, :smtp_port
    remove_column :sites, :smtp_use_tls
    remove_column :sites, :smtp_domain
    remove_column :sites, :smtp_auth_type
    remove_column :sites, :smtp_sender
    rename_column :sites, :smtp_login, :email
    rename_column :sites, :smtp_password, :email_password
  end
end
