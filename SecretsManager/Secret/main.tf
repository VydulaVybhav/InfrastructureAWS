#Link: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret
resource "aws_secretsmanager_secret" "example" {
  name = "example"
  description = "description"
  kms_key_id = "kms_arn"
}