class SubtitleJob < ApplicationRecord
    has_one_attached :file
    has_one_attached :output_file
    
end
