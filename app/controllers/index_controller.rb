class IndexController < ApplicationController
  def view
    if current_user
      @id = current_user.id
      @name = current_user.name
      @email = current_user.email
      @phone = current_user.phone
      @images = []
      baseurl = "https://storage.googleapis.com/#{ENV.fetch("GCP_CLOUD_STORAGE_BUCKET")}/"

      completed = Photo.where(completed: 't', uid: @id)

      completed.each do |t|
        total_time = (t["fin_date"] - t["init_date"])/ 60
        @images.push({
          id: t["qid"],
          time: total_time.round(2),
          pre: "#{baseurl}#{t["original_path"]}",
          post: "#{baseurl}#{t["generated_path"]}"
        })
      end
    else
      # flash[:warning] = 'You must be logged in to see this page'
      # redirect_to '/login'
    end
  end

  def job
    time_now = Time.now
    bucket_name = ENV.fetch("GCP_CLOUD_STORAGE_BUCKET")
    pub_sub = ENV.fetch("GCP_CLOUD_PUB_SUB")
    uid = SecureRandom.hex(7)

    img = params["image"].read
    img_name = params["image"].original_filename
    ext = File.extname(img_name)
    uid_file = "#{uid}_org#{ext}"
    uid_path = File.join('/tmp', uid_file )

    upload_path = File.join('photonic', current_user.username, uid_file )

    File.open(uid_path,"wb") do |file|
      file.puts img
    end

    begin
      bucket = gcp_cloud_storage(bucket_name)
      file = bucket.create_file uid_path, upload_path
    rescue => exception
      puts "[ERROR] - uanble to upload to cloud storage with error: #{e}"
      flash.now[:warning] = 'Unable to upload your photos'
      redirect_to '/'
    end

    begin
    queue = gcp_pub_sub(pub_sub)
    que = queue.publish uid
    rescue => e
      puts "[ERROR] - uanble to pushlish with error: #{e}"
      flash.now[:warning] = 'Unable to publish to queue'
      redirect_to '/'
    end

    photo = Photo.new()
    photo.uuid = uid
    photo.username = current_user.username
    photo.uid = current_user.id
    #photo.generated_path = upload_path
    photo.original_path = upload_path
    photo.init_date = time_now
    photo.qid = que.message_id
    photo.completed = false

    if photo.save
      flash[:success] = "Successfully queued job with id: #{uid}"
    else
      flash[:warning] = 'Failed trying to update the database!'
    end
    redirect_to '/'
  end
end
