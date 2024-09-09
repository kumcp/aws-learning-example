# aws-learning-example

Example and learning script for reference

These project include:

-   Shell script helpers for running as bootstrap for fast building EC2.
-   Script for some functions in Lambda
-   Some common policy in S3

Remove and delete all bucket in S3:
```
aws s3 ls | cut -d" " -f 3 | xargs -I{} aws s3 rb s3://{} --force
```
