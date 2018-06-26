*** settings ***
Library    OperatingSystem
Library    Selenium2Library
Library    RequestsLibrary
Library    ./test.py
#Suite Setup    Deploy mock data

*** test cases ***

test chrome
    [Tags]    web    testchrome
    #Open browser    http://www.google.com    chrome
    Open Chrome with Extension    http://www.gogle.com
    sleep    300
    close browser

*** keywords ***
Open Chrome with Extension
    [Arguments]    ${url}  
    ${chrome_options}=     get_chrome_option
    Create Webdriver    Chrome    chrome_options=${chrome_options}
    Go To    ${url}

xxx
    [Arguments]    ${url}    
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Evaluate    ${chrome_options}.add_extension('/')
    Call Method    ${chrome_options}    add_argument    enable-extensions
    #Call Method    ${chrome_options}    add_argument    load-extensions="Web Developer"
    #Call Method    ${chrome_options}    add_argument    headless
    #Call Method    ${chrome_options}    add_argument    disable-gpu
    #Open Browser    ${url}    Chrome    desired_capabilities=${chrome_options.to_capabilities()}
    Create Webdriver    Chrome    chrome_options=${chrome_options}
    Go To    ${url}

Deploy mock data
    ${content}    Get File    mock_data/mock_data.json
    Create Session    mb    http://${MB_SERVER}
    Delete Request    mb    /imposters/9001
    Post Request    mb    /imposters    data=${content}

