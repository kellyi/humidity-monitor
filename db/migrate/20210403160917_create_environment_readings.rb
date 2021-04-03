class CreateEnvironmentReadings < ActiveRecord::Migration[6.1]
  def change
    create_table :environment_readings, id: :uuid do |t|
      t.numeric :temperature, null: false
      t.numeric :humidity, null: false
      t.timestamps
    end
  end
end
