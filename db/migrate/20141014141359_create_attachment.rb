class CreateAttachment < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :name
      t.references :fileable, polymorphic: true
    end
  end
end
