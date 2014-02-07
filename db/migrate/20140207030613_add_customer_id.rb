class AddCustomerId < ActiveRecord::Migration
  def change
  	add_column :campaigns, :customer_id, :string
  end
end
