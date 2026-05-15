class CreateSubtitleJobs < ActiveRecord::Migration[8.1]
  def change
    create_table :subtitle_jobs do |t|
      t.integer :shift_milliseconds

      t.timestamps
    end
  end
end
