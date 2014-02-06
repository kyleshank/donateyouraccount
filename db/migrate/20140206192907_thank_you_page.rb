class ThankYouPage < ActiveRecord::Migration
  def change
  	add_column :campaigns, :thank_you_title, :string
  	add_column :campaigns, :thank_you_body, :text
  end
end
