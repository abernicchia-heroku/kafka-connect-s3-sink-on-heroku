# kafka-connect-s3-sink-on-heroku
proof-of-concept of Kafka Connect with S3 sink running on Heroku

## Disclaimer
The author of this article makes any warranties about the completeness, reliability and accuracy of this information. **Any action you take upon the information of this website is strictly at your own risk**, and the author will not be liable for any losses and damages in connection with the use of the website and the information provided. **None of the items included in this repository form a part of the Heroku Services.**

## Quick Start

1. Locally, clone and deploy this repository to your Heroku app or click on the Heroku Button

    [![Deploy to Heroku](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

    ```shell
    git clone https://github.com/abernicchia-heroku/kafka-connect-s3-sink-on-heroku.git
    heroku git:remote --app HEROKU_APPNAME

    heroku config:set TRUSTSTORE_PASSWORD=<your password> -a HEROKU_APPNAME
    heroku config:set KEYSTORE_PASSWORD=<group ID e.g. connect-cluster4s3-id> -a HEROKU_APPNAME
    heroku config:set CONNECT_GROUP_ID=<group ID e.g. connect-cluster4s3-id> -a HEROKU_APPNAME
    heroku config:set CONNECT_CONFIG_STORAGE_TOPIC=<group ID e.g. connect-configs-cluster4s3> -a HEROKU_APPNAME 
    heroku config:set CONNECT_OFFSET_STORAGE_TOPIC=<group ID e.g. connect-offsets-cluster4s3> -a HEROKU_APPNAME
    heroku config:set CONNECT_STATUS_STORAGE_TOPIC=<group ID e.g. connect-status-cluster4s3> -a HEROKU_APPNAME
    heroku config:set AWS_ACCESS_KEY_ID=<your AWS access key> -a HEROKU_APPNAME
    heroku config:set AWS_SECRET_KEY=<your AWS secret key> -a HEROKU_APPNAME

    heroku apps:stacks:set --app HEROKU_APPNAME container
    git push heroku main
    ```

