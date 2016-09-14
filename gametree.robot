*** Settings ***
Library    Collections
Library    RequestsLibrary
Test Setup    Gametree Session

*** Test Cases ***
Can create player
    ${resp}=    Post Request    gt    /players    {"email": "foo@bar.com", "handle": "foobar"}
    Should be equal as strings    201    ${resp.status_code}
    Set suite variable    ${foobar_player_id}    ${resp.json()["id"]}

Can retrieve created player
    ${resp}=    Get Request    gt    /players/${foobar_player_id}
    Should be equal as strings    200    ${resp.status_code}
    Should be equal as strings    foo@bar.com    ${resp.json()["email"]}
    Should be equal as strings    foobar    ${resp.json()["handle"]}

Trying to retrieve non-existent player 404's
    ${resp}=    Get Request    gt    /players/0
    Should be equal as strings    404    ${resp.status_code}

Can retrieve player by email
    ${params}=    Create Dictionary    email=foo@bar.com
    ${resp}=    Get Request    gt    /players    params=${params}
    Should be equal as strings    200    ${resp.status_code}
    Should be equal as strings    foo@bar.com    ${resp.json()["email"]}
    Should be equal as strings    foobar    ${resp.json()["handle"]}
    Should be equal as strings    ${foobar_player_id}    ${resp.json()["id"]}

Trying to retrieve non-existent player by email 404's
    ${params}=    Create Dictionary    email=boo@far.com
    ${resp}=    Get Request    gt    /players    params=${params}
    Should be equal as strings    404    ${resp.status_code}

*** Keywords ***
Gametree Session
    ${headers}=    Create Dictionary    Content-Type=application/json
    Create session    gt    http://localhost:3000    headers=${headers}
