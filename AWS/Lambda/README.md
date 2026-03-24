S-1: Create one IAM role for lambda to Fullaccessdynamodb.
S-2: Create one S3 Bucket.
S-3: Create one DynamoDB table name should be "newtable" and Primery Key "unique" as mentioned in python code.
S-4: Create One lambda function (assign the IAM role and choose runtime in which code is written).
S-5: Mention the code, in code section of function and then deploy.
S-6: Create one trigger for S3 and choose created S3 bucket.
S-7: Put Object in S3 & Entry will trigger into Dynamodb newtable.