/*
go to line 87 for instructions
on how to change the directional keys
used by this script
*/
global OriginXPos := 500
global OriginYPos := 500
global NewXPos := 0
global NewYPos := 0

; Higher number = less sensitive
global Sensitivity := 16
global XAxisCheckMultiplier := 2.415
global YAxisCheckMultiplier := 0.414

global RiseLine := 0
global FallLine := 0

GetMouseInput()
{
    MouseMove OriginXPos, OriginYPos, 0
    MouseGetPos, NewXPos, NewYPos
}

ConvertLineToBool(Line)
{
    if (Line < NewYPos)
	{
	    return false
	}
	else if (Line > NewYPos)
	{
	    return true
	}
}

InterpretAxis(AxisCheckMultiplier)
{
	RiseLine := (NewXPos - OriginXPos) * AxisCheckMultiplier + OriginYPos
    FallLine := (NewXPos - OriginXPos) * -AxisCheckMultiplier + OriginYPos
	
	RiseLine := ConvertLineToBool(RiseLine)
	FallLine := ConvertLineToBool(FallLine)
}

OutputAxis(NegativeOutput, PositiveOutput, Comp1, Comp2, Comp3, Comp4)
{
    if (RiseLine = Comp1) and (FallLine = Comp2)
	{
        Send % "{Blind}{" PositiveOutput " DownR}"
        Send % "{Blind}{" NegativeOutput " up}"
    }
	else if (RiseLine = Comp3) and (FallLine = Comp4)
	{
        Send % "{Blind}{" NegativeOutput " DownR}"
        Send % "{Blind}{" PositiveOutput " up}"
    }
	else
	{
        Send % "{Blind}{" NegativeOutput " up}"
        Send % "{Blind}{" PositiveOutput " up}"
    }
}

ConvertMouseToDirection(Left, Right, Up, Down)
{
    CircleEvaluation := ((NewXPos - OriginXPos) ** 2) + ((NewYPos - OriginYPos) ** 2)
    if (CircleEvaluation < Sensitivity)
	{
	    NewXPos := OriginXPos
		NewYPos := OriginYPos
	}
  
    InterpretAxis(XAxisCheckMultiplier)
    OutputAxis(Left, Right, true, false, false, true)
	InterpretAxis(YAxisCheckMultiplier)
    OutputAxis(Down, Up, true, true, false, false)
}

ScriptMain()
{
    if not WinActive("ahk_exe GuiltyGearXrd.exe")
        return

    GetMouseInput()
	/*
	hello. below this comment block is a function call.
	that function call has a list of keys being passed
	into it. this list determines which keys this script
	interacts with. in order to change them, simply replace
	what's in the quotes with you're desired keys. if a
	key you want isn't a simple letter, refer to this list
	of identifier names: https://www.autohotkey.com/docs/v1/KeyList.htm
	the order the keys are listed is left, right, up, down.
	an example of a replacement which sets this script to control
	the arrow keys: ("Left", "Right", "Up", "Down")
	this block would replace ("a", "d", "w", "s")
	i sincerely hope this makes sense.
	*/
    ConvertMouseToDirection("a", "d", "w", "s")
    Sleep 1
}

SendMode, Input
Loop
{
    ScriptMain()
}