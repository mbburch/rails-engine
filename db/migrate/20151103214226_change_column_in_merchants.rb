class ChangeColumnInMerchants < ActiveRecord::Migration
  def change
    enable_extension 'citext'

    change_column :merchants, :name, :citext
  end
end
