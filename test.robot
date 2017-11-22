*** settings ***
Library    Selenium2Library
Library    RequestsLibrary

*** test cases ***
TC_TEST_00034 test hello
    log    hello robot
    log    BROWSER=${BROWSER}

TC_TEST_00035 test google
    [Tags]    web
    open browser    https://www.google.co.th    chrome
    #log    BROWSER=${BROWSER}
    #Maximize Browser Window
    #set window size    1920    1080
    capture page screenshot
    close browser

TC_TEST_00036 test mock app
    [Tags]    mockapp
    Create Session    mock_app    http://${MOCK_APP_SERVER}
    ${resp}=    Get Request    mock_app    /
    Should be equal as integers    200    ${resp.status_code}

TC_TEST_00037 test mock app connect backend
    [Tags]    mockapp    backend
    Create Session    mock_app    http://${MOCK_APP_SERVER}
    ${resp}=    Get Request    mock_app    /test?backend=${BACKEND_SERVER}
    Should be equal as integers    200    ${resp.status_code}
    Should be equal    result from backend    ${resp.text}
