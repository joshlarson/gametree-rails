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
