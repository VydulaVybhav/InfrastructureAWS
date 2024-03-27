# Link: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lakeformation_lf_tag
resource "aws_lakeformation_lf_tag" "example" {
  key    = "module"
  values = ["Orders", "Sales", "Customers"]
}