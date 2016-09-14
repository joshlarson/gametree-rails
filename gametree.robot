*** Settings ***
Library    Collections
Library    RequestsLibrary
Test Setup    Gametree Session

*** Test Cases ***
Can create player
    ${resp}=    Create Player    foo@bar.com    foobar
    Should be created    ${resp}
    Set suite variable    ${foobar_player_id}    ${resp.json()["id"]}

Can retrieve created player
    ${resp}=    Get Player    ${foobar_player_id}
    Should be OK    ${resp}
    Should be equal as strings    foo@bar.com    ${resp.json()["email"]}
    Should be equal as strings    foobar    ${resp.json()["handle"]}

Trying to retrieve non-existent player 404's
    ${resp}=    Get Player    0
    Should be Not Found    ${resp}

Can retrieve player by email
    ${resp}=    Find Player By Email    foo@bar.com
    Should be OK    ${resp}
    Should be equal as strings    foo@bar.com    ${resp.json()["email"]}
    Should be equal as strings    foobar    ${resp.json()["handle"]}
    Should be equal as strings    ${foobar_player_id}    ${resp.json()["id"]}

Trying to retrieve non-existent player by email 404's
    ${resp}=    Find Player By Email    boo@far.com
    Should be Not Found    ${resp}

Can create game
    ${resp}=    Create Game    ${foobar_player_id}
    Should be Created    ${resp}
    Set suite variable    ${foobar_game1_id}    ${resp.json()["id"]}

Cannot create game under non-existent player
    ${resp}=    Create Game    0
    Should be Not Found    ${resp}

Can retrieve a game
    ${resp}=    Get Game    ${foobar_game1_id}
    Should be OK    ${resp}
    Should be equal as strings    ${foobar_player_id}    ${resp.json()["player_id"]}
    Should be equal as strings    0    ${resp.json()["score"]}
    Should be equal as strings    in progress    ${resp.json()["status"]}

Trying to retrieve a non-existent game 404's
    ${resp}=    Get Game    0
    Should be Not Found    ${resp}

Can add points to a game
    ${resp}=    Add Points To Game    ${foobar_game1_id}    4
    Should be created    ${resp}

Cannot add points to a non-existent game
    ${resp}=    Add Points To Game    0    4
    Should be Not Found    ${resp}

Points show up in the game object
    ${resp}=    Get Game    ${foobar_game1_id}
    Should be equal as strings    ${resp.json()["score"]}    4

Points aggregate
    Add Points To Game    ${foobar_game1_id}    3
    ${resp}=    Get Game    ${foobar_game1_id}
    Should be equal as strings    ${resp.json()["score"]}    7

Can add a charge to a game
    ${resp}=    Add Charge To Game    ${foobar_game1_id}    5
    Should be created    ${resp}

Cannot add a charge to a non-existent game
    ${resp}=    Add Charge To Game    0    5
    Should be Not Found    ${resp}

Cost shows up in the game object
    ${resp}=    Get Game    ${foobar_game1_id}
    Should be equal as strings    ${resp.json()["cost"]}    5

Charges aggregate
    Add Charge To Game    ${foobar_game1_id}    1
    ${resp}=    Get Game    ${foobar_game1_id}
    Should be equal as strings    ${resp.json()["cost"]}    6

*** Keywords ***
Gametree Session
    ${headers}=    Create Dictionary    Content-Type=application/json
    Create session    gt    http://localhost:3000    headers=${headers}

Should be OK
    [Arguments]    ${resp}
    Should be equal as strings    200    ${resp.status_code}

Should be Created
    [Arguments]    ${resp}
    Should be equal as strings    201    ${resp.status_code}

Should be Not Found
    [Arguments]    ${resp}
    Should be equal as strings    404    ${resp.status_code}

Create Player
    [Arguments]    ${email}    ${handle}
    [Return]    ${resp}
    ${resp}=    Post Request    gt    /players    {"email": "${email}", "handle": "${handle}"}

Get Player
    [Arguments]    ${id}
    [Return]    ${resp}
    ${resp}=    Get Request    gt    /players/${id}

Find Player By Email
    [Arguments]    ${email}
    [Return]    ${resp}
    ${params}=    Create Dictionary    email=${email}
    ${resp}=    Get Request    gt    /players    params=${params}

Create Game
    [Arguments]    ${player_id}
    [Return]    ${resp}
    ${resp}=    Post Request    gt    /players/${player_id}/games

Get Game
    [Arguments]    ${game_id}
    [Return]    ${resp}
    ${resp}=    Get Request    gt    /games/${game_id}

Add Points To Game
    [Arguments]    ${game_id}    ${num_points}
    [Return]    ${resp}
    ${resp}=    Post Request    gt    /games/${game_id}/points    {"points":${num_points}}

Add Charge To Game
    [Arguments]    ${game_id}    ${cost}
    [Return]    ${resp}
    ${resp}=    Post Request    gt    /games/${game_id}/charge    {"amount":${cost}}
