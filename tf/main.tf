terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.1"
}

# variable "profile" {
#   default = "dev"
# }

provider "aws" {
  region = "us-east-1"
  # profile = var.profile
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "../src/main.py"
  output_path = "../target/lambda_payload.zip"
}

resource "aws_lambda_function" "test-lambda" {
  # If the file is not in the current working directory you will need to include a 
  # path.module in the filename.
  filename      = data.archive_file.lambda.output_path
  function_name = "test-lambda"
  role          = aws_iam_role.test-iam-lambda.arn
  handler       = "main.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256(data.archive_file.lambda.output_path)

  runtime     = "python3.9"
  memory_size = 128
  timeout     = 10
}

# resource "aws_lambda_permission" "allow_api" {
#   statement_id  = "AllowAPIgatewayInvocation"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.test-lambda.function_name
#   principal     = "apigateway.amazonaws.com"
#   # source_arn    = "arn:aws:events:eu-west-1:111122223333:rule/RunDaily"
#   # qualifier     = aws_lambda_alias.test_alias.name
# }

# resource "aws_api_gateway_rest_api" "test-api" {
#   name = "test-api"
#   endpoint_configuration {
#     types = ["REGIONAL"]
#   }
# }

# resource "aws_api_gateway_resource" "test-resource" {
#   rest_api_id = aws_api_gateway_rest_api.test-api.id
#   parent_id   = aws_api_gateway_rest_api.test-api.root_resource_id
#   path_part   = "person"
# }

# resource "aws_api_gateway_method" "post-method" {
#   rest_api_id   = aws_api_gateway_rest_api.test-api.id
#   resource_id   = aws_api_gateway_resource.test-resource.id
#   http_method   = "POST"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "post-integration" {
#   rest_api_id             = aws_api_gateway_rest_api.test-api.id
#   resource_id             = aws_api_gateway_resource.test-resource.id
#   http_method             = aws_api_gateway_method.post-method.http_method
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = aws_lambda_function.test-lambda.invoke_arn
# }

# resource "aws_api_gateway_method" "get-method" {
#   rest_api_id   = aws_api_gateway_rest_api.test-api.id
#   resource_id   = aws_api_gateway_resource.test-resource.id
#   http_method   = "GET"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "get-integration" {
#   rest_api_id             = aws_api_gateway_rest_api.test-api.id
#   resource_id             = aws_api_gateway_resource.test-resource.id
#   http_method             = aws_api_gateway_method.get-method.http_method
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = aws_lambda_function.test-lambda.invoke_arn
# }

# resource "aws_api_gateway_deployment" "test-deployment" {
#   rest_api_id = aws_api_gateway_rest_api.test-api.id

#   triggers = {
#     redeployment = sha1(jsonencode("${aws_api_gateway_rest_api.test-api.body}"))
#   }

#   depends_on = [
#     aws_api_gateway_integration.post-integration
#   ]
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_api_gateway_stage" "test-stage" {
#   deployment_id = aws_api_gateway_deployment.test-deployment.id
#   rest_api_id   = aws_api_gateway_rest_api.test-api.id
#   stage_name    = "dev"
# }

# output "invoke_arn" {
#   value = aws_api_gateway_deployment.test-deployment.invoke_url
# }
# output "stage_name" {
#   value = aws_api_gateway_stage.test-stage.stage_name
# }
# output "path_part" {
#   value = aws_api_gateway_resource.test-resource.path_part
# }
# output "url" {
#   value = "${aws_api_gateway_deployment.test-deployment.invoke_url}/${aws_api_gateway_stage.test-stage.stage_name}/${aws_api_gateway_resource.test-resource.path_part}"
# }
