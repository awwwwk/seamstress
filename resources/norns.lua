-- this file was generated by `seamstress create-norns-project`

-- norns will call this function to start your script!
function init()
  print("this message came from within the init() function!")
  redraw()
end

hello_message = "hi from redraw!"

-- this function will draw some things to the screen
function redraw()
  screen.clear()
  screen.move(64, 20)
  screen.text_center(hello_message)
  screen.refresh()
end

-- react to pressing a norns key!
function key(n, z)
  if n == 3 and z == 1 then
    hello_message = "hi from K3!"
    redraw()
  end
end
