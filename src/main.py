"""Python AWS Lambda Hello World Example
   This example Lambda function will simply return 'Hello from Lambda!' and
   a HTTP Status Code 200.
"""

import json


def lambda_handler(event, context):
    print("Starting Lambda")
    print(event)
    # return {
    #     'statusCode': 200,
    #     'body': json.dumps(event)
    # }
