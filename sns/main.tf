
// ssn topic for publishing failed lambda executions
resource "aws_sns_topic" "lambda_failures" {
  name = "lambda_failures"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.lambda_failures.arn
  protocol  = "email"
  endpoint  = var.notification_email // Email for notifications
}
