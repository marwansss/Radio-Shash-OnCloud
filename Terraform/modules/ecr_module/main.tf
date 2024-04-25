#Creating Amazon container registry
resource "aws_ecr_repository" "radioshash-repo" {
  name                 = "radioshash-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
   tags = {
    Name = "radioshash-repo"
  }
}