require "test_helper"
require Rails.root.join("app/services/subtitle_service")

class SubtitleServiceTest < ActiveSupport::TestCase
    test "convert timestamp to milliseconds" do
        result = SubtitleService.convert_to_milliseconds("00:01:30,500")

        assert_equal 90500, result
    end
    test "shift subtitle timestamps" do
    input = <<~SRT
            1
            00:00:01,000 --> 00:00:03,000
            Hello
    SRT
    
    result = SubtitleService.shift(input, 2000)
    

    assert_includes result, "00:00:03,000 --> 00:00:05,000"
    end
    test "timestamps do not go below zero" do
    input = <<~SRT
        1
        00:00:01,000 --> 00:00:03,000
        Hello
    SRT

    result = SubtitleService.shift(input, -5000)

    assert_includes result, "00:00:00,000"
    end
end