class CreateShopsBooksInfo < ActiveRecord::Migration[5.2]
  def change
    create_table :shops_books_infos do |t|
      t.belongs_to :book
      t.belongs_to :shop
      t.integer :in_stock
      t.integer :sold
      t.timestamps
    end

    add_index :shops_books_infos, [:book_id, :shop_id], unique: true
  end
end
