# Link: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_connection
# A non-custom connection 
resource "aws_glue_connection" "example" {
  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:mysql://${aws_rds_cluster.example.endpoint}/exampledatabase"
    SECRET_ID           = data.aws_secretmanager_secret.example.name
  }

  name = "example"

  physical_connection_requirements {
    availability_zone      = aws_subnet.example.availability_zone
    security_group_id_list = [aws_security_group.example.id]
    subnet_id              = aws_subnet.example.id
  }
}

#A custom connector and connection
# Define the custom connector using the connection_type of `CUSTOM` with the match_criteria of `template_connection`
# Example here being a snowflake jdbc connector with a secret having user and password as keys

data "aws_secretmanager_secret" "example" {
  name = "example-secret"
}

resource "aws_glue_connection" "example_connector" {
  connection_type = "CUSTOM"

  connection_properties = {
    CONNECTOR_CLASS_NAME = "net.snowflake.client.jdbc.SnowflakeDriver"
    CONNECTION_TYPE      = "Jdbc"
    CONNECTOR_URL        = "s3://example/snowflake-jdbc.jar" # S3 path to the snowflake jdbc jar
    JDBC_CONNECTION_URL  = "[[\"default=jdbc❄//example.com/?user=$${user}&password=$${password}\"],\",\"]"
  }

  name = "example_connector"

  match_criteria = ["template-connection"]
}

# Reference the connector using match_criteria with the connector created above.

resource "aws_glue_connection" "example_connection" {
  connection_type = "CUSTOM"

  connection_properties = {
    CONNECTOR_CLASS_NAME = "net.snowflake.client.jdbc.SnowflakeDriver"
    CONNECTION_TYPE      = "Jdbc"
    CONNECTOR_URL        = "s3://example/snowflake-jdbc.jar"
    JDBC_CONNECTION_URL  = "jdbc❄//example.com/?user=$${user}&password=$${password}"
    SECRET_ID            = data.aws_secretmanager_secret.example.name
  }
  name           = "example"
  match_criteria = ["Connection", aws_glue_connection.example_connector.name]
}