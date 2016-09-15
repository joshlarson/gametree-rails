# GameTree

## Create Player

**Method**: `POST /players`

Required Attributes

 - `email`
 - `handle`: This gets used as the ID on upload to Braintree's Sandbox

### Example
**Method**: `POST`

**URI**: `/players`

**Payload**: `{"email": "foo@bar.com", "handle": "foobar"}`

## Find Player By Email

**Method**: `POST /players?email=<email>`

### Example
**Method**: `GET`

**Path**: `/players?email=foo@bar.com`

**Response**: `{"id": 45, "email": "foo@bar.com", "handle": "foobar"}`

## Find Player By ID
**Method**: `GET /players/<id>`

### Example
**Method**: `GET`

**Path**: `/players/45`

**Response**: `{"id": 45, "email": "foo@bar.com", "handle": "foobar"}`

## Get Game
**Method**: `GET /games/<game_id>`

### Example
**Method**: `GET`

**Path**: `/games/120`

**Response**: `{"id": 120, "score": 100, "status": "in progress", "cost": 45}`

## Create Game
**Method**: `POST /players/<player_id>/games`

## Update Games
### Score Points
**Method**: `POST /games/<game_id>/points {"points": <points>}`

### Add Charge to Game
**Method**: `POST /games/<game_id>/charge {"amount": <cost>}`

### Finish Game
**Method**: `POST /games/<game_id>/finish`

### Leaderboard
(In a browser)

**Method**: `GET /leaderboard`
