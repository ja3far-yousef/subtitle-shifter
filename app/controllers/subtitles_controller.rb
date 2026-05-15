
class SubtitlesController < ApplicationController
  protect_from_forgery with: :null_session

  def index
  end

  def upload
    file = params[:file]
    shift = params[:shift].to_i

    if params[:file].nil?
      return render plain: "No file uploaded", status: 400
    end
    unless params[:file].original_filename.end_with?(".srt")
      return render plain: "Only .srt files allowed", status: 400
    end

    job = SubtitleJob.create(shift_milliseconds: shift)
    job.file.attach(file)

    begin
      content = job.file.download
      result = SubtitleService.shift(content, shift)
    rescue => exception
      return render plain: "Processing failed: #{exception.message}", status: 500
    end

    original_name = job.file.filename.base
    new_filename = "#{original_name}_shifted.srt"
    temp_file = Tempfile.new([new_filename, ".srt"])
    temp_file.write(result)
    temp_file.rewind
    job.output_file.attach(
      io: temp_file,
      filename: new_filename,
      content_type: "text/plain"
    )
    redirect_to result_path(job.id)
  end
  
  def result
    @job = SubtitleJob.find(params[:id])
  end
end
