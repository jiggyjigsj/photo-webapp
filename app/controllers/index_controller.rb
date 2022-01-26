class IndexController < ApplicationController
  def view
    flash[:warning] = "You must be logged in to see this page"
    if current_user
      @id = current_user.id
      @name = current_user.name
      @email = current_user.email
      @phone = current_user.phone
    else
      # flash[:warning] = "You must be logged in to see this page"
      # redirect_to '/login'
    end
    flash.now[:notice] = "We have exactly 2 books available."
    flash.keep
  end

  def job
    bucket_name = ENV.fetch("GCP_CLOUD_STORAGE_BUCKET")
    uid = SecureRandom.hex(7)

    img = params["image"].read
    img_name = params["image"].original_filename
    ext = File.extname(img_name)
    uid_file = "#{uid}#{ext}"
    uid_path = File.join('/tmp', uid_file )

    upload_path = File.join('photonic', current_user.username , uid_file )

    File.open(uid_path,"wb") do |file|
      file.puts img
    end

    bucket = gcp_cloud_storage(bucket_name)
    file = bucket.create_file uid_path, upload_path

    # puts "Uploaded #{img} as #{file.name} in bucket #{bucket_name}"
  end
  # private
  # def index_params
  #   params.require(:index).permit(:image)
  # end
end
