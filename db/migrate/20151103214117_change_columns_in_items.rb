class ChangeColumnsInItems < ActiveRecord::Migration
  def change
    enable_extension 'citext'

    change_column :items, :name, :citext
    change_column :items, :description, :citext
  end
end
