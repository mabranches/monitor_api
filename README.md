# Monitor API

An example api to hold information about a running machine such as:
* Memory
* Disk
* Load
* processes

This API was deployed at AWS using API Gateway [here](https://r91t8rksue.execute-api.us-west-2.amazonaws.com/prod/instances/usage).

## Running
##### Create Table
```shell 
bundle exec rake db:create_tables
```
##### start rails
```shell 
  bundle exec rails s
```
## Test
You need to run a local DynamoDB Instance.
##### DynamoDB Installation
```shell
sudo apt-get install openjdk-7-jre-headless -y
mkdir -p dynamodb
cd dynamodb
wget http://dynamodb-local.s3-website-us-west-2.amazonaws.com/dynamodb_local_latest
tar -xvzf dynamodb_local_latest
rm dynamodb_local_latest
```
##### Running DynamoDB
```shell
java -Djava.library.path=. -jar DynamoDBLocal.jar
```
##### Executing testes
  bundle exec rspec spec

