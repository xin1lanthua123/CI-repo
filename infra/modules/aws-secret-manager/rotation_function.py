# import json
# import boto3
# import pymysql
# import psycopg2
# def lambda_handler (event,context):
#     secretID = (event['SecretId'])
#     token = (event['ClientRequestToken'])
#     step  = (event['Step'])
#     client = boto3.client("secretsmanager")
#     metadata = client.describe_secret(SecretId=secretID)
#     if not metadata['RotationEnabled']:
#         raise ValueError("Secret {secretID} is not enabled for rotation")

#     if step == "createSecret":
#         createSecret(client, secretID, token)
#     elif step == "setSecret":
#         setSecret(client, secretID, token)
#     elif step == "testSecret":
#         testSecret(client, secretID, token)
#     elif step == "finishSecret":
#         finishSecret(client, secretID, token)
#     else:
#         raise ValueError("Unvalid parameters")

# def createSecret (client,secretID,token):
#     client.get_secret_value(SecretId=secretID,VersionStage="AWSCURRENT")
#     try:
#         client.get_secret_value(SecretId=secretID,VersionID=token, VersionStage="AWSPENDING")
#     except client.exceptions.ResourceNotFoundException:
#       print("A new secret hasn't been created yet so lets create a new one")
#       newSecret = client.get_random_password(ExcludeCharacters='/@"\'\\', PasswordLength=10)["RandomPassword"]
#       client.put_secret_value(
#         SecretId=secretID,
#         SecretString=newSecret,
#         VersionStages=['AWSPENDING']
#       )

# def setSecret (client,secretID,token):
#     pending_secret = client.get_secret_value(SecretId=secretID,
#     VersionID=token, 
#     VersionStage="AWSPENDING")["SecretString"]
#     print ("Setting the secret {pending_secret}")

# def testSecret (client,secretID,token):
#      # Lấy pending secret
#     pending_secret = client.get_secret_value(
#         SecretId=secretID,
#         VersionId=token,
#         VersionStage='AWSPENDING'
#     )['SecretString']

#     # TODO: Test với hệ thống thực tế
#     # Ví dụ MySQL:
#     try:
#         conn = psycopg2.connect(
#             host=secret['host'],
#             user=secret['username'],
#             password=secret['password'],
#             dbname=secret['dbname'],
#             port=secret.get('port', 5432),
#             connect_timeout=5
#         )
#         conn.close()
#         print("Pending secret test passed")
#     except Exception as e:
#         raise ValueError(f"Pending secret test failed: {e}")

# def finishSecret (client, secretID, token):
#     metadata =  client.describe_secret(SecretId=secretID)
#     for version_id,stages in metadata["VersionIdsToStages"].item():
#         if "AWSPENDING" in stages and version_id == token :
#             client.update_secret_version_stage(
#                 SecretId=secretID,
#                 VersionStage="AWSCURRENT",
#                 RemoveFromVersionId=none,
#                 MoveToVersionId=version_id
#             )
#         if "AWSCURRENT" in stages and version_id != token:
#             client.update_secret_version_stage(
#                 SecretId=secretID,
#                 VersionStage="AWSPREVIOUS",
#                 RemoveFromVersionId="AWSCURRENT",
#                 MoveToVersionId=version_id
#             )


    