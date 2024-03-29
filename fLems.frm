VERSION 5.00
Begin VB.Form fLems 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Lems"
   ClientHeight    =   7200
   ClientLeft      =   45
   ClientTop       =   615
   ClientWidth     =   9600
   ClipControls    =   0   'False
   FillStyle       =   0  'Solid
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   FontTransparent =   0   'False
   ForeColor       =   &H00000000&
   HasDC           =   0   'False
   Icon            =   "fLems.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MousePointer    =   99  'Custom
   ScaleHeight     =   480
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   640
   StartUpPosition =   2  'CenterScreen
   Tag             =   "0"
   Begin VB.Timer tmrFullScreenOff 
      Enabled         =   0   'False
      Interval        =   250
      Left            =   9090
      Top             =   5280
   End
   Begin VB.PictureBox picFullScreenOff 
      BorderStyle     =   0  'None
      ClipControls    =   0   'False
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   9
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      Left            =   3675
      ScaleHeight     =   20
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   150
      TabIndex        =   0
      TabStop         =   0   'False
      Top             =   -300
      Width           =   2250
   End
   Begin Lems.ucInfo ucInfo 
      Height          =   270
      Left            =   0
      Top             =   6930
      Width           =   9600
      _ExtentX        =   16933
      _ExtentY        =   476
   End
   Begin Lems.ucToolbar ucToolbar 
      Height          =   480
      Left            =   855
      Tag             =   "0"
      Top             =   4905
      Width           =   7500
      _ExtentX        =   13229
      _ExtentY        =   847
   End
   Begin Lems.ucScreen08 ucPanoramicView 
      Height          =   1200
      Left            =   0
      TabIndex        =   2
      Top             =   5730
      Width           =   9600
      _ExtentX        =   16933
      _ExtentY        =   2117
      BackColor       =   0
   End
   Begin Lems.ucCounter lblButton 
      Height          =   165
      Index           =   1
      Left            =   990
      Top             =   5505
      Width           =   315
      _ExtentX        =   556
      _ExtentY        =   291
   End
   Begin Lems.ucCounter lblButton 
      Height          =   165
      Index           =   2
      Left            =   1575
      Top             =   5505
      Width           =   315
      _ExtentX        =   556
      _ExtentY        =   291
   End
   Begin Lems.ucCounter lblButton 
      Height          =   165
      Index           =   3
      Left            =   2160
      Top             =   5505
      Width           =   315
      _ExtentX        =   556
      _ExtentY        =   291
   End
   Begin Lems.ucCounter lblButton 
      Height          =   165
      Index           =   4
      Left            =   2745
      Top             =   5505
      Width           =   315
      _ExtentX        =   556
      _ExtentY        =   291
   End
   Begin Lems.ucCounter lblButton 
      Height          =   165
      Index           =   5
      Left            =   3330
      Top             =   5505
      Width           =   315
      _ExtentX        =   556
      _ExtentY        =   291
   End
   Begin Lems.ucCounter lblButton 
      Height          =   165
      Index           =   6
      Left            =   3915
      Top             =   5505
      Width           =   315
      _ExtentX        =   556
      _ExtentY        =   291
   End
   Begin Lems.ucCounter lblButton 
      Height          =   165
      Index           =   7
      Left            =   4500
      Top             =   5505
      Width           =   315
      _ExtentX        =   556
      _ExtentY        =   291
   End
   Begin Lems.ucCounter lblButton 
      Height          =   165
      Index           =   8
      Left            =   5085
      Top             =   5505
      Width           =   315
      _ExtentX        =   556
      _ExtentY        =   291
   End
   Begin Lems.ucCounter lblButton 
      Height          =   165
      Index           =   9
      Left            =   5775
      Top             =   5505
      Width           =   315
      _ExtentX        =   556
      _ExtentY        =   291
   End
   Begin Lems.ucCounter lblButton 
      Height          =   165
      Index           =   10
      Left            =   6360
      Top             =   5505
      Width           =   315
      _ExtentX        =   556
      _ExtentY        =   291
   End
   Begin VB.Timer tmrPlusMinus 
      Enabled         =   0   'False
      Left            =   9090
      Top             =   4875
   End
   Begin Lems.ucScreen08 ucScreen 
      Height          =   4800
      Left            =   0
      TabIndex        =   1
      TabStop         =   0   'False
      Top             =   60
      Width           =   9600
      _ExtentX        =   16933
      _ExtentY        =   8467
      BackColor       =   0
   End
   Begin VB.Menu mnuGameTop 
      Caption         =   "&Game"
      Begin VB.Menu mnuGame 
         Caption         =   "Pack"
         Index           =   0
         Begin VB.Menu mnuPack 
            Caption         =   "Lems"
            Index           =   0
         End
         Begin VB.Menu mnuPack 
            Caption         =   "Oh No! More Lems"
            Index           =   1
         End
         Begin VB.Menu mnuPack 
            Caption         =   "-"
            Index           =   2
         End
         Begin VB.Menu mnuPack 
            Caption         =   "Custom"
            Index           =   9
         End
      End
      Begin VB.Menu mnuGame 
         Caption         =   "-"
         Index           =   1
      End
      Begin VB.Menu mnuGame 
         Caption         =   "&Play!"
         Index           =   2
      End
      Begin VB.Menu mnuGame 
         Caption         =   "&Choose level..."
         Index           =   3
      End
      Begin VB.Menu mnuGame 
         Caption         =   "-"
         Index           =   4
      End
      Begin VB.Menu mnuGame 
         Caption         =   "E&xit"
         Index           =   5
      End
   End
   Begin VB.Menu mnuOptionsTop 
      Caption         =   "&Options"
      Begin VB.Menu mnuOptions 
         Caption         =   "&Sound effects"
         Checked         =   -1  'True
         Index           =   0
      End
      Begin VB.Menu mnuOptions 
         Caption         =   "&Music"
         Index           =   1
      End
      Begin VB.Menu mnuOptions 
         Caption         =   "-"
         Index           =   2
      End
      Begin VB.Menu mnuOptions 
         Caption         =   "&Full screen"
         Index           =   3
      End
   End
   Begin VB.Menu mnuHelpTop 
      Caption         =   "&Help"
      Begin VB.Menu mnuHelp 
         Caption         =   "&About..."
         Index           =   0
      End
      Begin VB.Menu mnuHelp 
         Caption         =   "-"
         Index           =   1
      End
      Begin VB.Menu mnuHelp 
         Caption         =   "Go to &Lems' page..."
         Index           =   2
      End
   End
End
Attribute VB_Name = "fLems"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'========================================================================================
' Project:       Lems
' Author:        Carles P.V. ©2005-2011
' Dependencies:  -
' First release: 2005.07.08
' Last revision: 2011.12.05
'========================================================================================

Option Explicit

Private Const LEMS_LINK = "http://www.planet-source-code.com/vb/scripts/ShowCode.asp?txtCodeId=61601&lngWId=1"
Private Const LAST_REVISION = "2011/12/05"

'========================================================================================
' GUI initialization
'========================================================================================

Public Enum eGamePackConstants
    [ePackLems] = 0
    [ePackOhNoMoreLems] = 1
    [ePackCustom] = 9
End Enum

Public Enum eGameModeConstants
    [eModeMenuScreen] = 1
    [eModeLevelScreen]
    [eModePlaying]
    [eModeGameScreen]
End Enum

Private Sub Form_Load()
    
    '-- Advice!
    If (InIDE()) Then
        Call VBA.MsgBox( _
             "Please, compile me for full speed!", _
             vbExclamation _
             )
    End If
    If (ScreenColourDepth < 16) Then
        Call VBA.MsgBox( _
             "Please, run me on screen color depths >= 16-bit!", _
             vbExclamation _
             )
    End If

    '-- Initialize modules
    Call InitializeLemsRenderer
    Call InitializeLems
    Call InitializeLevel
    Call InitializeSound
    Call InitializeMusic
    Call InitializeHook(Me)
    Call InitializeFullScreen(Me)
   
    '-- Initialize toolbar
    Call ucToolbar.BuildToolbar( _
         VB.LoadResPicture("TB_MAIN", vbResBitmap), _
         vbMagenta, 32, _
         "OOOOOOOO|NN|CN|N" _
         )
    
    '-- Initialize main view
    With ucScreen
        Call .Initialize(320, 160, 2)
        Call .UpdatePalette(GetGlobalPalette())
    End With

    '-- Initialize panoramic view
    With ucPanoramicView
        Call .Initialize(640, 80, 1)
        Call .UpdatePalette(GetGlobalPalette())
    End With
       
    '-- Start...
    With Me
        
        '-- App. cursor
        Set MouseIcon = VB.LoadResPicture("CUR_HAND", vbResCursor)

        '-- App. "color"
        Call pvSetWindowColor(Clr:=GetWindowColor())
        
        '-- Disable toolbar
        Call pvSetToolbarState(bEnable:=False)
        
        '-- Load settings
        g_nLevelID = GetLastLevel()
        g_eGamePack = g_nLevelID \ 1000
        mnuPack(g_eGamePack).Checked = True
        LemsSavedMode = GetSavedLemsMode()
        
        '-- Update menus' accelerators
        mnuOptions(0).Caption = mnuOptions(0).Caption & vbTab & "S"
        mnuOptions(1).Caption = mnuOptions(1).Caption & vbTab & "M"
        mnuOptions(3).Caption = mnuOptions(3).Caption & vbTab & "F11"
        
        '-- Show menu screen
        Call ShowMenuScreen
        Call pvSetPlayMenuState(bEnable:=True)
    End With
End Sub

Private Sub Form_Unload(Cancel As Integer)
    
    '-- Stop timer
    Call StopTimer
    
    '-- Terminate main module
    Call TerminateLems
    
    '-- Stop midi
    Call TerminateMusic
    Call CloseMidi
    
    '-- Save settings
    Call SetLastLevel(g_nLevelID)
    Call SetWindowColor(Me.BackColor)
    Call SetSavedLemsMode(LemsSavedMode)
    
    '-- Restore screen
    If (IsFullScreen) Then
        Call ToggleFullScreen
    End If
End Sub

'========================================================================================
' Menu
'========================================================================================

Private Sub mnuPack_Click(Index As Integer)
      
    '-- Uncheck and check
    mnuPack(g_eGamePack).Checked = False
    mnuPack(Index).Checked = True
    
    '-- Set level pack ID and reset to first level
    g_eGamePack = Index
    g_nLevelID = Index * 1000
End Sub

Private Sub mnuGame_Click(Index As Integer)
    
    Call VBA.DoEvents
    
    Select Case Index
    
        Case 2 '-- Play!
            
            '-- Load current level data and show 'level screen'
            If (LoadLevel(g_nLevelID)) Then
                Call ShowLevelScreen
                Call pvSetPlayMenuState(bEnable:=False)
              Else
                Call VBA.MsgBox( _
                     "Unable to load level (ID=" & g_nLevelID & ") ", _
                     vbExclamation _
                     )
           End If
            
        Case 3 '-- Choose level...
        
            Call fLevel.Show(vbModal, Me)
        
        Case 5 '-- Exit
        
            Call VB.Unload(Me)
    End Select
End Sub

Private Sub mnuOptions_Click(Index As Integer)
    
    Select Case Index
        
        Case 0 '-- Sound effects on/off
        
            mnuOptions(0).Checked = Not mnuOptions(0).Checked
            Call SetSoundEffectsState(CBool(mnuOptions(0).Checked))
            If (Me.Tag = [eModeMenuScreen]) Then
                Call ShowMenuScreen
                Call pvSetPlayMenuState(bEnable:=True)
            End If
            
        Case 1 '-- Music on/off
        
            mnuOptions(1).Checked = Not mnuOptions(1).Checked
            Call SetMusicState(CBool(mnuOptions(1).Checked))
            If (Me.Tag = [eModeMenuScreen]) Then
                Call ShowMenuScreen
                Call pvSetPlayMenuState(bEnable:=True)
            End If
            
        Case 3 '-- Full screen
        
            tmrFullScreenOff.Enabled = False
            picFullScreenOff.Top = -picFullScreenOff.Height
            If (ToggleFullScreen) Then
                Call pvSetMenuVisible(Not IsFullScreen)
            End If
    End Select
End Sub

Private Sub mnuHelp_Click(Index As Integer)
     
    Select Case Index
    
        Case 0 '-- About...
        
            Call VBA.MsgBox( _
                 vbCrLf & _
                 "Lems" & vbCrLf & _
                 "&" & vbCrLf & _
                 "Oh No! More Lems" & vbCrLf & vbCrLf & _
                 "Remake of the well-known classic game" & Space$(5) & vbCrLf & vbCrLf & _
                 "First release: 7/8/2005" & vbCrLf & _
                 "Current version: " & App.Major & "." & App.Minor & "." & App.Revision & vbCrLf & _
                 "Date: " & LAST_REVISION & vbCrLf & vbCrLf & _
                 "Carles P.V. © 2005-2011" & vbCrLf & vbCrLf _
                 , vbInformation, _
                 "About" _
                 )
                 
        Case 2 '-- Goto Lems' page...
        
            If (VBA.MsgBox( _
                "You will be navigated to Lems' home page.", _
                vbYesNo Or vbInformation) = vbYes _
                ) Then
                
                Call Navigate(Me.hwnd, LEMS_LINK)
            End If
    End Select
End Sub

'========================================================================================
' Accelerators
'========================================================================================

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
    
    Select Case KeyCode
    
        Case vbKeyEscape
        
            Select Case Me.Tag

                Case [eModePlaying]

                    '-- Quit game
                    If (IsTimerPaused) Then
                        Call Form_KeyDown(vbKeySpace, 0)
                    End If
                    Call SetGameStage([eStageEnding])
                    
                Case Else

                    '-- Show menu screen
                    Call ShowMenuScreen
                    Call pvSetPlayMenuState(bEnable:=True)
            End Select
            
        Case vbKeyA
            
            '-- Scroll view to right
            If (Me.Tag = [eModePlaying]) Then
                Call DoScroll(64)
            End If
            
        Case vbKeyZ
            
            '-- Scroll view to left
            If (Me.Tag = [eModePlaying]) Then
                Call DoScroll(-64)
            End If
        
        Case vbKeyX
            
            '-- Center view
            If (Me.Tag = [eModePlaying]) Then
                Call DoScrollTo(x:=640, ScaleAndCenter:=False)
            End If
            
        Case vbKey1 To vbKey8
            
            '-- Job/Ability selection
            If (Me.Tag = [eModePlaying]) Then
                With ucToolbar
                    If (.IsButtonEnabled(KeyCode - 48)) Then
                        If (Not .IsButtonChecked(KeyCode - 48)) Then
                            Call .CheckButton(KeyCode - 48, True)
                            Call ucToolbar_ButtonClick(KeyCode - 48, 0, 0, 0)
                        End If
                    End If
                End With
            End If
           
        Case vbKeySpace
            
            '-- Pause on/off
            If (Me.Tag = [eModePlaying]) Then
                With ucToolbar
                    Call .CheckButton(11, Not .IsButtonChecked(11))
                    Call ucToolbar_ButtonClick(11, 0, 0, 0)
                End With
            End If
            
        Case vbKeyS
            
            '-- Sound effects on/off
            Call mnuOptions_Click(0)
            
        Case vbKeyM
        
            '-- Music on/off
            Call mnuOptions_Click(1)
            
        Case vbKeyL ' Also by clicking panel
            
            '-- Cycle through 'Lems Saved' panel modes
            Call CycleLemsSavedModes
            
        Case vbKeyC
            
            '-- :-))
            If (Shift = vbCtrlMask) Then
                Call pvSetWindowColor(vbButtonFace)
              Else
                Call pvSetWindowColor(-1)
            End If
            
        Case vbKeyF5
            
            '-- Info
            If (Me.Tag = [eModePlaying]) Then
                InfoState = Not InfoState
            End If
            
        Case vbKeyF11

            '-- Full screen on/off
            Call mnuOptions_Click(3)
        
        Case vbKeyF12
            
            '-- Screenshot
            If (Shift = vbCtrlMask) Then
                If (Me.Tag = [eModePlaying]) Then
                    Call CopyWholeScreenToClipboard
                End If
              Else
                Call ucScreen.DIB.CopyToClipboard
            End If
    End Select
    
    If (Me.Tag = [eModePlaying]) Then
        Call ProcessCheatCode(KeyCode)
    End If
End Sub

'========================================================================================
' Main screen
'========================================================================================

Private Sub ucScreen_MouseUp(Button As Integer, Shift As Integer, x As Long, y As Long)
    
    Select Case Me.Tag
    
        Case [eModeMenuScreen]
        
             Select Case Button
            
                Case vbLeftButton
                    
                    '-- Force Play
                    Call mnuGame_Click(2)
           
                Case vbRightButton
        
                    '-- Choose level...
                    Call mnuGame_Click(3)
            End Select
        
        Case [eModeLevelScreen]
            
            Select Case Button
            
                Case vbLeftButton
            
                    '-- State flag
                    Me.Tag = [eModePlaying]
                    
                    '-- Initialize game
                    Call InitializeGame
                    
                    '-- Enable toolbar / show features
                    Call ShowLevelFeatures
                    
                    '-- Start 'framing'
                    Call StartTimer
                
                Case vbRightButton
                
                    '-- Show menu screen
                    Call ShowMenuScreen
                    Call pvSetPlayMenuState(bEnable:=True)
            End Select
        
        Case [eModePlaying]
        
            Select Case Button
            
                Case vbLeftButton
                    
                    '-- Apply prepared job or ability, if any
                    Call ApplyPrepared
                
                Case vbRightButton
                
                    '-- Quit game
                    If (IsTimerPaused) Then
                        Call Form_KeyDown(vbKeySpace, 0)
                    End If
                    Call SetGameStage([eStageEnding])
            End Select
            
        Case [eModeGameScreen]
            
            '-- Success?
            If (GetLemsSaved() >= g_uLevel.LemsToBeSaved) Then
                g_nLevelID = GetNextLevel()
            End If

            Select Case Button
            
                Case vbLeftButton
                    
                    '-- Play level again
                    Call mnuGame_Click(2)
           
                Case vbRightButton
        
                    '-- Show menu screen
                    Call ShowMenuScreen
                    Call pvSetPlayMenuState(bEnable:=True)
            End Select
    End Select
End Sub

'========================================================================================
' Toolbar
'========================================================================================

Private Sub ucToolbar_ButtonClick(ByVal Index As Long, ByVal MouseButton As Integer, ByVal xLeft As Long, ByVal yTop As Long)
    
    If (Me.Tag = [eModePlaying]) Then
        
        With ucToolbar

            Select Case Index
            
                Case Is = 1, 2, 3
                
                    '-- Prepare ability (Climber, Floater, Bomber)
                    Call PrepareAbility(2 ^ (Index - 1))
                    Call PlaySoundFX([eFXChangeOp])
                
                Case Is = 4, 5, 6, 7, 8
                
                    '-- Prepare job (Blocker, Builder, Basher, Miner, Digger)
                    Call PrepareJob(Index - 3)
                    Call PlaySoundFX([eFXChangeOp])
                    
                Case Is = 11
                    
                    '-- Pause on/off
                    Call PauseTimer(.IsButtonChecked(11))
                    If (IsTimerPaused) Then
                        Call ucScreen.UpdatePalette( _
                             GetFadedOutGlobalPalette(Amount:=25) _
                             )
                        Call DoFrame
                      Else
                        Call ucScreen.UpdatePalette( _
                             GetGlobalPalette() _
                             )
                    End If
            
                Case Is = 13
                    
                    '-- Activate Armageddon? (Needs double-click)
                    If (IsTimerPaused = False) Then
                        If (VBA.Timer() - .Tag < 0.5) Then
                            If (IsArmageddonActivated = False) Then
                                Call StartArmageddon
                            End If
                        End If
                        .Tag = VBA.Timer()
                    End If
            End Select
        End With
    End If
End Sub

'== Plus/Minus buttons ==================================================================

Private Sub ucToolbar_MouseDown(ByVal Index As Long, ByVal MouseButton As Integer, ByVal xLeft As Long, ByVal yTop As Long)
    
    '-- Plus-minus buttons ?
    If (Index = 9 Or Index = 10) Then
    
        '-- If playing, enable plus-minus timer
        If (Me.Tag = [eModePlaying]) Then
        
            tmrPlusMinus.Interval = 300 ' Initial delay
            tmrPlusMinus.Enabled = True ' Start "ticking"
            Call tmrPlusMinus_Timer     ' Force first tick
        End If
    End If
End Sub

Private Sub ucToolbar_MouseUp(ByVal Index As Long, ByVal MouseButton As Integer, ByVal xLeft As Long, ByVal yTop As Long)
    
    '-- Disable plus-minus timer
    tmrPlusMinus.Enabled = False
End Sub

Private Sub tmrPlusMinus_Timer()
    
    '-- Accelerate timer
    If (tmrPlusMinus.Interval = 300) Then
        tmrPlusMinus.Interval = 30
    End If
    
    Select Case True
        
        Case ucToolbar.IsButtonPressed(9)
            
            '-- Increase release rate by one
            If (g_lReleaseRate < RELEASE_RATE_MAX) Then
                g_lReleaseRate = g_lReleaseRate + 1
                lblButton(9).Caption = g_lReleaseRate
            End If
        
        Case ucToolbar.IsButtonPressed(10)
            
            '-- Decrease release rate by one
            If (g_lReleaseRate > g_lReleaseRateMin) Then
                g_lReleaseRate = g_lReleaseRate - 1
                lblButton(9).Caption = g_lReleaseRate
            End If
    End Select
End Sub

'== Panoramic view scrolling  ===========================================================

Private Sub ucPanoramicView_MouseDown(Button As Integer, Shift As Integer, x As Long, y As Long)
    Call ucPanoramicView_MouseMove(Button, Shift, x, y)
End Sub

Private Sub ucPanoramicView_MouseMove(Button As Integer, Shift As Integer, x As Long, y As Long)
    
    If (Me.Tag = [eModePlaying]) Then
        If (Button = vbLeftButton) Then
            '-- Scroll view to x
            Call DoScrollTo(x:=x, ScaleAndCenter:=True)
        End If
    End If
End Sub

'========================================================================================
' Full screen off
'========================================================================================

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
' picFullScreenOff.Tag: MouseMove flag
' tmrFullScreenOff.Tag: tick counter

    On Error Resume Next
    
    If (IsFullScreen) Then
        If (y = 0 And tmrFullScreenOff.Enabled = False And picFullScreenOff.Tag = 0) Then
            tmrFullScreenOff.Enabled = True
            tmrFullScreenOff.Tag = 0
        End If
        picFullScreenOff.Tag = 0
    End If
    
    On Error GoTo 0
End Sub

Private Sub tmrFullScreenOff_Timer()
    
    If (GetCursorYPos() < picFullScreenOff.Height And tmrFullScreenOff.Tag <= 5) Then
        If (picFullScreenOff.Top < 0) Then
            picFullScreenOff.Top = 0
        End If
        tmrFullScreenOff.Tag = tmrFullScreenOff.Tag + 1
      Else
        tmrFullScreenOff.Enabled = False
        picFullScreenOff.Top = -picFullScreenOff.Height
        picFullScreenOff.Tag = 1
    End If
End Sub

Private Sub picFullScreenOff_Paint()
    
  Dim s As String
  
    s = "Exit full screen (F11)"
    
    picFullScreenOff.CurrentX = (picFullScreenOff.Width - picFullScreenOff.TextWidth(s)) \ 2
    picFullScreenOff.CurrentY = 2
    picFullScreenOff.Print s;
End Sub

Private Sub picFullScreenOff_Click()
    
    '-- Toggle full-screen
    Call mnuOptions_Click(3)
End Sub

'========================================================================================
' Methods
'========================================================================================

Friend Sub LevelDone()
    
    '-- Reset pointer
    Set ucScreen.UserIcon = Nothing
    
    '-- Reset panoramic screen
    With ucPanoramicView
        Call .DIB.Reset
        Call .Refresh
    End With
    
    '-- Disable toolbar
    Call pvSetToolbarState(bEnable:=False)
    
    '-- Show game results
    Call ShowGameScreen
End Sub

'========================================================================================
' Private
'========================================================================================

Private Sub pvSetWindowColor( _
        Optional ByVal Clr As Long = -1 _
        )
 
  Dim lRet As Long
  Dim i    As Long
    
    '-- Open color dialog
    If (Clr = -1) Then
        lRet = mDialogColor.SelectColor( _
               Me.hwnd, _
               TranslateColor(BackColor), _
               Extended:=True _
               )
      Else
        lRet = Clr
    End If
    
    '-- Valid color
    If (lRet <> -1) Then
        
        '-- :-))
        Me.BackColor = lRet
        Me.picFullScreenOff.BackColor = lRet
        Me.picFullScreenOff.ForeColor = IIf(lRet = vbButtonFace, vbButtonText, BestConstrastColor(lRet))
        Me.ucToolbar.BackColor = lRet
        Me.ucInfo.BackColor = lRet
        For i = 1 To 10
            Me.lblButton(i).BackColor = lRet
        Next i
    End If
End Sub

Private Sub pvSetMenuVisible(ByVal bVisible As Boolean)

    '-- Show/hide menu
    mnuGameTop.Visible = bVisible
    mnuOptionsTop.Visible = bVisible
    mnuHelpTop.Visible = bVisible
End Sub

Private Sub pvSetPlayMenuState(ByVal bEnable As Boolean)

    '-- Enable/disable menu items
    mnuGame(0).Enabled = bEnable
    mnuGame(2).Enabled = bEnable
    mnuGame(3).Enabled = bEnable
End Sub

Private Sub pvSetToolbarState(ByVal bEnable As Boolean)
    
  Dim i As Long
    
    '-- Update toolbar buttons
    For i = 1 To ucToolbar.ButtonsCount
        Call ucToolbar.CheckButton(i, False)
        Call ucToolbar.EnableButton(i, bEnable)
    Next i
    
    '-- Update skills labels
    For i = 1 To lblButton.Count
        lblButton(i).Caption = vbNullString
    Next i
    
    '-- Update panels text
    For i = 1 To 5
        ucInfo.PanelText(i) = vbNullString
    Next i
End Sub
