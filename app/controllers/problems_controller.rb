class ProblemsController < ApplicationController
  include ProblemsHelper

  def new
    redirect_to '/'
  end

  def submit    
   
  end

  def upload
    uploaded_file = params[:file]
    if !uploaded_file.nil?
      # Check the file extension, if it is wrong flash an error
      if file_extension_check(uploaded_file)
        # Check the file size, if it is over flash an error
        if file_size_check(uploaded_file)
          thread = Thread.new {
            code_processor = CodeProcessor.new(uploaded_file, Problem.find_by(id: params[:problem_id]), current_user, params[:lang])
            code_processor.run
          }
          flash[:error] = "File is being processed"
          redirect_to '/submission'
        else
          flash[:error] = "File size exceeded"
          redirect_to request.original_url
        end
      else
        flash[:error] = "Wrong file type"
        redirect_to request.original_url
      end
    else
      flash[:error] = "Please upload a file"
      redirect_to request.original_url
    end
  end

  def create
    redirect_to '/index'
  end

  def main
    @problem = Problem.find_by(id: params[:problem_id])
    if (@problem.nil?)
      flash[:error] = "Cannot find problem"
      redirect_to "/contest/#{params[:contest_id]}"
    end
  end
end
