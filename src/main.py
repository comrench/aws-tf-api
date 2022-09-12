import boto3

client = boto3.client('dynamodb')


def lambda_handler(event, context):
    print('starting lambda')
    data = client.put_item(
        TableName='myDB',
        Item={
            'id': {
                'S': '005'
            },
            'price': {
                'N': '500'
            },
            'name': {
                'S': 'Smarty'
            }
        }
    )

    # data = client.get_item(
    #     TableName='myDB',
    #     Key={
    #         'id': {
    #           'S': '005'
    #         }
    #     }
    #  )

    print('done lambda')
    print(data)

   #  response = {
   #      'statusCode': 200,
   #      'body': 'successfully created item!',
   #      'headers': {
   #          'Content-Type': 'application/json',
   #          'Access-Control-Allow-Origin': '*'
   #      },
   #  }

   #  return response
