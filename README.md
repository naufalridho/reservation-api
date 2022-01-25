# Reservation API

## Project Setup

**Install all gems**:

```console
$ bundle install
```

**Update the database with new data model**:

```console
$ rake db:migrate
```

**Start the web server on `http://localhost:3000` by default**:

```console
$ rails server
```

**Run all RSpec tests and Rubocop**:

```console
$ rake test
```

## Endpoints

| HTTP verbs | Paths  | Used for |
| ---------- | ------ | --------:|
| PUT | /reservations/import| Imports a new reservation |

We used PUT to enable changing of fields
```markdown
The PUT method requests that the enclosed entity be stored under the supplied Request-URI. 
If the Request-URI refers to an already existing resource, the enclosed entity SHOULD be 
considered as a modified version of the one residing on the origin server. 
If the Request-URI does not point to an existing resource, and that URI is capable 
of being defined as a new resource by the requesting user agent, the origin server 
can create the resource with that URI.
```

Therefore I think PUT method can "mimic" upsert operation that is suitable for this case

## Use Case Examples

**cURL**:

1. Payload #1
```console
$ curl --request PUT \
    --url http://127.0.0.1:3000/reservations/import \
    --header 'Authorization: Basic c2lldmU6U2kzdmVfRDNwcmVjYXQzRF9MMGg=' \
    --header 'Content-Type: application/json' \
    --data '{
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
      "email": "wayne_woodbridge@bnb.com"
    },
    "currency": "AUD",
    "payout_price": "4200.00",
    "security_price": "500",
    "total_price": "4700.00"
  }'
```

2. Payload #2
```console
$ curl --request PUT \
    --url http://127.0.0.1:3000/reservations/import \
    --header 'Authorization: Basic c2lldmU6U2kzdmVfRDNwcmVjYXQzRF9MMGg=' \
    --header 'Content-Type: application/json' \
    --data '{
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
  		"guest_email": "wayne_woodbridge@bnb.com",
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
  }'
```
