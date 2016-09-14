class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.string :status
      t.integer :cost
      t.integer :score
      t.integer :player_id

      t.timestamps
    end

    add_foreign_key :games, :players
  end
end
