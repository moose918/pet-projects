<!-- Generator: Widdershins v4.0.1 -->

<h1 id="db-api">DB API v2.12.0</h1>

> Scroll down for code samples, example requests and responses. Select a language for code samples from the tabs above or the mobile navigation menu.

Any requests containing a request body need to be made according to the template.
The `signal` property is not mandatory, but as it is used as a workaround for the frontend to the user.

Base URLs:

* <a href="https://tournament-server.herokuapp.com/api/v2/">https://tournament-server.herokuapp.com/api/v2/</a>

<h1 id="db-api-miscellaneous">Miscellaneous</h1>

## get-https:--tournament-server.herokuapp.com

<a id="opIdget-https:--tournament-server.herokuapp.com"></a>

> Code samples

`GET /`

*The API documentation*

<h3 id="get-https:--tournament-server.herokuapp.com-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Retrieves the API documentation|None|

<aside class="success">
This operation does not require authentication
</aside>

<h1 id="db-api-user">User</h1>

## get-https:--tournament-server.herokuapp.com-api-v2-user

<a id="opIdget-https:--tournament-server.herokuapp.com-api-v2-user"></a>

> Code samples

`GET /user`

*Retrieves all users*

Retrieves all users from the database

> Example responses

> 200 Response

```json
{
  "status": "Successfully recorded the match",
  "message": "The match has been recorded successfully",
  "resultData": [
    {
      "USER_ID": "0fbe7dd3-20b4-400a-ad28-53d86dd36cd2",
      "USER_FNAME": "Michael",
      "USER_LNAME": "Le Forestier",
      "USERNAME": "MikeyMike",
      "USER_EMAIL": "2322970@students.wits.ac.za",
      "USER_PASSWD": "hockey",
      "USER_IS_ADMIN": false,
      "USER_NOTIFICATIONS": true,
      "USER_DP": "https://i.imgur.com/rrJxe8N.jpg",
      "USER_DESCRIPTION": "Young and upcoming online mini gamer"
    }
  ]
}
```

<h3 id="get-https:--tournament-server.herokuapp.com-api-v2-user-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|An array of user obejcts|Inline|
|502|[Bad Gateway](https://tools.ietf.org/html/rfc7231#section-6.6.3)|Failed|Inline|

<h3 id="get-https:--tournament-server.herokuapp.com-api-v2-user-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» resultData|[object]|false|none|none|
|»» USER_ID|string|false|none|none|
|»» USER_FNAME|string|false|none|none|
|»» USER_LNAME|string|false|none|none|
|»» USERNAME|string|false|none|none|
|»» USER_EMAIL|string|false|none|none|
|»» USER_PASSWD|string|false|none|none|
|»» USER_IS_ADMIN|boolean|false|none|none|
|»» USER_NOTIFICATIONS|boolean|false|none|none|
|»» USER_DP|string|false|none|none|
|»» USER_DESCRIPTION|string|false|none|none|

Status Code **502**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» logError|string|false|none|none|

<aside class="success">
This operation does not require authentication
</aside>

## put-https:--tournament-server.herokuapp.com-api-v2-user

<a id="opIdput-https:--tournament-server.herokuapp.com-api-v2-user"></a>

> Code samples

`PUT /user`

*User signup*

Inserts the user into the database

> Body parameter

```json
{
  "data": {
    "fName": "Michael",
    "lName": "Le Forestier",
    "username": "MikeyMike",
    "userEmail": "2322970@students.wits.ac.za",
    "userPass": "hockey",
    "isAdmin": false,
    "wantsNotifications": true,
    "userDP": "https://i.imgur.com/rrJxe8N.jpg",
    "userDescription": "Young and upcoming online mini gamer"
  },
  "signal": {}
}
```

<h3 id="put-https:--tournament-server.herokuapp.com-api-v2-user-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» data|body|object|false|none|
|»» fName|body|string|false|none|
|»» lName|body|string|false|none|
|»» username|body|string|false|none|
|»» userEmail|body|string|false|none|
|»» userPass|body|string|false|none|
|»» isAdmin|body|boolean|false|none|
|»» wantsNotifications|body|boolean|false|none|
|»» userDP|body|string|false|none|
|»» userDescription|body|string|false|none|
|» signal|body|object|false|none|

> Example responses

> 201 Response

```json
{
  "status": "Successfully recorded the match",
  "message": "The match has been recorded successfully",
  "resultData": {
    "USER_ID": "0fbe7dd3-20b4-400a-ad28-53d86dd36cd2",
    "USER_FNAME": "Michael",
    "USER_LNAME": "Le Forestier",
    "USERNAME": "MikeyMike",
    "USER_EMAIL": "2322970@students.wits.ac.za",
    "USER_PASSWD": "hockey",
    "USER_IS_ADMIN": false,
    "USER_NOTIFICATIONS": true,
    "USER_DP": "https://i.imgur.com/rrJxe8N.jpg",
    "USER_DESCRIPTION": "Young and upcoming online mini gamer"
  }
}
```

<h3 id="put-https:--tournament-server.herokuapp.com-api-v2-user-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|201|[Created](https://tools.ietf.org/html/rfc7231#section-6.3.2)|The newly created user is retrieved from the database|Inline|
|502|[Bad Gateway](https://tools.ietf.org/html/rfc7231#section-6.6.3)|Failed|Inline|

<h3 id="put-https:--tournament-server.herokuapp.com-api-v2-user-responseschema">Response Schema</h3>

Status Code **201**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» resultData|object|false|none|none|
|»» USER_ID|string|false|none|none|
|»» USER_FNAME|string|false|none|none|
|»» USER_LNAME|string|false|none|none|
|»» USERNAME|string|false|none|none|
|»» USER_EMAIL|string|false|none|none|
|»» USER_PASSWD|string|false|none|none|
|»» USER_IS_ADMIN|boolean|false|none|none|
|»» USER_NOTIFICATIONS|boolean|false|none|none|
|»» USER_DP|string|false|none|none|
|»» USER_DESCRIPTION|string|false|none|none|

Status Code **502**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» logError|string|false|none|none|

<aside class="success">
This operation does not require authentication
</aside>

## post-https:--tournament-server.herokuapp.com-api-v2-user

<a id="opIdpost-https:--tournament-server.herokuapp.com-api-v2-user"></a>

> Code samples

`POST /user`

*User logs in*

User makes an attempt to login

> Body parameter

```json
{
  "data": {
    "username_email": "MikeyMike",
    "passwd": "hockey"
  },
  "signal": {}
}
```

<h3 id="post-https:--tournament-server.herokuapp.com-api-v2-user-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» data|body|object|false|none|
|»» username_email|body|string|false|none|
|»» passwd|body|string|false|none|
|» signal|body|object|false|none|

> Example responses

> 200 Response

```json
{
  "status": "success",
  "message": "User retrieved",
  "resultData": {
    "USER_ID": "0fbe7dd3-20b4-400a-ad28-53d86dd36cd2",
    "USER_FNAME": "Michael",
    "USER_LNAME": "Le Forestier",
    "USERNAME": "MikeyMike",
    "USER_EMAIL": "2322970@students.wits.ac.za",
    "USER_PASSWD": "hockey",
    "USER_IS_ADMIN": false,
    "USER_NOTIFICATIONS": true,
    "USER_DP": "https://i.imgur.com/rrJxe8N.jpg",
    "USER_DESCRIPTION": "Young and upcoming online mini gamer"
  }
}
```

<h3 id="post-https:--tournament-server.herokuapp.com-api-v2-user-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|The user object is retrieved|Inline|
|502|[Bad Gateway](https://tools.ietf.org/html/rfc7231#section-6.6.3)|Failed|Inline|

<h3 id="post-https:--tournament-server.herokuapp.com-api-v2-user-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» resultData|object|false|none|none|
|»» USER_ID|string|false|none|none|
|»» USER_FNAME|string|false|none|none|
|»» USER_LNAME|string|false|none|none|
|»» USERNAME|string|false|none|none|
|»» USER_EMAIL|string|false|none|none|
|»» USER_PASSWD|string|false|none|none|
|»» USER_IS_ADMIN|boolean|false|none|none|
|»» USER_NOTIFICATIONS|boolean|false|none|none|
|»» USER_DP|string|false|none|none|
|»» USER_DESCRIPTION|string|false|none|none|

Status Code **502**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» logError|string|false|none|none|

<aside class="success">
This operation does not require authentication
</aside>

## post-https:--tournament-server.herokuapp.com-api-v2-user-signupCheck

<a id="opIdpost-https:--tournament-server.herokuapp.com-api-v2-user-signupCheck"></a>

> Code samples

`POST /user/signupCheck`

*Check duplicate username*

Checks if the user can sign up with the given username

> Body parameter

```json
{
  "data": {
    "username": "Kixn"
  },
  "signal": {}
}
```

<h3 id="post-https:--tournament-server.herokuapp.com-api-v2-user-signupcheck-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» data|body|object|false|none|
|»» username|body|string|false|none|
|» signal|body|object|false|none|

> Example responses

> 202 Response

```json
{
  "status": "Success",
  "message": "You may use this username",
  "resultData": null
}
```

<h3 id="post-https:--tournament-server.herokuapp.com-api-v2-user-signupcheck-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|202|[Accepted](https://tools.ietf.org/html/rfc7231#section-6.3.3)|Accepted|Inline|
|400|[Bad Request](https://tools.ietf.org/html/rfc7231#section-6.5.1)|Bad request|Inline|
|502|[Bad Gateway](https://tools.ietf.org/html/rfc7231#section-6.6.3)|Failed|Inline|

<h3 id="post-https:--tournament-server.herokuapp.com-api-v2-user-signupcheck-responseschema">Response Schema</h3>

Status Code **202**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» resultData|string|false|none|none|

Status Code **400**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» resultData|string|false|none|none|

Status Code **502**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» logError|string|false|none|none|

<aside class="success">
This operation does not require authentication
</aside>

<h1 id="db-api-profile">Profile</h1>

## post-https:--tournament-server.herokuapp.com-api-v2-profile

<a id="opIdpost-https:--tournament-server.herokuapp.com-api-v2-profile"></a>

> Code samples

`POST /profile`

*Gets the user's profile*

Retrieves the user's profile information

> Body parameter

```json
{
  "data": {
    "userID": "0fbe7dd3-20b4-400a-ad28-53d86dd36cd2"
  },
  "signal": {}
}
```

<h3 id="post-https:--tournament-server.herokuapp.com-api-v2-profile-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» data|body|object|false|none|
|»» userID|body|string|false|none|
|» signal|body|object|false|none|

> Example responses

> 200 Response

```json
{
  "status": "success",
  "message": "User profile retrieved successfully",
  "resultData": {
    "userID": "0fbe7dd3-20b4-400a-ad28-53d86dd36cd2",
    "username": "MikeyMike",
    "fullName": "Michael Le Forestier",
    "topAgentTournament": "Tic-Tac-Toe-Tourney",
    "topAgentID": "f64da681-86c9-4b68-a266-7ae4b8668449",
    "topAgentELO": 610,
    "numAgents": 2
  }
}
```

<h3 id="post-https:--tournament-server.herokuapp.com-api-v2-profile-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|The user profile is retrieved|Inline|
|502|[Bad Gateway](https://tools.ietf.org/html/rfc7231#section-6.6.3)|Failed|Inline|

<h3 id="post-https:--tournament-server.herokuapp.com-api-v2-profile-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» resultData|object|false|none|none|
|»» userID|string|false|none|none|
|»» username|string|false|none|none|
|»» fullName|string|false|none|none|
|»» topAgentTournament|string|false|none|none|
|»» topAgentID|string|false|none|none|
|»» topAgentELO|integer|false|none|none|
|»» numAgents|integer|false|none|none|

Status Code **502**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» logError|string|false|none|none|

<aside class="success">
This operation does not require authentication
</aside>

<h1 id="db-api-agent">Agent</h1>

## put-https:--tournament-server.herokuapp.com-api-v2-agent

<a id="opIdput-https:--tournament-server.herokuapp.com-api-v2-agent"></a>

> Code samples

`PUT /agent`

*Inserts the user's agent*

Inserts the agent into the database. `agentName` can be left as an empty string, this will cause the agent name to be the same as the username.

> Body parameter

```json
{
  "data": {
    "agentName": "myAgent",
    "userID": "0fbe7dd3-20b4-400a-ad28-53d86dd36cd2",
    "tournamentID": "e9e26b2a-c6f5-11ec-a02e-0ab3cd6d5505",
    "ipAddress": "192.168.0.0.1",
    "portNum": 8000
  },
  "signal": {}
}
```

<h3 id="put-https:--tournament-server.herokuapp.com-api-v2-agent-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» data|body|object|false|none|
|»» agentName|body|string|false|none|
|»» userID|body|string|false|none|
|»» tournamentID|body|string|false|none|
|»» ipAddress|body|string|false|none|
|»» portNum|body|integer|false|none|
|» signal|body|object|false|none|

> Example responses

> 201 Response

```json
{
  "status": "success",
  "message": "The user's agent has been inserted successfully",
  "resultData": {
    "AGENT_ID": "37729ba7-b6ec-4d41-aa04-e8d9a4bc19e6",
    "AGENT_NAME": "myAgent",
    "ADDRESS_IP": "string",
    "ADDRESS_PORT": 5838,
    "TOURNAMENT_ID": "01934c61-c6f6-11ec-a02e-0ab3cd6d5505",
    "AGENT_ELO": 600,
    "AGENT_STATUS": -1
  }
}
```

<h3 id="put-https:--tournament-server.herokuapp.com-api-v2-agent-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|201|[Created](https://tools.ietf.org/html/rfc7231#section-6.3.2)|- The created agent is returned
- `AGENT_STATUS` -> -1:offline, 0:inactive, 1:active|Inline|
|502|[Bad Gateway](https://tools.ietf.org/html/rfc7231#section-6.6.3)|Failed|Inline|

<h3 id="put-https:--tournament-server.herokuapp.com-api-v2-agent-responseschema">Response Schema</h3>

Status Code **201**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» resultData|object|false|none|none|
|»» AGENT_ID|string|false|none|none|
|»» AGENT_NAME|string|false|none|none|
|»» ADDRESS_IP|string|false|none|none|
|»» ADDRESS_PORT|integer|false|none|none|
|»» TOURNAMENT_ID|string|false|none|none|
|»» AGENT_ELO|float|false|none|none|
|»» AGENT_STATUS|integer|false|none|none|

Status Code **502**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» logError|string|false|none|none|

<aside class="success">
This operation does not require authentication
</aside>

## post-https:--tournament-server.herokuapp.com-api-v2-agent

<a id="opIdpost-https:--tournament-server.herokuapp.com-api-v2-agent"></a>

> Code samples

`POST /agent`

*Retrieve user' agents*

Retrieves the given user's agents from the database

> Body parameter

```json
{
  "data": {
    "userID": "0fbe7dd3-20b4-400a-ad28-53d86dd36cd2"
  },
  "signal": {}
}
```

<h3 id="post-https:--tournament-server.herokuapp.com-api-v2-agent-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» data|body|object|false|none|
|»» userID|body|string|false|none|
|» signal|body|object|false|none|

> Example responses

> 200 Response

```json
{
  "status": "success",
  "message": "The user's agents have been retrieved successfully",
  "resultData": [
    {
      "AGENT_ID": "f64da681-86c9-4b68-a266-7ae4b8668449",
      "AGENT_NAME": "string",
      "GAME_NAME": "Tic-Tac-Toe",
      "USERNAME": "MikeyMike",
      "AGENT_ELO": 610,
      "AVERAGE_RANKING": 0.4,
      "AGENT_STATUS": -1
    }
  ]
}
```

<h3 id="post-https:--tournament-server.herokuapp.com-api-v2-agent-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|- An array of the user's agent objects is returned.
- `AGENT_STATUS` -> -1:offline, 0:inactive, 1:active|Inline|
|502|[Bad Gateway](https://tools.ietf.org/html/rfc7231#section-6.6.3)|Failed|Inline|

<h3 id="post-https:--tournament-server.herokuapp.com-api-v2-agent-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» resultData|[object]|false|none|none|
|»» AGENT_ID|string|false|none|none|
|»» AGENT_NAME|string|false|none|none|
|»» GAME_NAME|string|false|none|none|
|»» USERNAME|string|false|none|none|
|»» AGENT_ELO|float|false|none|none|
|»» AVERAGE_RANKING|float|false|none|none|
|»» AGENT_STATUS|integer|false|none|none|

Status Code **502**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» logError|string|false|none|none|

<aside class="success">
This operation does not require authentication
</aside>

## delete-https:--tournament-server.herokuapp.com-api-v2-agent

<a id="opIddelete-https:--tournament-server.herokuapp.com-api-v2-agent"></a>

> Code samples

`DELETE /agent`

*Delete the user's agent*

Delete's the agent from the database

> Body parameter

```json
{
  "data": {
    "agentID": "fdf8799a-492d-43d5-a30e-77edadd0d8b1"
  },
  "signal": {}
}
```

<h3 id="delete-https:--tournament-server.herokuapp.com-api-v2-agent-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» data|body|object|false|none|
|»» agentID|body|string|false|none|
|» signal|body|object|false|none|

> Example responses

> 200 Response

```json
{
  "type": "object",
  "properties": {
    "status": {
      "type": "string",
      "example": "success"
    },
    "message": {
      "type": "string",
      "example": "The user's agent has been removed successfully"
    },
    "resultData": {
      "type": "object",
      "properties": null
    }
  }
}
```

<h3 id="delete-https:--tournament-server.herokuapp.com-api-v2-agent-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|The agent is deleted|Inline|
|502|[Bad Gateway](https://tools.ietf.org/html/rfc7231#section-6.6.3)|Failed|Inline|

<h3 id="delete-https:--tournament-server.herokuapp.com-api-v2-agent-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» resultData|object|false|none|none|

Status Code **502**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» logError|string|false|none|none|

<aside class="success">
This operation does not require authentication
</aside>

<h1 id="db-api-game">Game</h1>

## get-https:--tournament-server.herokuapp.com-api-v2-game

<a id="opIdget-https:--tournament-server.herokuapp.com-api-v2-game"></a>

> Code samples

`GET /game`

*Retrieves all games*

Retrieves all games from the database

> Example responses

> 200 Response

```json
{
  "status": "success",
  "message": "All games have been retrieved successfully",
  "resultData": [
    {
      "GAME_ID": "886edf86-c6f5-11ec-a02e-0ab3cd6d5505",
      "GAME_NAME": "Tic-Tac-Toe",
      "FILE_NAME": "TTT.java",
      "GAME_ICON": "TTT.png"
    }
  ]
}
```

<h3 id="get-https:--tournament-server.herokuapp.com-api-v2-game-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|An array of game objects is returned|Inline|
|502|[Bad Gateway](https://tools.ietf.org/html/rfc7231#section-6.6.3)|Failed|Inline|

<h3 id="get-https:--tournament-server.herokuapp.com-api-v2-game-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» resultData|[object]|false|none|none|
|»» GAME_ID|string|false|none|none|
|»» GAME_NAME|string|false|none|none|
|»» FILE_NAME|string|false|none|none|
|»» GAME_ICON|string|false|none|none|

Status Code **502**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» logError|string|false|none|none|

<aside class="success">
This operation does not require authentication
</aside>

## put-https:--tournament-server.herokuapp.com-api-v2-game

<a id="opIdput-https:--tournament-server.herokuapp.com-api-v2-game"></a>

> Code samples

`PUT /game`

*Inserts a new game*

Adds a new game to the database

> Body parameter

```json
{
  "data": {
    "gameName": "0fbe7dd3-20b4-400a-ad28-53d86dd36cd2",
    "fileName": "e9e26b2a-c6f5-11ec-a02e-0ab3cd6d5505",
    "gameIcon": "192.168.0.0.1",
    "portNum": 8000
  },
  "signal": {}
}
```

<h3 id="put-https:--tournament-server.herokuapp.com-api-v2-game-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» data|body|object|false|none|
|»» gameName|body|string|false|none|
|»» fileName|body|string|false|none|
|»» gameIcon|body|string|false|none|
|»» portNum|body|integer|false|none|
|» signal|body|object|false|none|

> Example responses

> 200 Response

```json
{
  "status": "success",
  "message": "The user's agents have been retrieved successfully",
  "resultData": {
    "GAME_ID": "886edf86-c6f5-11ec-a02e-0ab3cd6d5505",
    "GAME_NAME": "Tic-Tac-Toe",
    "FILE_NAME": "TTT.java",
    "GAME_ICON": "TTT.png"
  }
}
```

<h3 id="put-https:--tournament-server.herokuapp.com-api-v2-game-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|The created game is returned|Inline|
|502|[Bad Gateway](https://tools.ietf.org/html/rfc7231#section-6.6.3)|Failed|Inline|

<h3 id="put-https:--tournament-server.herokuapp.com-api-v2-game-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» resultData|object|false|none|none|
|»» GAME_ID|string|false|none|none|
|»» GAME_NAME|string|false|none|none|
|»» FILE_NAME|string|false|none|none|
|»» GAME_ICON|string|false|none|none|

Status Code **502**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» logError|string|false|none|none|

<aside class="success">
This operation does not require authentication
</aside>

<h1 id="db-api-tournament">Tournament</h1>

## get-https:--tournament-server.herokuapp.com-api-v2-tournament

<a id="opIdget-https:--tournament-server.herokuapp.com-api-v2-tournament"></a>

> Code samples

`GET /tournament`

*Retrieve all tournamets*

Retrieves all tournaments

> Example responses

> 200 Response

```json
{
  "status": "Successfully recorded the match",
  "message": "The match has been recorded successfully",
  "resultData": [
    {
      "TOURNAMENT_ID": "9e26b2a-c6f5-11ec-a02e-0ab3cd6d5505",
      "TOURNAMENT_NAME": "Tic-Tac-Toe-Tourney",
      "GAME_ID": "886edf86-c6f5-11ec-a02e-0ab3cd6d5505",
      "TOURNAMENT_DP": "https://i.imgur.com/spnXm7y.jpg"
    }
  ]
}
```

<h3 id="get-https:--tournament-server.herokuapp.com-api-v2-tournament-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|All tournaments are retrieved from the database|Inline|
|502|[Bad Gateway](https://tools.ietf.org/html/rfc7231#section-6.6.3)|Failed|Inline|

<h3 id="get-https:--tournament-server.herokuapp.com-api-v2-tournament-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» resultData|[object]|false|none|none|
|»» TOURNAMENT_ID|string|false|none|none|
|»» TOURNAMENT_NAME|string|false|none|none|
|»» GAME_ID|string|false|none|none|
|»» TOURNAMENT_DP|string|false|none|none|

Status Code **502**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» logError|string|false|none|none|

<aside class="success">
This operation does not require authentication
</aside>

## put-https:--tournament-server.herokuapp.com-api-v2-tournament-add

<a id="opIdput-https:--tournament-server.herokuapp.com-api-v2-tournament-add"></a>

> Code samples

`PUT /tournament`

*Insert a new tournament*

Inserts a new tournament into the database

> Body parameter

```json
{
  "data": {
    "tournamentName": "Rock-Paper-Scissors-Lizard-Spock Tourney",
    "gameID": "b772386d-c6f5-11ec-a02e-0ab3cd6d5505",
    "tournamentDP": "https://i.imgur.com/1mSPLpW.png"
  },
  "signal": {}
}
```

<h3 id="put-https:--tournament-server.herokuapp.com-api-v2-tournament-add-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» data|body|object|false|none|
|»» tournamentName|body|string|false|none|
|»» gameID|body|string|false|none|
|»» tournamentDP|body|string|false|none|
|» signal|body|object|false|none|

> Example responses

> 201 Response

```json
{
  "status": "Successfully recorded the match",
  "message": "The match has been recorded successfully",
  "resultData": {
    "TOURNAMENT_ID": "9e26b2a-c6f5-11ec-a02e-0ab3cd6d5505",
    "TOURNAMENT_NAME": "Tic-Tac-Toe-Tourney",
    "GAME_ID": "886edf86-c6f5-11ec-a02e-0ab3cd6d5505",
    "TOURNAMENT_DP": "https://i.imgur.com/spnXm7y.jpg"
  }
}
```

<h3 id="put-https:--tournament-server.herokuapp.com-api-v2-tournament-add-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|201|[Created](https://tools.ietf.org/html/rfc7231#section-6.3.2)|The newly created tournament is returned|Inline|
|502|[Bad Gateway](https://tools.ietf.org/html/rfc7231#section-6.6.3)|Failed|Inline|

<h3 id="put-https:--tournament-server.herokuapp.com-api-v2-tournament-add-responseschema">Response Schema</h3>

Status Code **201**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» resultData|object|false|none|none|
|»» TOURNAMENT_ID|string|false|none|none|
|»» TOURNAMENT_NAME|string|false|none|none|
|»» GAME_ID|string|false|none|none|
|»» TOURNAMENT_DP|string|false|none|none|

Status Code **502**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» logError|string|false|none|none|

<aside class="success">
This operation does not require authentication
</aside>

<h1 id="db-api-match">Match</h1>

## put-https:--tournament-server.herokuapp.com-api-v2-match

<a id="opIdput-https:--tournament-server.herokuapp.com-api-v2-match"></a>

> Code samples

`PUT /match`

*Record the match results*

Adds a recorded match to the database

> Body parameter

```json
{
  "data": {
    "tournamentID": "01934c61-c6f6-11ec-a02e-0ab3cd6d5505\"",
    "matchLogTime": "2022-04-10 18:39:15",
    "gameLog": "string",
    "agentResults": [
      {
        "agentID": "173afbb4-f4d0-446f-ac79-89695ea643bc",
        "ranking": 0
      }
    ]
  },
  "signal": {}
}
```

<h3 id="put-https:--tournament-server.herokuapp.com-api-v2-match-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» data|body|object|false|none|
|»» tournamentID|body|string|false|none|
|»» matchLogTime|body|string|false|none|
|»» gameLog|body|string|false|none|
|»» agentResults|body|[object]|false|none|
|»»» agentID|body|string|false|none|
|»»» ranking|body|integer|false|none|
|» signal|body|object|false|none|

> Example responses

> 201 Response

```json
{
  "status": "Successfully recorded the match",
  "message": "The match has been recorded successfully",
  "resultData": null
}
```

<h3 id="put-https:--tournament-server.herokuapp.com-api-v2-match-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|201|[Created](https://tools.ietf.org/html/rfc7231#section-6.3.2)|Recoding the match was successful|Inline|
|502|[Bad Gateway](https://tools.ietf.org/html/rfc7231#section-6.6.3)|Failed|Inline|

<h3 id="put-https:--tournament-server.herokuapp.com-api-v2-match-responseschema">Response Schema</h3>

Status Code **201**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» resultData|string|false|none|none|

Status Code **502**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» logError|string|false|none|none|

<aside class="success">
This operation does not require authentication
</aside>

## post-https:--tournament-server.herokuapp.com-api-v2-match

<a id="opIdpost-https:--tournament-server.herokuapp.com-api-v2-match"></a>

> Code samples

`POST /match`

*Retrieves the matches of a tournament*

All matches from a tournament are retrieved from the database

> Body parameter

```json
{
  "data": {
    "tournamentID": "01934c61-c6f6-11ec-a02e-0ab3cd6d5505"
  },
  "signal": {}
}
```

<h3 id="post-https:--tournament-server.herokuapp.com-api-v2-match-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» data|body|object|false|none|
|»» tournamentID|body|string|false|none|
|» signal|body|object|false|none|

> Example responses

> 200 Response

```json
{
  "status": "success",
  "message": "All matches of the tournament have been retrieved successfully",
  "resultData": [
    {
      "MATCH_LOG_ID": "b17d2e65-dafe-47c7-8dbc-b59a3dd16476",
      "TOURNAMENT_ID": "01934c61-c6f6-11ec-a02e-0ab3cd6d5505",
      "MATCH_LOG_DATA": "|Paper Rock|Paper Lizard|Spock Spock|Spock Spock|Spock Lizard|Paper Lizard|Scissors Paper|",
      "MATCH_LOG_TIMESTAMP": "2022-04-27T18:41:42.000"
    }
  ]
}
```

<h3 id="post-https:--tournament-server.herokuapp.com-api-v2-match-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Matches from the given tournament are returned|Inline|
|502|[Bad Gateway](https://tools.ietf.org/html/rfc7231#section-6.6.3)|Failed|Inline|

<h3 id="post-https:--tournament-server.herokuapp.com-api-v2-match-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» resultData|[object]|false|none|none|
|»» MATCH_LOG_ID|string|false|none|none|
|»» TOURNAMENT_ID|string|false|none|none|
|»» MATCH_LOG_DATA|string|false|none|none|
|»» MATCH_LOG_TIMESTAMP|string|false|none|none|

Status Code **502**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» logError|string|false|none|none|

<aside class="success">
This operation does not require authentication
</aside>

## get-https:--tournament-server.herokuapp.com-api-v2-match

<a id="opIdget-https:--tournament-server.herokuapp.com-api-v2-match"></a>

> Code samples

`POST /match/filter`

*Get all match results*

- Retrieves match results from the database
- Each filter below is optional, either enter an empty string or leave it as undefined
- Leave all attributes as undefined if there is no filter required
- Date comparisons also cater for equality

> Body parameter

```json
{
  "data": {
    "username": "moose918",
    "tournamentName": "Rock",
    "inProgress": false,
    "date": {
      "comparator": "<",
      "val": "2022-02-22"
    }
  },
  "signal": {}
}
```

<h3 id="get-https:--tournament-server.herokuapp.com-api-v2-match-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|false|none|
|» data|body|object|false|none|
|»» username|body|string|false|none|
|»» tournamentName|body|string|false|none|
|»» inProgress|body|boolean|false|none|
|»» date|body|object|false|none|
|»»» comparator|body|string|false|none|
|»»» val|body|string|false|none|
|» signal|body|object|false|none|

> Example responses

> 200 Response

```json
{
  "status": "success",
  "message": "Successfully retrieved all match results",
  "resultData": [
    {
      "MATCH_LOG_ID": "e7cc1eb8-0e84-4bec-ada0-09652e9f5873",
      "GAME_NAME": "Rock-Paper-Scissors-Lizard-Spock",
      "TOURNAMENT_NAME": "Rock-Paper-Scissors-Lizard-Spock Tourney",
      "MATCH_LOG_DATA": "|Lizard Spock|Lizard Rock|Scissors Lizard|Spock Spock|Paper Spock|Rock Rock|Spock Lizard|",
      "MATCH_LOG_TIMESTAMP": "2022-02-22T16:34:42.000Z",
      "MATCH_LOG_IN_PROGRESS": 1,
      "U1_USERNAME": "Zizi",
      "R1_AGENT_ID": "173afbb4-f4d0-446f-ac79-89695ea643bc",
      "R1_RANKING": 0,
      "U2_USERNAME": "Kixn",
      "R2_AGENT_ID": "b724d13a-32e0-400b-a6ac-9b499a41c511",
      "R2_RANKING": 1
    }
  ]
}
```

<h3 id="get-https:--tournament-server.herokuapp.com-api-v2-match-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|An array of match result objects is retrieved|Inline|
|502|[Bad Gateway](https://tools.ietf.org/html/rfc7231#section-6.6.3)|Failed|Inline|

<h3 id="get-https:--tournament-server.herokuapp.com-api-v2-match-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» resultData|[object]|false|none|none|
|»» MATCH_LOG_ID|string|false|none|none|
|»» GAME_NAME|string|false|none|none|
|»» TOURNAMENT_NAME|string|false|none|none|
|»» MATCH_LOG_DATA|string|false|none|none|
|»» MATCH_LOG_TIMESTAMP|string|false|none|none|
|»» MATCH_LOG_IN_PROGRESS|integer|false|none|none|
|»» U1_USERNAME|string|false|none|none|
|»» R1_AGENT_ID|string|false|none|none|
|»» R1_RANKING|integer|false|none|none|
|»» U2_USERNAME|string|false|none|none|
|»» R2_AGENT_ID|string|false|none|none|
|»» R2_RANKING|integer|false|none|none|

Status Code **502**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|false|none|none|
|» message|string|false|none|none|
|» logError|string|false|none|none|

<aside class="success">
This operation does not require authentication
</aside>

