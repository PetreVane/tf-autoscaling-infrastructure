resource "random_id" "generator" {
  byte_length = 4
}

resource "aws_ssm_document" "tf_ssm_document" {
  name          = "tf_ssm_document_shell_script-${random_id.generator.hex}"
  document_type = "Command"
  content       = <<DOCUMENT
{
  "schemaVersion": "2.2",
  "description": "Run a shell script on EC2 instance",
  "mainSteps": [{
    "action": "aws:runShellScript",
    "name": "runShellScript",
    "inputs": {
      "runCommand": [
        "echo 'Hello, this is a test execution'"
      ]
    }
  }]
}
DOCUMENT
}
