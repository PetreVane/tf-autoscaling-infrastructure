provider "aws" {
  region                    = var.region
}


module "s3" {
  source = "./s3"
  bucket_name = "tf-bucket-07may24"
  jar_file_name = "dummy-webapp.jar"
  jar_file_path = "./s3/jar/dummy-webapp.jar"
}