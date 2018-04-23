*** settings ***
Library    OperatingSystem
Library    Selenium2Library
Library    RequestsLibrary
#Suite Setup    Deploy mock data

*** test cases ***
TC_TEST_00034 test hello
    log    hello robot
    log    BROWSER=${BROWSER}


test chrome
    [Tags]    web    testchrome
    Open Chrome    http://www.google.com
    capture page screenshot
    close browser

TC_TEST_00035 test chrome headless by manual config
    [Tags]    web    chrome
    #Call Method    ${chrome_options}    add_argument    test-type
    #Call Method    ${chrome_options}    add_argument    --disable-extensions
    #Call Method    ${chrome_options}    add_argument    -log-path=/tmp/chrome.log
    #Create Webdriver    Chrome    my_alias    chrome_options=${chrome_options}
    #${disabled}    Create List    Chrome PDF Viewer
    #${prefs}    Create Dictionary    download.default_directory=${download directory}    plugins.plugins_disabled=${disabled}
    #Call Method    ${chrome options}    add_experimental_option    prefs    ${prefs}
    #Call Method    ${chrome options}    add_argument    headless
    #Call Method    ${chrome options}    add_argument    disable-gpu
    
    #${options.binary_location}    Set Variable    /Applications/Google Chrome.app/Contents/MacOS/Google Chrome
    #${options}=     Call Method     ${chrome_options}    to_capabilities
    #Create Webdriver    Chrome    chrome_options=${options}    executable_path=/usr/local/bin/chromedriver
    

    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome_options}    add_argument    headless
    Call Method    ${chrome_options}    add_argument    disable-gpu
    Create Webdriver    Chrome    chrome_options=${chrome_options}
    Go To    http://www.google.com
    #Open Browser    ${url}    Chrome    desired_capabilities=${chrome_options.to_capabilities()}

    #Maximize Browser Window
    #set window size    1920    1080
    Click element    btnK    
    capture page screenshot
    close browser

TC_TEST_00042 test chrome headless by predefined headlesschrome
    [Tags]    web    chrome
    Open Browser    http://www.google.com    headlesschrome
    Click element    btnK
    capture page screenshot
    close browser

TC_TEST_00042 test chrome normal mode 
    [Tags]    web    chrome
    Open Browser    http://www.google.com    chrome
    Click element    btnK
    capture page screenshot
    close browser


TC_TEST_00041 test firefox
    [Tags]    web
    open browser    https://www.google.co.th    headlessfirefox
    capture page screenshot
    close browser

TC_TEST_00042 test phantomjs
    [Tags]    web
    open browser    https://www.google.co.th    phantomjs
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
Open Chrome
    [Arguments]    ${url}    
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome_options}    add_argument    headless
    Call Method    ${chrome_options}    add_argument    disable-gpu
    #Open Browser    ${url}    Chrome    desired_capabilities=${chrome_options.to_capabilities()}
    Create Webdriver    Chrome    chrome_options=${chrome_options}
    Go To    ${url}

Deploy mock data
    ${content}    Get File    mock_data/mock_data.json
    Create Session    mb    http://${MB_SERVER}
    Delete Request    mb    /imposters/9001
    Post Request    mb    /imposters    data=${content}

