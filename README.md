# Reservation API

This repo demonstrates how to create a reservation import API using Ruby on Rails.
The problem is, we need to have a single API that can consume different kinds of payload from different partners.
Therefore, I use _Form Object Pattern_ and _Polymorphism_ to approach the solution

**Payload #1**
```console
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
    "email": "wayne_woodbridge@bnb.com"
  },
  "currency": "AUD",
  "payout_price": "4200.00",
  "security_price": "500",
  "total_price": "4700.00"
}
```

**Payload #2**
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
}
```

We want to have them stored into Reservation and Guest tables.

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

**Payload #1**
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

**Payload #2**
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

## Manual Testing
**Payload #1 case**

Got 200 response and successfully saved in the DB
![Screenshot from 2022-01-25 17-17-31](https://user-images.githubusercontent.com/42140237/150976358-ef04dc37-b75c-4f04-962c-eed2134958d5.png)

**Payload #2 case (after Payload #1 done)**

Got 200 response and successfully saved in the DB
![Screenshot from 2022-01-25 17-21-28](https://user-images.githubusercontent.com/42140237/150976507-6f51c0c1-b640-4508-b6e7-38ffe7c6837b.png)

Saved data in DB:
```console
2.4.10 :005 > Reservation.all
  Reservation Load (0.7ms)  SELECT "reservations".* FROM "reservations"
 => #<ActiveRecord::Relation [#<Reservation id: 1, code: "YYY12345678", guest_id: 1, guest_phone: "[\"639123456789\"]", start_date: "2021-04-14", end_date: "2021-04-18", num_of_adults: 2, num_of_children: 2, num_of_infants: 0, status: "accepted", currency: "AUD", payout_price: 4200.0, security_price: 500.0, total_price: 4700.0, created_at: "2022-01-25 10:10:13", updated_at: "2022-01-25 10:10:13">, #<Reservation id: 2, code: "XXX12345678", guest_id: 1, guest_phone: "[\"639123456789\"]", start_date: "2021-03-12", end_date: "2021-03-16", num_of_adults: 2, num_of_children: 2, num_of_infants: 0, status: "accepted", currency: "AUD", payout_price: 3800.0, security_price: 500.0, total_price: 4300.0, created_at: "2022-01-25 10:10:13", updated_at: "2022-01-25 10:10:13">]> 
2.4.10 :006 > Guest.all
```

```console
  Guest Load (0.4ms)  SELECT "guests".* FROM "guests"
 => #<ActiveRecord::Relation [#<Guest id: 1, first_name: "Wayne", last_name: "Woodbridge", phone: "[\"639123456789\", \"639123456789\"]", email: "wayne_woodbridge@bnb.com", created_at: "2022-01-25 10:10:13", updated_at: "2022-01-25 10:21:04">]>
```

We can see that we got 2 reservations and only 1 guests as we keep the guest email unique.

**Invalid payload case**

Got 422 response

![image](https://user-images.githubusercontent.com/42140237/150976849-eece37e0-1507-46d7-9c34-60ded2477b7c.png)
