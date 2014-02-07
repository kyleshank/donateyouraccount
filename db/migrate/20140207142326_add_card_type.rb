class AddCardType < ActiveRecord::Migration
  def change
  	add_column :campaigns, :billing_type, :string
  end
end
