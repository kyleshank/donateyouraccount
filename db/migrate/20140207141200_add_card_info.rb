class AddCardInfo < ActiveRecord::Migration
  def change
  	add_column :campaigns, :billing_last4, :string
  	add_column :campaigns, :billing_exp_month, :integer
  	add_column :campaigns, :billing_exp_year, :integer
  end
end
