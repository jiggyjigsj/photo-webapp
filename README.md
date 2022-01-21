# photo-webapp
Ruby on rails webapp for Photos

docker build . -t photos
docker run --rm --it photos

source .env && rails generate model user username:string:uniq email:string phone:string name:string password_digest:string --skip-collision-check
