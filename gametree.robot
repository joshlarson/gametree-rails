*** Settings ***
Library    Collections
Library    RequestsLibrary

*** Test Cases ***
Create player
    Gametree session
    ${resp}=    Post Request    gt    /players    {"email": "foo@bar.com", "handle": "foobar"}

*** Keywords ***
Gametree Session
    ${headers}=    Create Dictionary    Content-Type=application/json
    Create session    gt    http://localhost:3000    headers=${headers}
