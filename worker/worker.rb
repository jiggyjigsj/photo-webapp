require 'google/cloud/pubsub'
require "google/cloud/storage"
require 'pg'
require 'mini_magick'

def db_connection()
  options = {
    host: ENV.fetch("RAILS_DB_HOST"),
    port: ENV.fetch("RAILS_DB_PORT"),
    dbname: ENV.fetch("RAILS_DB"),
    user: ENV.fetch("RAILS_DB_USERNAME"),
    password: ENV.fetch("RAILS_DB_PASSWORD")
  }
  begin
    conn = PG::Connection.open(options)
  rescue => e
    raise "Failed to connected with: #{e}"
  end
end

def gcp_pub_sub(topic)
  begin
    pubsub = Google::Cloud::PubSub.new(
      project_id: ENV.fetch("GCP_PROJECT_ID"),
      credentials: ENV.fetch("GCP_CREDENTIALS_FILE")
    )
    pubsub.topic topic
  rescue => e
    raise "Looks like your bucket doesn't exists or your credentials are wrong!"
  end
end

def gcp_cloud_storage(bucket)
  begin
    storage = Google::Cloud::Storage.new(
      project_id: ENV.fetch("GCP_PROJECT_ID"),
      credentials: ENV.fetch("GCP_CREDENTIALS_FILE")
    )
    storage.bucket bucket
  rescue => e
    raise "Looks like your bucket doesn't exists or your credentials are wrong!"
  end
end

def main

  queue = gcp_pub_sub('photonic')

  subs = queue.subscription 'photonic-sub'

  subscriber = subs.listen do |received_message|
    # process message
    bucket_name = ENV.fetch("GCP_CLOUD_STORAGE_BUCKET")
    uuid = received_message.message.data
    puts "Starting Data: #{uuid}, published at #{received_message.message.published_at}"
    psql = db_connection
    results = psql.exec("SELECT * from photos WHERE uuid = '#{uuid}'")
    job = results[0]

    bucket = gcp_cloud_storage(bucket_name)
    # TODO: Fix with correct db entry
    file = bucket.file job["original_path"]

    file_name = "worker/temp/#{File.basename(file.name)}"
    new_file_name = "#{uuid}_gen#{File.extname(file.name)}"
    new_file_path = "#{File.dirname(file.name)}/#{new_file_name}"
    local_write = "./worker/generated/#{new_file_name}"

    file.download file_name

    img = MiniMagick::Image.new(file_name)
    img.colorspace('gray')
    img.combine_options do |c|
      c.gravity 'SouthEast'
      c.draw 'image Over 0,0 0,0 "worker/jiggy_logo.gif"'
    end

    img.write(local_write)

    file = bucket.create_file local_write, new_file_path
    psql.exec("UPDATE photos SET generated_path = '#{new_file_path}', fin_date = '#{Time.now}', completed = 't' WHERE uuid = '#{uuid}'")

    File.delete(file_name) if File.exist?(file_name)
    File.delete(local_write) if File.exist?(local_write)

    psql.close
    received_message.acknowledge!

    puts "Finished processing: #{uuid}"

  end

  # Handle exceptions from listener
  subscriber.on_error do |exception|
    puts "Exception: #{exception.class} #{exception.message}"
  end

  # Gracefully shut down the subscriber on program exit, blocking until
  # all received messages have been processed or 10 seconds have passed
  at_exit do
    subscriber.stop!(10)
  end

  # Start background threads that will call the block passed to listen.
  subscriber.start

  # Block, letting processing threads continue in the background
  sleep 10
end

loop do
  main()
  puts "Sleeping for a bit!"
  sleep  30
end
