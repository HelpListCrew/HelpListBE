class AddLatitudeToOrganizations < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :latitude, :float
  end
end
