#Creating Amazon container registry
resource "aws_ecrpublic_repository" "radioshash-repo" {
  repository_name = "radioshash-repo"

  catalog_data {
    about_text        = "About Text"
    architectures     = ["ARM"]
    description       = "Description"
    operating_systems = ["Linux"]
    usage_text        = "Usage Text"
  }

  tags = {
    Name = "radioshash-repo"
  }
}