*** settings ***
Library    OperatingSystem
Library    Selenium2Library
Library    RequestsLibrary
#Suite Setup    Deploy mock data

*** test cases ***
TC_TEST_00034 test hello
    log    hello robot
    log    BROWSER=${BROWSER}

TC_TEST_00035 test chrome
    [Tags]    web
    #${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    #Call Method    ${chrome_options}    add_argument    test-type
    #Call Method    ${chrome_options}    add_argument    --disable-extensions
    #Call Method    ${chrome_options}    add_argument    -log-path=/tmp/chrome.log
    #Create Webdriver    Chrome    my_alias    chrome_options=${chrome_options}
    open browser    https://www.google.co.th    chrome
    #log    BROWSER=${BROWSER}
    #Maximize Browser Window
    #set window size    1920    1080
    capture page screenshot
    close browser

TC_TEST_00041 test firefox
    [Tags]    web
    open browser    https://www.google.co.th    ff
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
    ${resp}=    Get Request    mock_app    /test?backend=${BACKEND_SERVER}&port=${PORT}
    Should be equal as integers    200    ${resp.status_code}
    Should be equal    result from backend    ${resp.text}

TC_TEST_00038 test mock app connect backend 2
      [Tags]    mockapp    backend
      Create Session    mock_app    http://${MOCK_APP_SERVER}
      ${resp}=    Get Request    mock_app    /test2?backend=${BACKEND_SERVER}&port=${PORT}
      Should be equal as integers    200    ${resp.status_code}
      Should be equal    result from backend 2    ${resp.text}

TC_TEST_00040 test mock app connect backend 3
      [Tags]    mockapp    backend
      Create Session    mock_app    http://${MOCK_APP_SERVER}
      ${resp}=    Get Request    mock_app    /test3?backend=${BACKEND_SERVER}&port=${PORT}
      Should be equal as integers    200    ${resp.status_code}
      Should be equal    result from backend 3    ${resp.text}

test oracle db
      [Tags]    db
      log    test connect to oracle db 
     # ${x}=    evaluate    os.environ['ORACLE_HOME']    modules=os 
     # ${x}=    evaluate    os.environ['LIBRARY_PATH']    modules=os 
      evaluate    cx_Oracle.connect('QA_Weerawat','p@$$w0rd', cx_Oracle.makedsn('10.224.101.1', 2992, 'pstg'))    modules=cx_Oracle



*** keywords ***
Deploy mock data
    ${content}    Get File    mock_data/mock_data.json
    Create Session    mb    http://${MB_SERVER}
    Delete Request    mb    /imposters/9001
    Post Request    mb    /imposters    data=${content}

