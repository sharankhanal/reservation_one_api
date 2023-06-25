# Reservation API

This is an API for reservation, supporting multiple payloads according tp partner requirement. The application is built using folowing technologies


* Ruby version : 3.2.1
* Rails version : 7.0.4
* SQLite: 1.4

## How to run this app?

### 1. Using Docker
Open the project root directory and run the following command to build the docker image with the tag reservation_one_api in the terminal of your choice.
```
docker build -t reservation_one_api .
```
This may take some time for the first time as it downloads the required image for building container followed by series of commands.

After the container is built, run the below command to run the reservation API app. 

```
docker run -p 3000:3000 reservation_one_api
```
Here, default port 3000 of host is used to map the port of the container running in docker. If port 3000 is already occupied, please specify any other port and run the command as:
```
docker run -p <custom_port>:3000 reservation_one_api
```
Replace custom_port with any port available in the system.

Once the app runs successfully, open the your browsers and enther the url as localhost:3000 or with your custom port used while running the docker container for the app.


### 2. Using Development Environment
Configure your terminal to use ruby version 3.2.1 and be in the root of the project directory. Run following commands

```
gem install bundler
bundle install
```

To create the database if not present, run the following command followed by migration.
```
rails db:create db:migrate
```

To boot up the application, run the following command to start the rails server

```
rails s
```
The default port used is 3000 and if the port is not available specify the port while booting up as in below:

```
rails s -p <custom_port>
```

Once the app boots up successfully, open browser and enter the url as localhost:3000 or with your custom port specified.

## API Endpoint
This API currently support one API endpoint to create/update the reservation.
The request is of type '*post*' and expect the body to be in json format.

Following is the path for the API.
```
<base_url>/reserve
```
If the app is running locally in localhost with port 3000 then the URL will be
```
http://localhost:3000/reserve
```
Currently, this application supports two partner and each partner has different payload for resrevation.

Below is the sample data for JSON Payload for Partner One.

### Sample 1

```
{
"reservation_code": "YYY12345678",
"start_date": "2021-04-14",
"end_date": "2021-04-18",
"nights": 4,
"guests": 4,
"adults": 2,
"children": 2,
"infants": 0,
"status": "accepted",
"guest": {
"first_name": "Wayne",
"last_name": "Woodbridge",
"phone": "639123456789",
"email": "wayne_woodbridge@test.com"
},
"currency": "AUD",
"payout_price": "4200.00",
"security_price": "500",
"total_price": "4700.00"
}
```
Below is the sample data for JSON Payload for Partner Two.
### Sample 2

```
{
"reservation": {
"code": "XXX12345678",
"start_date": "2021-03-12",
"end_date": "2021-03-16",
"expected_payout_amount": "3800.00",
"guest_details": {
"localized_description": "4 guests",
"number_of_adults": 2,
"number_of_children": 2,
"number_of_infants": 0
},
"guest_email": "wayne_woodbridge@test.com",
"guest_first_name": "Wayne",
"guest_last_name": "Woodbridge",
"guest_phone_numbers": [
"639123456789",
"639123456789"
],
"listing_security_price_accurate": "500.00",
"host_currency": "AUD",
"nights": 4,
"number_of_guests": 4,
"status_type": "accepted",
"total_paid_amount_accurate": "4300.00"
}
}
```

To test the API from your terminal, please install *curl* and use the below command:

```
curl --location 'localhost:3000/reserve' \
--header 'Content-Type: application/json' \
--data-raw '{
"reservation_code": "",
"start_date": "2021-04-14",
"end_date": "2021-04-18",
"nights": 4,
"guests": 4,
"adults": 2,
"children": 2,
"infants": 0,
"status": "accepted",
"guest": {
"first_name": "Wayne",
"last_name": "Woodbridge",
"phone": "639123456789",
"email": "wayne_woodbridge@test.com"
},
"currency": "AUD",
"payout_price": "4200.00",
"security_price": "500",
"total_price": "4700.00"
}'
```

If the API request succeeds, it will respond with status 200 and the message as

```
{
  'success': true
}
```

If the API request fails, it will respond with status 403 and the message as

```
{
  'message': 'Error message'
}
```

## How to support additional partner payload?
To support new partner's json schema by the API, add the JSON schema of the payload for the partner specifiying partner id in the field 'id' of the schema.

Here is the example of schema with id for partner on as 'partner_one' :
```
{
  "id": "https://example.com/schemas/partner_one"
}
```

Put the schema file inside below path:

'*app/schemas/reservations/*'.


The parser tries to parse the json schema and find the partner id from the schema's 'id' field when matches with any schema stored in the directory.

The partner id determined is checked in the registry. Registry is entries where parser for partner are registered.

For example, for reservation, following registry is considered:

```
ReservationParserRegistry
```
Do not forget to add to the registry since there is check to find wether the parser for specific partner is registered or not. This helps to prevent any failure if no parser is added for specific partner's payload schema.

Thats all, you can add as many partner schemas in the directory and parser to prepare data for creating and updating the reservation. 
## How to run the test?
The test specs are written using RSpec and to run the test,

first run the migration
```
rails db:drop db:create db:migrate RAILS_ENV=test
```
then run the test as below
```
rspec spec
```
This will run all the test specs added inside the spec folder.

## Note
This repository is created for the evaluation purpose and may not be available later.

