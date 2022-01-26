# photo-webapp
Ruby on rails webapp for Photos

docker build . -t photos
docker run --rm --it photos

source .env && rails generate model user username:string:uniq email:string phone:string name:string password_digest:string --skip-collision-check
source .env && rails generate model photos uuid:string:uniq username:string uid:integer generated_path:string original_path:string init_date:timestamp fin_date:timestamp qid:string completed:boolean --skip-collision-check

## GCP

1. Create a Service Account with Access to the following entities:

    1. Create a Role with Read and Write permissions to Cloud Storage
    1. Visit: https://console.cloud.google.com/iam-admin/roles/

        ```text
        storage.buckets.get
        storage.buckets.list
        storage.buckets.update
        ```

    1. Create a Service account and assign to Role.
    1. Visit: https://console.cloud.google.com/iam-admin/serviceaccounts
    1. TODO: Add additional access
