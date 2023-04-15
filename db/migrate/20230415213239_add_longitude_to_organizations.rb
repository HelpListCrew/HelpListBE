class AddLongitudeToOrganizations < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :longitude, :float
  end
end
