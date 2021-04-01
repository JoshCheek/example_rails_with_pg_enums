class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_enum :user_status, %w(active inactive)

    create_table :users do |t|
      t.string :name
      t.enum :status, enum_name: :user_status, default: 'active'
      t.timestamps
    end
  end
end
