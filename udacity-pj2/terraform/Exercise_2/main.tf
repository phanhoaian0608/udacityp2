provider "aws" {
  access_key = "ASIAS2BBAJVXO2NLHOEL"
  secret_key = "kjDP1DkjM7hwe5rneQ53v+h0CKXFMNI+lL7tK9yB"
  token = "FwoGZXIvYXdzEIH//////////wEaDF6LCyxtC0L1jpXlFSLVAf+sh2fBc143y3EFd2AcLSJ9nEBvfyl30lEDmttQM4xy9+s4ZF+ULXoYIPVO4P2jE1UCbB66wiANNkVpVWMH0ojfahcxwGTUNjkTEj6AoJqGZpG6CHRse/56vJHHYC6aobCMdVFS9MaDlt8BetxDzXiEAqe+tKsfP2XHlmsyjJbAt5oN3qi0r4+xCFuS/p8N5gZgMAh43ggYOFJs2W3wroH4GAyVnFHGfNleUK9HmR3CXwgjQwQGSrTadtOpe9aXI1BF3YSByVJZS60fdn3fyF5sPaH9xyi+lIyhBjItJg3B1vn8yS00EwHBkOwNMFXNRGwwIBxsFriDBxv4SzHdsIJYIPG8El1yE4A2"
  region = "us-east-1"
}

provider "archive" {}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "greet_lambda.py"
  output_path = "greet_lambda.zip"
}


resource "aws_iam_role" "iam_lambda" {
  name = "iam_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "greet_lab" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = data.archive_file.zip.output_path
  function_name = "greet_lab"
  role          = aws_iam_role.iam_lambda.arn
  handler       = "greet_lab.lambda_handler"
  
  source_code_hash = data.archive_file.zip.output_base64sha256

  runtime = "python3.7"

  environment {
    variables = {
      greeting = "Greeting you"
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.lambda_loggroup,
  ]

}

resource "aws_cloudwatch_log_group" "lambda_loggroup" {
  name              = "/aws/lambda/greet_lab"
  retention_in_days = 7
}


resource "aws_iam_policy" "logging_for_lambda" {
  name        = "logging_for_lambda"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_lambda.name
  policy_arn = aws_iam_policy.logging_for_lambda.arn
}