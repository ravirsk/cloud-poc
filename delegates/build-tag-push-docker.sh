docker build -t ssc-terraform-delegate:latest . #from dir where Docker file exists
docker tag ssc-terraform-delegate:2.0 ravindrakadam/terraform-delegate:2.0
docker push ravindrakadam/terraform-delegate:2.0
docker pull ravindrakadam/terraform-delegate:2.0