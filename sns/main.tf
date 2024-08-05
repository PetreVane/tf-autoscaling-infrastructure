
// ssn topic for publishing failed lambda executions
resource "aws_sns_topic" "lambda_execution_results" {
  name = "lambda_execution_results"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.lambda_execution_results.arn
  protocol  = "email"
  endpoint  = var.notification_email // Email for notifications
}
