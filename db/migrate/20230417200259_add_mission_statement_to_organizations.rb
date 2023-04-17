class AddMissionStatementToOrganizations < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :mission_statement, :string
  end
end
