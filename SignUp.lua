local storyboard = require( "storyboard" )
local widget = require("widget")
local App42APIServices = require("App42APIServices")
local nameLabel,passwordLabel,emailLabel
local registerButton,signInButton,nameField,passwordField,emailField,userNameTextField,passTextField,emailTextField
local signUpScene = storyboard.newScene()

local function fieldHandler( event )    
  if ( "began" == event.phase ) then
    elseif ( "ended" == event.phase ) then
      elseif ( "submitted" == event.phase ) then
    if (event.target.name == "nameField") then
        userNameTextField = nameField.text
      elseif (event.target.name == "passwordField") then
        passTextField = passwordField.text
      elseif (event.target.name == "emailField") then
        emailTextField = emailField.text
    end
    native.setKeyboardFocus( nil )
  end  
return true
end     

function signUpScene:createScene( event )
	local screenGroup = self.view	
end
function signUpScene:enterScene( event )
	local screenGroup = self.view
  image = display.newImage( "images/background.png" )
	screenGroup:insert( image )

  nameLabel = display.newText ( "Name:", 60, 130, native.systemFontBold, 14)
  passwordLabel = display.newText ( "Password:", 60, 170, native.systemFontBold, 14)
  emailLabel = display.newText ( "Email:", 60, 210, native.systemFontBold, 14)
  
  nameField = native.newTextField( 150, 130, 150, 30)
  nameField:addEventListener("userInput", fieldHandler)
  nameField.inputType = "default"
  nameField.name = "nameField"

  passwordField = native.newTextField( 150, 170, 150, 30)
  passwordField:addEventListener("userInput", fieldHandler)
  passwordField.inputType = "default"
  passwordField.isSecure = true
  passwordField.name = "passwordField"

  emailField = native.newTextField( 150, 210, 150, 30)
  emailField:addEventListener("userInput", fieldHandler)
  emailField.inputType = "email"
  emailField.name = "emailField"
  
  local headerTitle = display.newText("Tic Tac Toe",0,0,native.systemFontBold,32)
	headerTitle.x, headerTitle.y = display.contentWidth * 0.5, 25
	screenGroup:insert( headerTitle )
	registerButton =  require("widget").newButton
  {
    left = (display.contentWidth-130)/1,
    top = display.contentHeight - 180,
    label = "Register",
    width = 100, height = 40,
    cornerRadius = 4,
    onEvent = function(event) 
      if "ended" == event.phase then
        App42APIServices:registerUser(userNameTextField,passTextField,emailTextField)
      end
    end
  }
  signInButton =  require("widget").newButton
  {
    left = (display.contentWidth-260)/1,
    top = display.contentHeight - 180,
    label = "SignIn",
    width = 100, height = 40,
    cornerRadius = 2,
    onEvent = function(event) 
      if "ended" == event.phase then
        App42APIServices:authenticateUser(userNameTextField,passTextField)
      end
    end
  }
  
end

function signUpScene:exitScene( event )
	local screenGroup = self.view
  registerButton.isVisible = false
  signInButton.isVisible = false
  nameField:removeSelf()
  nameField = nil
  passwordField:removeSelf()
  passwordField = nil
  emailField:removeSelf()
  emailField = nil
  nameLabel.isVisible = false
  passwordLabel.isVisible = false
  emailLabel.isVisible = false  
end
function signUpScene:destroyScene( event )
	local screenGroup = self.view
	display.remove(registerButton)
	display.remove(signInButton)
end
signUpScene:addEventListener( "createScene", signUpScene )
signUpScene:addEventListener( "enterScene", signUpScene )
signUpScene:addEventListener( "exitScene", signUpScene )
signUpScene:addEventListener( "destroyScene", signUpScene )
return signUpScene