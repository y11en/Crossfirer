﻿#Include, CrossHirer_Functions.ahk  
Preset()
;==================================================================================
global CLK_Service_On := False
CheckPermission(0)
;==================================================================================
If WinExist("ahk_class CrossFire")
{
    CheckPosition(Xe, Ye, We, He, "CrossFire")
    Gui, click_mode: New, +LastFound +AlwaysOnTop -Caption +ToolWindow -DPIScale, Listening ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
    Gui, click_mode: Margin, 0, 0
    Gui, click_mode: Color, 333333 ;#333333
    Gui, click_mode: Font, s15, Microsoft YaHei
    Gui, click_mode: Add, Text, hwndGui_5 vModeClick c00FF00, 连点准备 ;#00FF00
    GuiControlGet, P5, Pos, %Gui_5%
    WinSet, TransColor, 333333 191 ;#333333
    WinSet, ExStyle, +0x20 +0x8; 鼠标穿透以及最顶端
    SetGuiPosition(XGui3, YGui3, "M", -P5W // 2, Round(He / 3) - P5H // 2)
    Gui, click_mode: Show, x%XGui3% y%YGui3% NA
    OnMessage(0x1001, "ReceiveMessage")
    OnMessage(0x1001, "ReceiveActionC")
    CLK_Service_On := True
}
;==================================================================================
~*MButton:: ;爆裂者轰炸
    If CLK_Service_On
    {
        GuiControl, click_mode: +c00FFFF +Redraw, ModeClick ;#00FFFF
        UpdateText("click_mode", "ModeClick", "右键连点", XGui3, YGui3)
        While, !(GetKeyState("R", "P") || GetKeyState("LButton", "P")) && WinActive("ahk_class CrossFire") ;避免切换窗口时影响
        {
            press_key("RButton", 10.0, 50.0)
        }
        GuiControl, click_mode: +c00FF00 +Redraw, ModeClick ;#00FF00
        UpdateText("click_mode", "ModeClick", "连点准备", XGui3, YGui3)
        Send, {Blind}{RButton Up}
    }
Return

~*XButton2:: ;炼狱连刺
    If CLK_Service_On
    {
        GuiControl, click_mode: +c00FFFF +Redraw, ModeClick ;#00FFFF
        UpdateText("click_mode", "ModeClick", "炼狱连刺", XGui3, YGui3)
        cnt := 0
        While, !(GetKeyState("E", "P") || GetKeyState("LButton", "P") || cnt > 10) && WinActive("ahk_class CrossFire")
        {
            press_key("RButton", 10.0, 270.0) ;炼狱右键
            press_key("LButton", 10.0, 10.0) ;炼狱左键枪刺归位
            cnt += 1
        }
        GuiControl, click_mode: +c00FF00 +Redraw, ModeClick ;#00FF00
        UpdateText("click_mode", "ModeClick", "连点准备", XGui3, YGui3)
    }
Return

~*XButton1:: ;半自动速点,适合加特林速点,不适合USP
    If CLK_Service_On
    {
        GuiControl, click_mode: +c00FFFF +Redraw, ModeClick ;#00FFFF
        UpdateText("click_mode", "ModeClick", "左键速点", XGui3, YGui3)
        While, !(GetKeyState("E", "P") || GetKeyState("RButton", "P")) && WinActive("ahk_class CrossFire")
        {
            press_key("LButton", 30.0, 30.0) ;炼狱射速1000/分
        }
        GuiControl, click_mode: +c00FF00 +Redraw, ModeClick ;#00FF00
        UpdateText("click_mode", "ModeClick", "连点准备", XGui3, YGui3)
        Send, {Blind}{LButton Up}
    }
Return

~*8:: ;大宝剑二段连击
    If CLK_Service_On
    {
        GuiControl, click_mode: +c00FFFF +Redraw, ModeClick ;#00FFFF
        UpdateText("click_mode", "ModeClick", "二段连击", XGui3, YGui3)
        press_key("RButton", 1050, 150)
        press_key("RButton", 90, 10)
        While, !(GetKeyState("E", "P") || GetKeyState("LButton", "P")) && WinActive("ahk_class CrossFire")
        {
            press_key("RButton", 490, 10)
        }
        GuiControl, click_mode: +c00FF00 +Redraw, ModeClick ;#00FF00
        UpdateText("click_mode", "ModeClick", "连点准备", XGui3, YGui3)
    }
Return

~*9:: ;粉碎者直射
    If CLK_Service_On
    {
        GuiControl, click_mode: +c00FFFF +Redraw, ModeClick ;#00FFFF
        UpdateText("click_mode", "ModeClick", "左键不放", XGui3, YGui3)
        Send, {Blind}{LButton Up}
        Send, {LButton Down}
        While, !(GetKeyState("R", "P") || GetKeyState("RButton", "P")) && WinActive("ahk_class CrossFire") && !Not_In_Game()
        {
            If !GetKeyState("LButton")
                Send, {LButton Down}
            HyperSleep(100)
        }
        GuiControl, click_mode: +c00FF00 +Redraw, ModeClick ;#00FF00
        UpdateText("click_mode", "ModeClick", "连点准备", XGui3, YGui3)
        Send, {Blind}{LButton Up}
    }
Return

~*0:: ;炼狱热管
    If CLK_Service_On
    {
        GuiControl, click_mode: +c00FFFF +Redraw, ModeClick ;#00FFFF
        UpdateText("click_mode", "ModeClick", "炼狱热管", XGui3, YGui3)
        While, !(GetKeyState("E", "P") || GetKeyState("LButton", "P") || GetKeyState("XButton1", "P")) && WinActive("ahk_class CrossFire") && !Not_In_Game() ;炼狱速点时结束
        {
            press_key("LButton", 10.0, 110.0)
        }
        GuiControl, click_mode: +c00FF00 +Redraw, ModeClick ;#00FF00
        UpdateText("click_mode", "ModeClick", "连点准备", XGui3, YGui3)
    }
Return
;==================================================================================
;学习自AHK论坛中的多脚本间通过端口简单通信函数,接受其他信息
ReceiveActionC(Message) 
{
    global
    If (Message = 123865) && CLK_Service_On
    {
        SetGuiPosition(XGui3, YGui3, "M", -P5W // 2, Round(He / 3) - P5H // 2)
        Gui, click_mode: Show, x%XGui3% y%YGui3% NA
    }
}
;==================================================================================