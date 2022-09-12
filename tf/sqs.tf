resource "aws_sqs_queue" "test_sqs_queue" {
  name = "test-sqs-queue"

  visibility_timeout_seconds = 120

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "sqspolicy",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "sqs:SendMessage",
        "Resource" : "arn:aws:sqs:*:*:test-sqs-queue",
        "Condition" : {
          "ArnEquals" : {
            "aws:SourceArn" : aws_s3_bucket.test_s3_sqs_bucket_com.arn
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket" "test_s3_sqs_bucket_com" {
  bucket        = "test-s3-sqs-bucket-com"
  force_destroy = true
}

# Add notification configuration to SQS Queue
resource "aws_s3_bucket_notification" "test_bucket_notification" {
  bucket = aws_s3_bucket.test_s3_sqs_bucket_com.id

  queue {
    queue_arn = aws_sqs_queue.test_sqs_queue.arn
    events    = ["s3:ObjectCreated:*"]
  }
}

resource "aws_lambda_event_source_mapping" "test_lambda_event_source_mapping" {
  event_source_arn = aws_sqs_queue.test_sqs_queue.arn
  enabled          = true
  function_name    = aws_lambda_function.test-lambda.arn
  batch_size       = 1
}
