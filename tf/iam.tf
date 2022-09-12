resource "aws_iam_role" "test-iam-lambda" {
  name = "iam_for_lambda"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_policy" "test-iam-policy" {
  name        = "test-iam-policy"
  description = "test-iam-policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : ["s3:GetObject", "s3:PutObject"],
        "Effect" : "Allow",
        "Resource" : ["${aws_s3_bucket.test_s3_sqs_bucket_com.arn}/*"]
      },
      {
        "Action" : ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"],
        "Effect" : "Allow",
        "Resource" : aws_sqs_queue.test_sqs_queue.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "test-iam-policy-attachment" {
  role       = aws_iam_role.test-iam-lambda.name
  policy_arn = aws_iam_policy.test-iam-policy.arn
}

