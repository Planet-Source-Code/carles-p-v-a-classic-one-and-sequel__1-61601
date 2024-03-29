VERSION 5.00
Begin VB.UserControl ucToolbar 
   Alignable       =   -1  'True
   AutoRedraw      =   -1  'True
   CanGetFocus     =   0   'False
   ClientHeight    =   1500
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   1500
   ClipControls    =   0   'False
   ForeColor       =   &H80000014&
   LockControls    =   -1  'True
   ScaleHeight     =   100
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   100
   Begin VB.Timer tmrTip 
      Enabled         =   0   'False
      Interval        =   50
      Left            =   0
      Top             =   0
   End
   Begin VB.Label lblTipRect 
      BackStyle       =   0  'Transparent
      Height          =   270
      Left            =   -375
      TabIndex        =   0
      Top             =   0
      Width           =   300
   End
End
Attribute VB_Name = "ucToolbar"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'================================================
' User control:  ucToolbar.ctl (lite)
' Author:        Carles P.V.
' Dependencies:  -
' First release: 2003.09.16 (v2.2)
' Last revision: 2011.05.25 (lite)
'================================================

Option Explicit

'-- API:

Private Type RECT
    x1 As Long
    y1 As Long
    x2 As Long
    y2 As Long
End Type

Private Type POINTAPI
    x As Long
    y As Long
End Type

Private Const ILC_MASK        As Long = &H1
Private Const ILC_COLORDDB    As Long = &HFE
Private Const ILD_TRANSPARENT As Long = 1
Private Const DST_ICON        As Long = &H3
Private Const DSS_MONO        As Long = &H80
Private Const CLR_INVALID     As Long = &HFFFF

Private Declare Function SetRect Lib "user32" (lpRect As RECT, ByVal x1 As Long, ByVal y1 As Long, ByVal x2 As Long, ByVal y2 As Long) As Long
Private Declare Function PtInRect Lib "user32" (lpRect As RECT, ByVal x As Long, ByVal y As Long) As Long
Private Declare Function InflateRect Lib "user32" (lpRect As RECT, ByVal dx As Long, ByVal dy As Long) As Long
Private Declare Function OffsetRect Lib "user32" (lpRect As RECT, ByVal x As Long, ByVal y As Long) As Long
Private Declare Function IsRectEmpty Lib "user32" (lpRect As RECT) As Long
Private Declare Function FillRect Lib "user32" (ByVal hDC As Long, lpRect As RECT, ByVal hBrush As Long) As Long
Private Declare Function SetPixelV Lib "gdi32" (ByVal hDC As Long, ByVal x As Long, ByVal y As Long, ByVal crColor As Long) As Long
Private Declare Function CreateSolidBrush Lib "gdi32" (ByVal crColor As Long) As Long
Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Private Declare Function ReleaseCapture Lib "user32" () As Long
Private Declare Function GetCursorPos Lib "user32" (lpPoint As POINTAPI) As Long
Private Declare Function WindowFromPoint Lib "user32" (ByVal xPoint As Long, ByVal yPoint As Long) As Long
Private Declare Function OleTranslateColor Lib "olepro32" (ByVal OLE_COLOR As Long, ByVal hPalette As Long, pccolorref As Long) As Long
Private Declare Function ImageList_Create Lib "comctl32" (ByVal MinCx As Long, ByVal MinCy As Long, ByVal Flags As Long, ByVal cInitial As Long, ByVal cGrow As Long) As Long
Private Declare Function ImageList_AddMasked Lib "comctl32" (ByVal hImageList As Long, ByVal hbmImage As Long, ByVal crMask As Long) As Long
Private Declare Function ImageList_Destroy Lib "comctl32" (ByVal hImageList As Long) As Long
Private Declare Function ImageList_Draw Lib "comctl32" (ByVal hIml As Long, ByVal i As Long, ByVal hDCDst As Long, ByVal x As Long, ByVal y As Long, ByVal fStyle As Long) As Long
Private Declare Function ImageList_GetImageCount Lib "comctl32" (ByVal hImageList As Long) As Long
Private Declare Function ImageList_GetIcon Lib "comctl32" (ByVal hImageList As Long, ByVal ImgIndex As Long, ByVal fuFlags As Long) As Long
Private Declare Function DestroyIcon Lib "user32" (ByVal hIcon As Long) As Long
Private Declare Function DrawState Lib "user32" Alias "DrawStateA" (ByVal hDC As Long, ByVal hBrush As Long, ByVal lpDrawStateProc As Long, ByVal lParam As Long, ByVal wParam As Long, ByVal x As Long, ByVal y As Long, ByVal cX As Long, ByVal cY As Long, ByVal fuFlags As Long) As Long

Private Declare Sub mouse_event Lib "user32" (ByVal dwFlags As Long, ByVal dx As Long, ByVal dy As Long, ByVal cButtons As Long, ByVal dwExtraInfo As Long)
Private Const MOUSEEVENTF_LEFTDOWN  As Long = &H2
Private Const MOUSEEVENTF_RIGHTDOWN As Long = &H8

Private Declare Function GetAsyncKeyState Lib "user32" (ByVal vKey As Long) As Integer
Private Const VK_LBUTTON As Long = &H1
Private Const VK_RBUTTON As Long = &H2
Private Const VK_MBUTTON As Long = &H4

Private Declare Function GetSystemMetrics Lib "user32" (ByVal nIndex As Long) As Long
Private Const SM_SWAPBUTTON As Long = 23

'-- Private enums.:
Private Enum eButtonStateConstants
    [eDown] = -1
    [eFlat] = 0
    [eOver] = 1
End Enum

Private Enum eButtonTypeConstants
    [eNormal] = 0
    [eCheck] = 1
    [eOption] = 2
End Enum

Private Enum eMouseEventConstants
    [eMouseDown] = -1
    [eMouseMove] = 0
    [eMouseUp] = 1
End Enum

'-- Private types:
Private Type tButton
    Type      As eButtonTypeConstants
    State     As eButtonStateConstants
    Enabled   As Boolean
    Checked   As Boolean
    Over      As Boolean
    Separator As RECT
End Type

'-- Private constants:
Private Const BT_STNORMAL  As String = "N"
Private Const BT_STCHECK   As String = "C"
Private Const BT_STOPTION  As String = "O"
Private Const BT_SEPARATOR As String = "|"

'-- Private variables:
Private m_hIL             As Long    ' Image list handle
Private m_lBackColor      As Long    ' BackColor (RGB)
Private m_hFaceBrush      As Long    ' Brush (button face)
Private m_hHighlightBrush As Long    ' Brush (button highlight for disabled icon)
Private m_hShadowBrush    As Long    ' Brush (button shadow for disabled icon)
Private m_uBarRect        As RECT    ' Bar rectangle
Private m_uButtonRect()   As RECT    ' Button rects.
Private m_uButton()       As tButton ' Buttons
Private m_sTooltip()      As String  ' Tool tips
Private m_nCount          As Integer ' Button count
Private m_nLastOver       As Integer ' Last over
Private m_nIconSize       As Integer ' Icon size (W = H)
Private m_nButtonSize     As Integer ' Button size (W = H)
Private m_nButtonMouse    As Integer ' Temp. mouse button

'-- Event declarations:
Public Event ButtonClick(ByVal Index As Long, ByVal MouseButton As Integer, ByVal xLeft As Long, ByVal yTop As Long)
Public Event ButtonCheck(ByVal Index As Long, ByVal xLeft As Long, ByVal yTop As Long)
Public Event MouseDown(ByVal Index As Long, ByVal MouseButton As Integer, ByVal xLeft As Long, ByVal yTop As Long)
Public Event MouseUp(ByVal Index As Long, ByVal MouseButton As Integer, ByVal xLeft As Long, ByVal yTop As Long)



'==================================================================================================
' UserControl
'==================================================================================================

Private Sub UserControl_Terminate()

    '-- Destroy image list, ...
    Call pvDestroyIL
    '   ... pens and brushes
    If (m_hFaceBrush) Then DeleteObject m_hFaceBrush
    If (m_hHighlightBrush) Then DeleteObject m_hHighlightBrush
    If (m_hShadowBrush) Then DeleteObject m_hShadowBrush
End Sub

Private Sub UserControl_Show()

    '-- Refresh on start up
    Call pvRefresh
End Sub

Private Sub UserControl_Resize()
    
    '-- Alignment
    m_uBarRect.x2 = ScaleWidth
    '-- Refresh whole control
    Call FillRect(hDC, m_uBarRect, m_hFaceBrush)
    Call pvRefresh
End Sub

Private Sub UserControl_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
  
  Dim nBtn As Integer
    
    '-- Restore last
    If (m_nLastOver) Then
        Call pvUpdateButtonState(m_nLastOver, 0, 0, [eMouseMove])
    End If
    '-- Update tooltip label pos.
    For nBtn = 1 To m_nCount
        If (PtInRect(m_uButtonRect(nBtn), x, y) And m_uButton(nBtn).Enabled) Then
            Call pvSetTipArea(nBtn)
            m_nLastOver = nBtn
        End If
    Next nBtn
End Sub

Private Sub lblTipRect_DblClick()
    
    '-- Preserve second click
    If (GetSystemMetrics(SM_SWAPBUTTON) = 0) Then
        If (GetAsyncKeyState(VK_RBUTTON) >= 0 And GetAsyncKeyState(VK_MBUTTON) >= 0) Then
            Call mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0)
        End If
      Else
        If (GetAsyncKeyState(VK_LBUTTON) >= 0 And GetAsyncKeyState(VK_MBUTTON) >= 0) Then
            Call mouse_event(MOUSEEVENTF_RIGHTDOWN, 0, 0, 0, 0)
        End If
    End If
End Sub

Private Sub lblTipRect_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    
    If (m_nLastOver) Then
        If (m_uButton(m_nLastOver).Enabled And m_nButtonMouse = vbEmpty) Then
            '-- Refresh state
            Call pvUpdateButtonState(m_nLastOver, True, Button, [eMouseDown])
        End If
        m_nButtonMouse = Button
    End If
End Sub

Private Sub lblTipRect_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    
  Dim lx As Long
  Dim ly As Long
    
    If (m_nLastOver) Then
        If (m_uButton(m_nLastOver).Enabled) Then
            '-- Translate to [pixels]
            lx = x \ Screen.TwipsPerPixelX + lblTipRect.Left
            ly = y \ Screen.TwipsPerPixelY + lblTipRect.Top
            '-- Refresh state
            Call pvUpdateButtonState(m_nLastOver, PtInRect(m_uButtonRect(m_nLastOver), lx, ly) <> 0, Button, [eMouseMove])
        End If
        If (Button = vbLeftButton) Then tmrTip.Enabled = True
    End If
End Sub

Private Sub lblTipRect_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
  
  Dim lx As Long
  Dim ly As Long
    
    If (m_nLastOver) Then
        If (m_uButton(m_nLastOver).Enabled) Then
            '-- Translate to [pixels]
            lx = x \ Screen.TwipsPerPixelX + lblTipRect.Left
            ly = y \ Screen.TwipsPerPixelY + lblTipRect.Top
            '-- Refresh state
            Call pvUpdateButtonState(m_nLastOver, PtInRect(m_uButtonRect(m_nLastOver), lx, ly) <> 0, Button, [eMouseUp])
            m_nButtonMouse = 0
            Call ReleaseCapture
        End If
    End If
End Sub

'==================================================================================================
' Methods
'==================================================================================================

Public Sub Refresh()

    '-- Refresh whole bar
    Call pvRefresh
End Sub

Public Function BuildToolbar( _
                Image As StdPicture, _
                ByVal MaskColor As OLE_COLOR, _
                ByVal IconSize As Integer, _
                Optional ByVal FormatMask As String _
                ) As Boolean
    
  Dim nIdx As Integer
  Dim nBtn As Integer
  Dim sKey As String
  Dim lPos As Long
    
    If (pvExtractImages(Image, MaskColor, IIf(IconSize > 0, IconSize, 1))) Then
        
        '-- Missing 'FormatMask': Normal buttons, no separators
        If (FormatMask = vbNullString) Then
            FormatMask = String$(ImageList_GetImageCount(m_hIL), BT_STNORMAL)
        End If
        
        '-- Button ext. size (image[state] and edge offsets)
        m_nButtonSize = m_nIconSize + 7
        
        '-- Extract buttons...
        Do While nIdx < Len(FormatMask)
            
            '-- Key count / extract key
            nIdx = nIdx + 1
            sKey = UCase$(Mid$(FormatMask, nIdx, 1))
            
            Select Case sKey
                
                '-- Normal button, check button and option buttons
                Case BT_STNORMAL, BT_STCHECK, BT_STOPTION
                
                    nBtn = nBtn + 1
                    lPos = lPos + m_nButtonSize
                    
                    '-- Redim. button rectangles
                    ReDim Preserve m_uButtonRect(1 To nBtn)
                    ReDim Preserve m_uButton(1 To nBtn)
                    '-- Store button type
                    Select Case sKey
                        Case BT_STNORMAL
                            m_uButton(nBtn).Type = [eNormal]
                        Case BT_STCHECK
                            m_uButton(nBtn).Type = [eCheck]
                        Case BT_STOPTION
                            m_uButton(nBtn).Type = [eOption]
                    End Select
                    '-- Enabled ?
                    m_uButton(nBtn).Enabled = UserControl.Enabled
                    
                    '-- Button rect.
                    Call SetRect(m_uButtonRect(nBtn), lPos - m_nButtonSize, 0, lPos, m_nButtonSize - 1)
                    Call InflateRect(m_uButtonRect(nBtn), -2, -2)
               
                '-- Separator
                Case BT_SEPARATOR
                
                    lPos = lPos + 7
                    With m_uButtonRect(nBtn)
                        Call SetRect(m_uButton(nBtn).Separator, .x2 + 5, .y1, .x2 + 6, .y2)
                    End With
            End Select
        Loop
        
        '-- Resize control
        With m_uButtonRect(nBtn)
            UserControl.Width = (.x2 + 2) * Screen.TwipsPerPixelX
            UserControl.Height = (.y2 + 2) * Screen.TwipsPerPixelY
        End With
        Call SetRect(m_uBarRect, 0, 0, ScaleWidth, ScaleHeight)
        
        '-- Buttons count / success
        m_nCount = nBtn
        BuildToolbar = (m_nCount > 0)
    End If
End Function

Public Sub SetTooltips( _
           ByVal TooltipsList As String _
           )
    m_sTooltip() = Split(TooltipsList, BT_SEPARATOR)
End Sub

Public Sub SetTooltip( _
           ByVal Index As Integer, _
           ByVal Tooltip As String _
           )
    m_sTooltip(Index) = Tooltip
End Sub

Public Function GetTooltip( _
                ByVal Index As Integer _
                ) As String
    GetTooltip = m_sTooltip(Index)
End Function

Public Sub EnableButton( _
           ByVal Index As Integer, _
           ByVal Enable As Boolean _
           )
    Call pvEnableButton(Index, Enable)
End Sub

Public Function IsButtonEnabled( _
                ByVal Index As Integer _
                ) As Boolean
    IsButtonEnabled = m_uButton(Index).Enabled
End Function

Public Sub CheckButton( _
           ByVal Index As Integer, _
           ByVal Check As Boolean _
           )

    If (m_nCount) Then
        If (Index And Index <= m_nCount) Then
            If (m_uButton(Index).Type <> [eNormal] And m_uButton(Index).Checked <> Check) Then
                
                '-- Update button
                With m_uButton(Index)
                    .Checked = Check
                    .State = [eDown] And Check
                End With
                Call pvRefresh(Index)
                Call pvUpdateOptionButtons(Index)
                
                '-- Event...
                With m_uButtonRect(Index)
                    RaiseEvent ButtonCheck(Index, .x1, .y1)
                End With
            End If
        End If
    End If
End Sub

Public Function IsButtonChecked( _
                ByVal Index As Integer _
                ) As Boolean
    IsButtonChecked = m_uButton(Index).Checked
End Function

Public Function IsButtonPressed( _
                ByVal Index As Integer _
                ) As Boolean
    IsButtonPressed = m_uButton(Index).State = [eDown]
End Function

'==================================================================================================
' Private
'==================================================================================================

Private Function pvExtractImages( _
                 Image As StdPicture, _
                 ByVal MaskColor As OLE_COLOR, _
                 ByVal IconSize As Integer _
                 ) As Boolean
    
    '-- Extract images
    If (Not Image Is Nothing) Then
        If (pvCreateIL(IconSize)) Then
            pvExtractImages = (ImageList_AddMasked(m_hIL, Image.Handle, pvTranslateColor(MaskColor)) <> -1)
        End If
    End If
End Function

Private Function pvCreateIL( _
                 ByVal IconSize As Integer _
                 ) As Boolean
     
    '-- Destroy previous ?
    Call pvDestroyIL
    '-- Create the image list object:
    m_hIL = ImageList_Create(IconSize, IconSize, ILC_MASK Or ILC_COLORDDB, 0, 0)
    If (m_hIL <> 0) And (m_hIL <> -1) Then
        m_nIconSize = IconSize
        pvCreateIL = -1
      Else
        m_hIL = 0
    End If
End Function

Private Sub pvDestroyIL()

    '-- Kill the image list if we have one:
    If (m_hIL <> 0) Then
        Call ImageList_Destroy(m_hIL)
        m_hIL = 0
    End If
End Sub

Private Sub pvSetTipArea( _
            ByVal Index As Integer _
            )
    
    '-- Move label
    Call lblTipRect.Move(m_uButtonRect(Index).x1, 0, m_nButtonSize, m_nButtonSize)
    '-- Set tool tip text
    On Error Resume Next
        lblTipRect.ToolTipText = m_sTooltip(Index - 1)
    On Error GoTo 0
End Sub

Private Sub pvEnableBar( _
            ByVal Enable As Boolean _
            )

  Dim nBtn As Integer
    
    If (m_nCount) Then
        '-- Enable/disable
        For nBtn = 1 To m_nCount
            m_uButton(nBtn).Enabled = Enable
        Next nBtn
        '-- Refresh
        Call pvRefresh
    End If
End Sub

Private Sub pvEnableButton( _
            ByVal Index As Integer, _
            ByVal Enable As Boolean _
            )
    
    If (m_nCount) Then
        If (Index And Index <= m_nCount And m_uButton(Index).Enabled <> Enable) Then
            '-- Enable/disable
            With m_uButton(Index)
                .Enabled = Enable
                .Over = False
                If (Not Enable) Then .State = [eFlat]
            End With
            '-- Reset tooltip rect.
            Call lblTipRect.Move(-lblTipRect.Width)
            m_nLastOver = 0
            '-- Refresh
            Call pvRefresh(Index)
        End If
    End If
End Sub

Private Sub pvRefresh( _
            Optional ByVal Index As Integer = 0 _
            )

  Dim nBtn As Integer
    
    If (m_nCount) Then
        If (Index = 0) Then
            '== All buttons...
            '-- Draw buttons
            For nBtn = 1 To m_nCount
                Call pvPaintButton(nBtn)
                Call pvPaintBitmap(nBtn)
                If (IsRectEmpty(m_uButton(nBtn).Separator) = 0) Then
                    Call FillRect(hDC, m_uButton(nBtn).Separator, m_hShadowBrush)
                End If
            Next nBtn
          Else
            '== Single button
            Call pvPaintButton(Index)
            Call pvPaintBitmap(Index)
        End If
        
        '-- Refresh
        Call UserControl.Refresh
    End If
End Sub

Private Sub pvPaintButton( _
            ByVal Index As Integer _
            )
    
    If (m_uButton(Index).Over) Then
        Call pvFillRoundRect(m_uButtonRect(Index), m_hHighlightBrush)
      Else
        If (m_uButton(Index).Checked) Then
            Call pvFillRoundRect(m_uButtonRect(Index), m_hShadowBrush)
          Else
            Call pvFillRoundRect(m_uButtonRect(Index), m_hFaceBrush)
        End If
    End If
End Sub

Private Sub pvPaintBitmap( _
            ByVal Index As Integer _
            )
  
  Dim lOffset As Long
  
    '-- Image offset
    lOffset = 1 + (1 And m_uButton(Index).State = [eDown])
    '-- Paint masked bitmap
    With m_uButtonRect(Index)
        Call pvDrawImage(Index, hDC, .x1 + lOffset, .y1 + lOffset)
    End With
End Sub

Private Sub pvDrawImage( _
            ByVal Index As Integer, _
            ByVal hDC As Long, _
            ByVal x As Integer, ByVal y As Integer _
            )

  Dim hIcon As Long

    If (m_uButton(Index).Enabled) Then
        '-- Normal
        Call ImageList_Draw(m_hIL, Index - 1, hDC, x, y, ILD_TRANSPARENT)
      Else
        '-- Disabled
        hIcon = ImageList_GetIcon(m_hIL, Index - 1, 0)
        Call DrawState(hDC, m_hHighlightBrush, 0, hIcon, 0, x + 1, y + 1, m_nIconSize, m_nIconSize, DST_ICON Or DSS_MONO)
        Call DrawState(hDC, m_hShadowBrush, 0, hIcon, 0, x, y, m_nIconSize, m_nIconSize, DST_ICON Or DSS_MONO)
        Call DestroyIcon(hIcon)
    End If
End Sub

Private Sub pvFillRoundRect( _
            lpRect As RECT, _
            ByVal hBrush As Long _
            )
                    
    Call InflateRect(lpRect, 1, 1)
    Call FillRect(hDC, lpRect, hBrush)
    With lpRect
        Call SetPixelV(hDC, .x1, .y1, m_lBackColor)
        Call SetPixelV(hDC, .x2 - 1, .y1, m_lBackColor)
        Call SetPixelV(hDC, .x1, .y2 - 1, m_lBackColor)
        Call SetPixelV(hDC, .x2 - 1, .y2 - 1, m_lBackColor)
    End With
    Call InflateRect(lpRect, -1, -1)
End Sub

Private Function pvTranslateColor( _
                 ByVal Clr As OLE_COLOR, _
                 Optional hPal As Long = 0 _
                 ) As Long
    
    '-- OLE/RGB color to RGB color
    If (OleTranslateColor(Clr, hPal, pvTranslateColor)) Then
        pvTranslateColor = CLR_INVALID
    End If
End Function

Private Function pvShiftColor( _
                 ByVal Clr As Long, _
                 ByVal Amount As Long _
                 ) As Long

  Dim lR As Long
  Dim lB As Long
  Dim lG As Long
    
    '-- Add amount
    lR = (Clr And &HFF) + Amount
    lG = ((Clr \ &H100) Mod &H100) + Amount
    lB = ((Clr \ &H10000) Mod &H100) + Amount
    '-- Check byte bounds
    If (lR < 0) Then lR = 0 Else If (lR > 255) Then lR = 255
    If (lG < 0) Then lG = 0 Else If (lG > 255) Then lG = 255
    If (lB < 0) Then lB = 0 Else If (lB > 255) Then lB = 255
    
    '-- Return shifted color
    pvShiftColor = lR + 256& * lG + 65536 * lB
End Function

Private Sub pvGetColors( _
            ByVal FaceColor As OLE_COLOR _
            )
    
  Dim lFaceColor As Long
  Dim bIsSystem  As Boolean
  
    bIsSystem = (FaceColor = vbButtonFace)
  
    '-- Get long value
    lFaceColor = pvTranslateColor(FaceColor)
    m_lBackColor = lFaceColor
    
    '-- Build brush and pens
    If (m_hFaceBrush) Then
        Call DeleteObject(m_hFaceBrush)
        m_hFaceBrush = 0
    End If
    If (m_hHighlightBrush) Then
        Call DeleteObject(m_hHighlightBrush)
        m_hHighlightBrush = 0
    End If
    If (m_hShadowBrush) Then
        Call DeleteObject(m_hShadowBrush)
        m_hShadowBrush = 0
    End If
    
    m_hFaceBrush = CreateSolidBrush(lFaceColor)
    m_hHighlightBrush = CreateSolidBrush(IIf(bIsSystem, pvTranslateColor(vb3DHighlight), pvShiftColor(lFaceColor, &H40)))
    m_hShadowBrush = CreateSolidBrush(IIf(bIsSystem, pvTranslateColor(vb3DShadow), pvShiftColor(lFaceColor, -&H40)))
    
    '-- For check effect
    UserControl.ForeColor = IIf(bIsSystem, pvTranslateColor(vb3DHighlight), pvShiftColor(lFaceColor, &H40))
End Sub

Private Sub pvUpdateButtonState( _
            ByVal Index As Integer, _
            ByVal InButton As Boolean, _
            ByVal MouseButton As MouseButtonConstants, _
            ByVal MouseEvent As eMouseEventConstants _
            )
  
  Dim uTmpButton As tButton
    
    '-- Store current button state / Over button ?
    uTmpButton = m_uButton(Index)
    m_uButton(Index).Over = InButton
    
    '-- Check new state
    With m_uButton(Index)
        
        Select Case MouseEvent
            
            Case [eMouseDown] '-- Mouse pressed
                If (MouseButton = vbLeftButton) Then
                    .State = [eDown]
                End If
                RaiseEvent MouseDown(m_nLastOver, MouseButton, m_uButtonRect(m_nLastOver).x1, m_uButtonRect(m_nLastOver).y1)
                
            Case [eMouseMove] '-- Mouse moving
                If (InButton) Then
                    If (MouseButton = vbLeftButton) Then
                        .State = [eDown]
                      Else
                        If (Not .Checked) Then
                            .State = [eOver]
                        End If
                        tmrTip.Enabled = True
                    End If
                  Else
                    If (Not .Checked) Then
                        .State = [eFlat]
                    End If
                End If
                
            Case [eMouseUp]  '-- Mouse released
                If (InButton) Then
                    If (MouseButton = vbLeftButton) Then
                        Select Case .Type
                            Case [eNormal]
                                .State = [eOver]
                            Case [eCheck]
                                .Checked = Not .Checked
                                .State = -.Checked * [eDown]
                            Case [eOption]
                                .Checked = True
                                .State = [eDown]
                                 Call pvUpdateOptionButtons(Index)
                        End Select
                      Else
                        If (Not .Checked And MouseButton = vbEmpty) Then
                            .State = [eFlat]
                        End If
                    End If
                End If
                RaiseEvent MouseUp(m_nLastOver, MouseButton, m_uButtonRect(m_nLastOver).x1, m_uButtonRect(m_nLastOver).y1)
        End Select
        
        '-- Refresh ?
        If (.State <> uTmpButton.State Or .Checked <> uTmpButton.Checked Or .Over <> uTmpButton.Over) Then
            Call pvRefresh(Index)
        End If
        
        '-- Raise [Click]/[Check] events ?
        If (InButton And MouseEvent = [eMouseUp]) Then
            Select Case m_uButton(Index).Type
                Case [eNormal]
                    RaiseEvent ButtonClick(Index, MouseButton, m_uButtonRect(Index).x1, m_uButtonRect(Index).y1)
                Case [eCheck], [eOption]
                    RaiseEvent ButtonClick(Index, MouseButton, m_uButtonRect(Index).x1, m_uButtonRect(Index).y1)
                    If (.Checked <> uTmpButton.Checked) Then
                        RaiseEvent ButtonCheck(Index, m_uButtonRect(Index).x1, m_uButtonRect(Index).y1)
                    End If
            End Select
        End If
    End With
End Sub

Private Sub pvUpdateOptionButtons( _
            ByVal CurrentIndex As Integer _
            )

  Dim nIdx As Integer
    
    '-- Right buttons
    nIdx = CurrentIndex
    Do While nIdx < m_nCount
        If (IsRectEmpty(m_uButton(nIdx).Separator) = 0) Then
            Exit Do
          Else
            nIdx = nIdx + 1
            With m_uButton(nIdx)
                If (.Type = [eOption] And .Checked) Then
                    .Checked = False
                    .State = [eFlat]
                    Call pvRefresh(nIdx)
                End If
            End With
        End If
    Loop
    
    '-- Left buttons
    nIdx = CurrentIndex
    Do While nIdx > 1
        nIdx = nIdx - 1
        If (IsRectEmpty(m_uButton(nIdx).Separator) = 0) Then
            Exit Do
          Else
            With m_uButton(nIdx)
                If (.Type = [eOption] And .Checked) Then
                    .Checked = False
                    .State = [eFlat]
                    Call pvRefresh(nIdx)
                End If
            End With
        End If
    Loop
End Sub

Private Sub tmrTip_Timer()
  
  Dim uPt As POINTAPI
    
    '-- Cursor out of toolbar ?
    Call GetCursorPos(uPt)
    If (WindowFromPoint(uPt.x, uPt.y) <> hWnd) Then
        '-- Disable timer and refresh
        tmrTip.Enabled = False
        If (m_nLastOver) Then
            Call pvUpdateButtonState(m_nLastOver, 0, 0, [eMouseMove])
        End If
    End If
End Sub

'==================================================================================================
' Properties
'==================================================================================================

Public Property Let BackColor(ByVal New_BackColor As OLE_COLOR)
    UserControl.BackColor() = New_BackColor
    Call pvGetColors(New_BackColor)
    Call pvRefresh
End Property
Public Property Get BackColor() As OLE_COLOR
    BackColor = UserControl.BackColor
End Property

Public Property Get Enabled() As Boolean
    Enabled = UserControl.Enabled
End Property
Public Property Let Enabled(ByVal New_Enabled As Boolean)
    UserControl.Enabled() = New_Enabled
    Call pvEnableBar(New_Enabled)
End Property

Public Property Get ButtonsCount() As Integer
    ButtonsCount = m_nCount
End Property

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
    With PropBag
        UserControl.BackColor = .ReadProperty("BackColor", vbButtonFace)
        UserControl.Enabled = .ReadProperty("Enabled", True)
    End With
    Call pvGetColors(UserControl.BackColor)
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
    With PropBag
        Call .WriteProperty("BackColor", UserControl.BackColor, vbButtonFace)
        Call .WriteProperty("Enabled", UserControl.Enabled, True)
    End With
End Sub
