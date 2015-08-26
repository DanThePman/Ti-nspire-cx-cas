local input = ""
local output = { }
local directionOutput = { }
local directionOutputCorrespondingIndex = { }

local registeredVector = false
local drawVectors = false
local connectVectors = false

local checkedWelcome = false

-------------------------------------------------------AnimationDrawing-------------------------------------------------------------------------
local StdAccelerationValue_Register_Vector = 1
local debug = false
local letterIndex1 = 1
local MAX_STEP = 100
--

--WELCOME---------------------------------------------------------------------------------------------------------------------------------
local w_letterIndexes  = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
local w_letters ={ "D", "A", "N", "I", "E", "L", "S",      "V", "E", "K", "T", "O", "R",        "F", "R", "A", "M", "E", "W", "O", "R", "K" }
local LETTER_COUNT = 22
local w_MAX_STEP_FIRST = 190
local w_MAX_STEP_SECOND = platform.window:width() + 20
local accelerate = false
local MAX_LETTER_DISTANCE_ACCELERATE = 20
local MAX_LETTER_DISTANCE_NO_ACCELERATE = MAX_LETTER_DISTANCE_ACCELERATE - 
                                                w_letterIndexes[1] * MAX_LETTER_DISTANCE_ACCELERATE / w_MAX_STEP_FIRST
local smoothOutDistance = 20
local earlierAccelerationValue = 50 --at least

local StdAccelerationValue = 3 --at accelerate = false
local accelerationValue = 15


local currentLetterIndex
--WELCOME-------------------------------------------------------------------------------------------------------------------------------------------------


--DrawVecs
local stretchFactor = 10
--DrawVecs

--Mouse

local drawCircle = false
local nearestVec = { } --includes stretchFactor
local circleRadius = 25

--Mouse22222

local clickedInCircle = false

--Mouse

function on.timer() --fires automatically

if checkedWelcome then
    slowDownFactor = (StdAccelerationValue_Register_Vector - letterIndex1) / MAX_STEP --random ?!
    letterIndex1 = letterIndex1 + (StdAccelerationValue_Register_Vector - (letterIndex1 * slowDownFactor))
    platform.window:invalidate()
else ---------------------------===DO WELCOME===
    
    for currentIndexChanger = 1,LETTER_COUNT,1 do       
            if not accelerate then --accelerate = false
                            MAX_LETTER_DISTANCE_NO_ACCELERATE = MAX_LETTER_DISTANCE_ACCELERATE - 
                                                            w_letterIndexes[1] * MAX_LETTER_DISTANCE_ACCELERATE / w_MAX_STEP_FIRST
                
                if (currentIndexChanger == 1) or 
                    (currentIndexChanger > 1 and w_letterIndexes[currentIndexChanger - 1] - w_letterIndexes[currentIndexChanger] >= 
                        MAX_LETTER_DISTANCE_NO_ACCELERATE) then --------------------------------------------------------------------manage letter distance
                        
                           local slowDownFactor = w_letterIndexes[currentIndexChanger] * 0.01315789473
                           
                           if currentIndexChanger < LETTER_COUNT and slowDownFactor >= 2.5 then
                                slowDownFactor = slowDownFactor - 1
                           end
                    
                        w_letterIndexes[currentIndexChanger] = w_letterIndexes[currentIndexChanger] + StdAccelerationValue - slowDownFactor
                        
                        if w_letterIndexes[currentIndexChanger] == w_letterIndexes[LETTER_COUNT] and w_letterIndexes[currentIndexChanger] >
                                    w_MAX_STEP_FIRST - earlierAccelerationValue then
                            accelerate = true
                        end
                    
                end
            
            
            else --accelerate == true
            
                
                if (currentIndexChanger == 1) or  ----------manage letter distance
                (currentIndexChanger > 1 and w_letterIndexes[currentIndexChanger - 1] - w_letterIndexes[currentIndexChanger] >= MAX_LETTER_DISTANCE_ACCELERATE) then
                    
                    local speedUpFactor = w_letterIndexes[currentIndexChanger] * 0.01315789473
                    
                    w_letterIndexes[currentIndexChanger] = w_letterIndexes[currentIndexChanger] + accelerationValue + (speedUpFactor)
                    if w_letterIndexes[currentIndexChanger] == w_letterIndexes[LETTER_COUNT] and w_letterIndexes[currentIndexChanger] > w_MAX_STEP_SECOND then
                        timer.stop()
                        checkedWelcome = true
                    end  
                
                end                                                            
            end
        platform.window:invalidate()
    end
end  ---------------------------===DO WELCOME===
   
end --endfunc


function DrawTextAnimation(gc)

    if debug then letterIndex1 = MAX_STEP + 1 end
    
    if letterIndex1 <= MAX_STEP then
        gc:setFont("serif","bi",12)
        gc:setColorRGB(0, 102, 51)
        gc:drawString("Vektor regestriert!", 170 - letterIndex1 ,5,"top")
        timer.start(0.01)
    else
        gc:setColorRGB(0,0,0)
        gc:setFont("serif","r",12)
        timer.stop()
        letterIndex1 = 1
        registeredVector = false
    end

end --endfunc

--===========================================WELCOME MSG=============================================================================================

function DoWelcome(gc)

timer.start(0.01)

--show letters only
for i = 1, LETTER_COUNT, 1 do  
    
    local travelDistance = w_MAX_STEP_FIRST
    
        if i < LETTER_COUNT then
            travelDistance = travelDistance + smoothOutDistance
        end
    
   if (w_letterIndexes[i] <= travelDistance and not accelerate) or (accelerate and w_letterIndexes[i] <= w_MAX_STEP_SECOND) then
        gc:drawString(w_letters[i]         , platform.window:width() + 10 - w_letterIndexes[i]                , platform.window:height() / 2 ,"middle")
   end
end
--show letters only

end
--===========================================WELCOME MSG=============================================================================================


-------------------------------------------------------AnimationDrawing-------------------------------------------------------------------------

 --====================================================PAINTING / MAIN FUNC=================================================================
  --====================================================PAINTING / MAIN FUNC=================================================================
 --====================================================PAINTING / MAIN FUNC=================================================================
function on.paint(gc)

    if not checkedWelcome then --welcome msg loading
        gc:setColorRGB(218,165,32)
        gc:setFont("serif","bi",14)
        DoWelcome(gc)
        return
    else
        gc:setColorRGB(0,0,0)
        gc:setFont("serif","r",12)
    end
    
    if string.len(input) > 0 then --printing help
        PrintHelp(gc)
    end
    
    if clickedInCircle then --clicked in circle true
        platform.window:invalidate()
        DrawOptionsMenuAfterClick(gc)
    end
    
    if drawCircle then --draw circle true
        gc:setPen("thin","dotted")
        gc:drawArc(nearestVec[1] - circleRadius / 2, nearestVec[2] - circleRadius / 2, circleRadius, circleRadius, 0, 360) --draws a circle at vec point
        gc:setPen("thin","smooth")
    end
    
    if drawVectors then --drw input
        CheckStretchFactor()
        CheckStretchFactor() --refresh checking
        DrawOPVectors(gc)
    end
    
    if connectVectors then --cnt input
        CheckStretchFactor()
        CheckStretchFactor() --refresh checking
        ConnectVectors(gc)
    end

    if not registeredVector then
        gc:drawString(input,5,5,"top")
    else
        DrawTextAnimation(gc)
    end
end
--====================================================PAINTING / MAIN FUNC=================================================================
 --====================================================PAINTING / MAIN FUNC=================================================================
  --====================================================PAINTING / MAIN FUNC=================================================================


-------------------------------------------------------CHAR_IN_KEY-------------------------------------------------------------------------
function on.charIn(char)
    if string.len(input) <= 25 and checkedWelcome then
        input = input..char
        platform.window:invalidate()
    end
end
-------------------------------------------------------CHAR_IN_KEY-------------------------------------------------------------------------



-------------------------------------------------------BACKSPC_KEY-------------------------------------------------------------------------
function on.backspaceKey()
    
    if not checkedWelcome then return end
    
    input = string.usub(input,0, string.len(input) - 1)
    platform.window:invalidate()
end
-------------------------------------------------------BACKSPC_KEY-------------------------------------------------------------------------


-------------------------------------------------------RETURN_KEY-------------------------------------------------------------------------
function on.enterKey()

if input == "" then return end

if input == "drw" then --draw Vecs
    drawVectors = true
    input = ""
    platform.window:invalidate()
    return
elseif input == "cnt" then --connect
    connectVectors = true
    input = ""
    platform.window:invalidate()
    return
else --add Vecs
    if string.match(input, "d") then --add directional Vec
            local firstOne = false
            for element in string.gmatch(input, '([^,]+)') do
                if element ~= "d" then
                    if not firstOne then 
                        firstOne = true
                        directionOutputCorrespondingIndex[#directionOutputCorrespondingIndex + 1] = element
                    else
                        directionOutput[#directionOutput + 1] = element 
                    end
                end
            end
    else --add normal Vec 
        for element in string.gmatch(input, '([^,]+)') do
            output[#output + 1] = element
        end
    end
    
    input = ""
    platform.window:invalidate()
    registeredVector = true
end

end

local screenWidht = platform.window:width()
local screenHeight = platform.window:height()
-------------------------------------------------------RETURN_KEY-------------------------------------------------------------------------


-------------------------------------------------------DrawVecs-------------------------------------------------------------------------

function RotateVecStd(x, y, angle)

local solutions = { 0,0 }
solutions[1] = x * math.cos(angle) - y * math.sin(angle)
solutions[2] = x * math.sin(angle) + y * math.cos(angle)

return solutions

end

function GetVecLenght(x, y)
    return math.sqrt(x*x + y*y)
end

function DrawOPVectors(gc)

local vecX = null

index = 1
for _, _vec in ipairs(output) do
    vec = tonumber(_vec)
    if not vecX then vecX = vec else
        --x exists
        --vecX => x
        --vec => y
        gc:setPen("medium","smooth")
        gc:drawLine(0, 0, vecX * stretchFactor, vec * stretchFactor)
        DrawSmallArrow(0, 0, vecX * stretchFactor, vec * stretchFactor,   gc)
        gc:setPen("thin","smooth")
            gc:setFont("serif","r",8)
            gc:drawString(index..".".."("..vecX.."|"..vec..")", vecX * stretchFactor / 2 + 5, vec * stretchFactor / 2, "bottom")
            gc:setFont("serif","r",12)
        --gc:setPen("thick","dotted")
        vecX = null
        index = index + 1
    end
end

DrawDirectionalVectors(gc)

input = ""
drawVectors = false

end --endfunc

function DrawSmallArrow(xStart, yStart, xEnd, yEnd,  gc)

local resultungLenght = 10
local x = xEnd - xStart
local y = yEnd - yStart

local multiplyFactor = resultungLenght / GetVecLenght(x, y)
x = x * multiplyFactor
y = y * multiplyFactor

local rotatedVecs = RotateVecStd(x, y, -405) --array
local rotatedVecs2 = RotateVecStd(x, y, 405) --array
X = 1
Y = 2

gc:setColorRGB(0, 0, 255)
gc:drawLine(xEnd, yEnd, xEnd + rotatedVecs[X], yEnd + rotatedVecs[Y])
gc:drawLine(xEnd, yEnd, xEnd + rotatedVecs2[X], yEnd + rotatedVecs2[Y])
gc:setColorRGB(0, 0, 0)

platform.window:invalidate()

end

function DrawDirectionalVectors(gc)

if #directionOutput < 2 then return end

local correspondingIndexCount = 1
for _, correspondingIndex in ipairs(directionOutputCorrespondingIndex) do
    local realOpVecIndex = correspondingIndex * 2 - 1
    local dirDirVecIndex = correspondingIndexCount * 2 - 1
    
        dirVecX = directionOutput[dirDirVecIndex] * stretchFactor
        dirVecY = directionOutput[dirDirVecIndex + 1] * stretchFactor
        opVecX = output[realOpVecIndex] * stretchFactor
        opVecY = output[realOpVecIndex + 1] * stretchFactor
        
        --already smooth
        gc:setColorRGB(0, 255, 0)
        gc:drawLine(opVecX, opVecY, opVecX + dirVecX, opVecY + dirVecY)
        DrawSmallArrow(opVecX, opVecY, opVecX + dirVecX, opVecY + dirVecY, gc)
        gc:setColorRGB(0, 0, 0)
        
            gc:setFont("serif","i",8)
            gc:drawString("("..dirVecX / stretchFactor.."|"..dirVecY / stretchFactor..")", (opVecX + dirVecX / 2) + 5, (opVecY + dirVecY / 2), "bottom")
            gc:setFont("serif","r",12)
    
    correspondingIndexCount = correspondingIndexCount + 1
end

end

function CheckStretchFactor()

screenWidth = platform.window:width()
screenHeight = platform.window:height()

--OP VECS
local vecX = null
local biggestXVec = {}
local biggestYVec = {}
local finalBigVec = {}

for _, _vec in ipairs(output) do
    vec = tonumber(_vec)
    if not vecX then vecX = vec else
            
            if vecX * stretchFactor > screenWidth or vec * stretchFactor > screenHeight then
                if #biggestXVec == 0 or biggestXVec[1] < vecX then
                    biggestXVec[1] = vecX
                    biggestXVec[2] = vec
                end
                
                if #biggestYVec == 0 or biggestYVec[2] < vec then
                    biggestYVec[1] = vecX
                    biggestYVec[2] = vec
                end        
            end
        
        vecX = null
    end
end
--OP VECS

--DIR VECS
if #directionOutput >= 2 then

local correspondingIndexCount = 1
for _, correspondingIndex in ipairs(directionOutputCorrespondingIndex) do
    local realOpVecIndex = correspondingIndex * 2 - 1
    local dirDirVecIndex = correspondingIndexCount * 2 - 1
    
        dirVecX = directionOutput[dirDirVecIndex] * stretchFactor
        dirVecY = directionOutput[dirDirVecIndex + 1] * stretchFactor
        opVecX = output[realOpVecIndex] * stretchFactor
        opVecY = output[realOpVecIndex + 1] * stretchFactor
        
        if opVecX + dirVecX > screenWidth or opVecY + dirVecY > screenWidth then ------------------ > overextending op + dir
                if #biggestXVec == 0 or biggestXVec[1] < (opVecX / stretchFactor) + (dirVecX / stretchFactor) then
                    biggestXVec[1] = (opVecX / stretchFactor) + (dirVecX / stretchFactor)
                    biggestXVec[2] = (opVecY / stretchFactor) + (dirVecY / stretchFactor)
                end           
                if #biggestYVec == 0 or biggestYVec[2] < (opVecY / stretchFactor) + (dirVecY / stretchFactor) then
                    biggestXVec[1] = (opVecX / stretchFactor) + (dirVecX / stretchFactor)
                    biggestXVec[2] = (opVecY / stretchFactor) + (dirVecY / stretchFactor)
                end
        end
    
    correspondingIndexCount = correspondingIndexCount + 1
end

end
--DIR VECS






--get highest value being outta screen
if #biggestXVec > 0 and #biggestYVec == 0 then -----take X_VEC
    finalBigVec[1] = biggestXVec[1]
    finalBigVec[2] = biggestXVec[2]
elseif #biggestXVec == 0 and #biggestYVec > 0 then --take Y_VEC
    finalBigVec[1] = biggestYVec[1]
    finalBigVec[2] = biggestYVec[2]
elseif #biggestXVec > 0 and #biggestYVec > 0  then ---both contains smth
    if screenWidth / (biggestXVec[1] * stretchFactor) < screenHeight / (biggestYVec[2] * stretchFactor) then --overextending dist of X_Vec higher (percentage)
        finalBigVec[1] = biggestXVec[1]
        finalBigVec[2] = biggestXVec[2]
    else ------------------------------------------------------------------overextending dist of Y_Vec higher
        finalBigVec[1] = biggestYVec[1]
        finalBigVec[2] = biggestYVec[2]
    end
elseif #biggestXVec == 0 and #biggestYVec == 0 and #output > 0 then --no overextending vectors cotnained
    ExtendStretchFactor()
end

if #finalBigVec == 0 then return end --no overextending vectors

--check
if finalBigVec[1] > finalBigVec[2] then --X biggest component
stretchFactor = screenWidth / finalBigVec[1] -----------------------NEW STRETCH FACTOR
else -------------------------------------Y biggest component
stretchFactor = screenHeight / finalBigVec[2] -----------------------NEW STRETCH FACTOR
end
--check

end --endfunc

function ExtendStretchFactor() --increase factor instead of decreasing
   
screenWidth = platform.window:width()
screenHeight = platform.window:height()

--OP VECS INCREASE
local vecX = null
local biggestXVec = {}
local biggestYVec = {}
local finalBigVec = {}

for _, _vec in ipairs(output) do
    vec = tonumber(_vec)
    if not vecX then vecX = vec else
    
        if #biggestXVec == 0 or biggestXVec[1] < vecX then
            biggestXVec[1] = vecX
            biggestXVec[2] = vec
        end
        
        if #biggestYVec == 0 or biggestYVec[2] < vec then
            biggestYVec[1] = vecX
            biggestYVec[2] = vec
        end        
        
        vecX = null
    end
end
--OP VECS INCREASE

--DIR VECS INCREASE

if #directionOutput >= 2 then

local correspondingIndexCount = 1
for _, correspondingIndex in ipairs(directionOutputCorrespondingIndex) do
    local realOpVecIndex = correspondingIndex * 2 - 1
    local dirDirVecIndex = correspondingIndexCount * 2 - 1
    
        dirVecX = directionOutput[dirDirVecIndex] * stretchFactor
        dirVecY = directionOutput[dirDirVecIndex + 1] * stretchFactor
        opVecX = output[realOpVecIndex] * stretchFactor
        opVecY = output[realOpVecIndex + 1] * stretchFactor
        
            if #biggestXVec == 0 or biggestXVec[1] < (opVecX / stretchFactor) + (dirVecX / stretchFactor) then
                biggestXVec[1] = (opVecX / stretchFactor) + (dirVecX / stretchFactor)
                biggestXVec[2] = (opVecY / stretchFactor) + (dirVecY / stretchFactor)
            end           
            if #biggestYVec == 0 or biggestYVec[2] < (opVecY / stretchFactor) + (dirVecY / stretchFactor) then
                biggestXVec[1] = (opVecX / stretchFactor) + (dirVecX / stretchFactor)
                biggestXVec[2] = (opVecY / stretchFactor) + (dirVecY / stretchFactor)
            end
    
    correspondingIndexCount = correspondingIndexCount + 1
end

end

--DIR VECS INCREASE

local finalBigVec = { }

--get highest value
---both contains smth 100%
    if  screenWidth / (biggestXVec[1] * stretchFactor) < screenWidth / (biggestYVec[2] * stretchFactor) then -- take lower scaling needed (percentage)
        finalBigVec[1] = biggestXVec[1]
        finalBigVec[2] = biggestXVec[2]
    else ------------------------------------------------------------------overextending dist of Y_Vec higher
        finalBigVec[1] = biggestYVec[1]
        finalBigVec[2] = biggestYVec[2]
    end

if #finalBigVec == 0 then return end --no overextending vectors

--check
if finalBigVec[1] > finalBigVec[2] then --X biggest component
stretchFactor = screenWidth / finalBigVec[1] -----------------------NEW STRETCH FACTOR
else -------------------------------------Y biggest component
stretchFactor = screenHeight / finalBigVec[2] -----------------------NEW STRETCH FACTOR
end
--check
    
end --endfunc

-------------------------------------------------------DrawVecs-------------------------------------------------------------------------

-------------------------------------------------------ConnectVecs-------------------------------------------------------------------------
function ConnectVectors(gc)

DrawOPVectors(gc)
DrawDirectionalVectors(gc)

if #directionOutput < 2 then return end

local correspondingIndexCount = 1
for _, correspondingIndex in ipairs(directionOutputCorrespondingIndex) do
    local realOpVecIndex = correspondingIndex * 2 - 1
    local dirDirVecIndex = correspondingIndexCount * 2 - 1
    
        dirVecX = directionOutput[dirDirVecIndex] * stretchFactor
        dirVecY = directionOutput[dirDirVecIndex + 1] * stretchFactor
        opVecX = output[realOpVecIndex] * stretchFactor
        opVecY = output[realOpVecIndex + 1] * stretchFactor
        
        --already smooth
        gc:setColorRGB(255, 0, 0)
        gc:setPen("thin","dotted")
        gc:drawLine(0, 0, opVecX + dirVecX, opVecY + dirVecY)
        gc:setPen("thin","smooth")
        DrawSmallArrow(0, 0, opVecX + dirVecX, opVecY + dirVecY, gc)
        gc:setColorRGB(0, 0, 0)
    
    correspondingIndexCount = correspondingIndexCount + 1
end

platform.window:invalidate()
connectVectors = false

end

-------------------------------------------------------ConnectVecs-------------------------------------------------------------------------


-------------------------------------------------------PrintHelp-------------------------------------------------------
function PrintHelp(gc)

gc:setColorRGB(0, 0, 0)
gc:setFont("serif","r",6)

gc:drawString("Hilfe: ", 5, platform.window:height() - 50, "bottom") 
gc:drawString("Vektor hinzufügen                     : <X>,<Y>", 5, platform.window:height() - 40, "bottom") 
gc:drawString("Ritchtungsvektor hinzufügen      : d,<Stützvektor nummer>,<X>,<Y>", 5, platform.window:height() - 30, "bottom") 
gc:drawString("Vektoren zeichnen lassen          : drw", 5, platform.window:height() - 20, "bottom") 
gc:drawString("Resultierende Vektoren zeichnen: cnt", 5, platform.window:height() - 10, "bottom") 

gc:setFont("serif","r",12)

end
-------------------------------------------------------PrintHelp-------------------------------------------------------








--======================================================Mouse Managing======================================================--

function on.mouseMove(x,y)
    if not checkedWelcome then return end
    
    GetNearestVector(x,y)

end

function GetDistance(x1, y1, x2, y2)

    local resultingX = x2 - x1
    local resultingY = y2 - y1
    
    return GetVecLenght(resultingX, resultingY)

end




function GetNearestVector(mouseX, mouseY)

nearestVec = {}

X = 1
Y = 2

--OP VECS
local vecX = null

for _, _vec in ipairs(output) do
    vec = tonumber(_vec)
    if not vecX then vecX = vec else
        vecX = vecX * stretchFactor
        vec = vec * stretchFactor
        
        local currDistToMouse = GetDistance(mouseX, mouseY, vecX, vec) --vec = Y component
        
        if #nearestVec == 0 or GetDistance(nearestVec[X], nearestVec[Y], mouseX, mouseY) > currDistToMouse then
            nearestVec[X] = vecX
            nearestVec[Y] = vec
        end
        
        vecX = null
    end
end



--DIR VECS

if #directionOutput >= 2 then

    local correspondingIndexCount = 1
    for _, correspondingIndex in ipairs(directionOutputCorrespondingIndex) do
        local realOpVecIndex = correspondingIndex * 2 - 1
        local dirDirVecIndex = correspondingIndexCount * 2 - 1
        
            dirVecX = directionOutput[dirDirVecIndex] * stretchFactor
            dirVecY = directionOutput[dirDirVecIndex + 1] * stretchFactor
            opVecX = output[realOpVecIndex] * stretchFactor
            opVecY = output[realOpVecIndex + 1] * stretchFactor
            
            local currDistToMouse_DirVec = GetDistance(mouseX, mouseY, opVecX + dirVecX, opVecY + dirVecY) --vec = Y component
            
            if #nearestVec == 0 or GetDistance(nearestVec[X], nearestVec[Y], mouseX, mouseY) > currDistToMouse_DirVec then
                nearestVec[X] = opVecX + dirVecX
                nearestVec[Y] = opVecY + dirVecY
            end
        
        correspondingIndexCount = correspondingIndexCount + 1
    end

end


-------------check near

if #nearestVec > 0 and GetDistance(nearestVec[X], nearestVec[Y], mouseX, mouseY) <= circleRadius then --draw circle
    drawCircle = true
else
    drawCircle = false
end

-------------check near

end --endfunc

--======================================================Mouse Managing 222222222================================================--

function on.mouseDown(x,y)

if not drawCircle then return end

if GetDistance(x, y, nearestVec[1], nearestVec[2]) <= circleRadius then
    clickedInCircle = true
end

end --endfunc

function DrawOptionsMenuAfterClick(gc)

local yStep = 30
local rectWidth = 20
local rectHeight = 20

gc:setColorRGB(0, 0, 0)
gc:setFont("serif","bi",10)

gc:drawString("Länge ", 5, yStep, "bottom")
gc:drawRect(170 - rectWidth / 2, yStep - rectHeight / 2, rectWidth, rectHeight)
gc:drawString("Winkel zur X-Achse", 5, yStep*2, "bottom") 
gc:drawRect(170 - rectWidth / 2, yStep*2 - rectHeight / 2, rectWidth, rectHeight)
gc:drawString("Interagieren mit..", 5, yStep*3, "bottom")
gc:drawRect(170 - rectWidth / 2, yStep*3 - rectHeight / 2, rectWidth, rectHeight)

gc:setFont("serif","r",12)

end

--======================================================Mouse Managing======================================================--



