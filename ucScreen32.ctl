VERSION 5.00
Begin VB.UserControl ucScreen32 
   ClientHeight    =   1500
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   1500
   ClipBehavior    =   0  'None
   ClipControls    =   0   'False
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   KeyPreview      =   -1  'True
   LockControls    =   -1  'True
   MousePointer    =   99  'Custom
   ScaleHeight     =   100
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   100
End
Attribute VB_Name = "ucScreen32"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'================================================
' User control:  ucScreen32.ctl
' Author:        Carles P.V.
' Dependencies:  cDIB32.cls
' Last revision: 2004.09.15
'================================================

Option Explicit

'-- API:

Private Type POINTAPI
    x As Long
    y As Long
End Type

Private Const RGN_DIFF As Long = 4

Private Declare Function CreateRectRgn Lib "gdi32" (ByVal x1 As Long, ByVal y1 As Long, ByVal x2 As Long, ByVal y2 As Long) As Long
Private Declare Function CombineRgn Lib "gdi32" (ByVal hDestRgn As Long, ByVal hSrcRgn1 As Long, ByVal hSrcRgn2 As Long, ByVal nCombineMode As Long) As Long
Private Declare Function FillRgn Lib "gdi32" (ByVal hDC As Long, ByVal hRgn As Long, ByVal hBrush As Long) As Long
Private Declare Function CreateSolidBrush Lib "gdi32" (ByVal crColor As Long) As Long
Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Private Declare Function TranslateColor Lib "olepro32" Alias "OleTranslateColor" (ByVal Clr As OLE_COLOR, ByVal Palette As Long, Col As Long) As Long

'-- Public Enums.:

Public Enum eBorderStyleConstants
    [eNone] = 0
    [eFixedSingle]
End Enum

Public Enum eWorkModeCostants
    [eScrollMode] = 0
    [eUserMode]
End Enum

'-- Property Variables:

Private m_oleBackColor     As OLE_COLOR
Private m_bEraseBackground As Boolean           'run-time only
Private m_bFitMode         As Boolean           'run-time only
Private m_bWorkMode        As eWorkModeCostants 'run-time only
Private m_lZoom            As Long              'run-time only

'-- Private Variables:

Private m_lWidth           As Long
Private m_lHeight          As Long
Private m_lLeft            As Long
Private m_lTop             As Long
Private m_lHPos            As Long
Private m_lHMax            As Long
Private m_lVPos            As Long
Private m_lVMax            As Long
Private m_lLastHPos        As Long
Private m_lLastVPos        As Long
Private m_lLastHMax        As Long
Private m_lLastVMax        As Long
Private m_bMouseDown       As Boolean
Private m_uPt              As POINTAPI

'-- Event Declarations:

Public Event Click()
Public Event DblClick()
Public Event KeyDown(KeyCode As Integer, Shift As Integer)
Public Event KeyPress(KeyAscii As Integer)
Public Event KeyUp(KeyCode As Integer, Shift As Integer)
Public Event MouseDown(Button As Integer, Shift As Integer, x As Long, y As Long)
Public Event MouseMove(Button As Integer, Shift As Integer, x As Long, y As Long)
Public Event MouseUp(Button As Integer, Shift As Integer, x As Long, y As Long)
Public Event Scroll()
Public Event Resize()

'-- Public objects:

Public DIB As cDIB32 ' 32-bit DIB section
Attribute DIB.VB_VarMemberFlags = "400"



'========================================================================================
' UserControl
'========================================================================================

Private Sub UserControl_Initialize()

    '-- Initialize DIB
    Set Me.DIB = New cDIB32
    
    '-- Initial values
    m_bEraseBackground = True
    m_bWorkMode = [eScrollMode]
    m_lZoom = 1
End Sub

Private Sub UserControl_Terminate()

    '-- Destroy DIB
    Set Me.DIB = Nothing
End Sub

Private Sub UserControl_Resize()

    '-- Resize and refresh
    Call pvResizeCanvas
    Call pvRefreshCanvas
    
    RaiseEvent Resize
End Sub

Private Sub UserControl_Paint()

    '-- Refresh Canvas
    Call pvRefreshCanvas
End Sub

'========================================================================================
' Events + Scrolling
'========================================================================================

Private Sub UserControl_Click()
    RaiseEvent Click
End Sub

Private Sub UserControl_DblClick()
    RaiseEvent DblClick
End Sub

Private Sub UserControl_KeyDown(KeyCode As Integer, Shift As Integer)
    RaiseEvent KeyDown(KeyCode, Shift)
End Sub

Private Sub UserControl_KeyPress(KeyAscii As Integer)
    RaiseEvent KeyPress(KeyAscii)
End Sub

Private Sub UserControl_KeyUp(KeyCode As Integer, Shift As Integer)
    RaiseEvent KeyUp(KeyCode, Shift)
End Sub

Private Sub UserControl_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    
    '-- Mouse down flag / Store values
    m_bMouseDown = (Button = vbLeftButton)
    m_uPt.x = x
    m_uPt.y = y
    
    RaiseEvent MouseDown(Button, Shift, pvDIBx(x), pvDIBy(y))
End Sub

Private Sub UserControl_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
        
    If (m_bMouseDown And m_bWorkMode = [eScrollMode]) Then
    
        '-- Apply offsets
        m_lHPos = m_lHPos + (m_uPt.x - x)
        m_lVPos = m_lVPos + (m_uPt.y - y)
        
        '-- Check margins
        If (m_lHPos < 0) Then m_lHPos = 0 Else If (m_lHPos > m_lHMax) Then m_lHPos = m_lHMax
        If (m_lVPos < 0) Then m_lVPos = 0 Else If (m_lVPos > m_lVMax) Then m_lVPos = m_lVMax
        
        '-- Save current position
        m_uPt.x = x
        m_uPt.y = y
        
        '-- Refresh and raise event
        If (m_lLastHPos <> m_lHPos Or m_lLastVPos <> m_lVPos) Then
            Call pvRefreshCanvas
            RaiseEvent Scroll
        End If
        
        '-- Store
        m_lLastHPos = m_lHPos
        m_lLastVPos = m_lVPos
    End If
    
    RaiseEvent MouseMove(Button, Shift, pvDIBx(x), pvDIBy(y))
End Sub

Private Sub UserControl_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)

    '-- Mouse down flag
    m_bMouseDown = False
    
    RaiseEvent MouseUp(Button, Shift, pvDIBx(x), pvDIBy(y))
End Sub

'========================================================================================
' Methods
'========================================================================================

Public Sub Refresh()
    Call pvRefreshCanvas
End Sub

Public Sub Resize()
    Call pvResizeCanvas
End Sub

Public Function Scroll( _
                ByVal x As Long, _
                ByVal y As Long _
                ) As Boolean

    '-- Apply offsets
    m_lHPos = m_lHPos - x
    m_lVPos = m_lVPos - y
    
    '-- Check margins
    If (m_lHPos < 0) Then m_lHPos = 0 Else If (m_lHPos > m_lHMax) Then m_lHPos = m_lHMax
    If (m_lVPos < 0) Then m_lVPos = 0 Else If (m_lVPos > m_lVMax) Then m_lVPos = m_lVMax
    
    '-- Need to refresh?
    If (m_lLastHPos <> m_lHPos Or m_lLastVPos <> m_lVPos) Then
        Call pvRefreshCanvas
        Scroll = True
        RaiseEvent Scroll
    End If
    
    '-- Store
    m_lLastHPos = m_lHPos
    m_lLastVPos = m_lVPos
End Function

'========================================================================================
' Properties
'========================================================================================

Public Property Let BackColor(ByVal New_BackColor As OLE_COLOR)
    m_oleBackColor = New_BackColor
    Call Me.Refresh
End Property
Public Property Get BackColor() As OLE_COLOR
    BackColor = m_oleBackColor
End Property

Public Property Get BorderStyle() As eBorderStyleConstants
    BorderStyle = UserControl.BorderStyle
End Property
Public Property Let BorderStyle(ByVal New_BorderStyle As eBorderStyleConstants)
    UserControl.BorderStyle() = New_BorderStyle
End Property

Public Property Let Enabled(ByVal New_Enabled As Boolean)
    UserControl.Enabled = New_Enabled
End Property
Public Property Get Enabled() As Boolean
    Enabled = UserControl.Enabled
End Property

Public Property Let EraseBackground(ByVal New_EraseBackground As Boolean)
    m_bEraseBackground = New_EraseBackground
End Property
Public Property Get EraseBackground() As Boolean
Attribute EraseBackground.VB_MemberFlags = "400"
    EraseBackground = m_bEraseBackground
End Property

Public Property Let FitMode(ByVal New_FitMode As Boolean)
    m_bFitMode = New_FitMode
End Property
Public Property Get FitMode() As Boolean
Attribute FitMode.VB_MemberFlags = "400"
    FitMode = m_bFitMode
End Property

Public Property Get UserIcon() As StdPicture
Attribute UserIcon.VB_MemberFlags = "400"
    Set UserIcon = UserControl.MouseIcon
End Property
Public Property Set UserIcon(ByVal New_MouseIcon As StdPicture)
    Set UserControl.MouseIcon = New_MouseIcon
    Call pvUpdatePointer
End Property

Public Property Let WorkMode(ByVal New_WorkMode As eWorkModeCostants)
    m_bWorkMode = New_WorkMode
    Call pvUpdatePointer
End Property
Public Property Get WorkMode() As eWorkModeCostants
Attribute WorkMode.VB_MemberFlags = "400"
    WorkMode = m_bWorkMode
End Property

Public Property Let Zoom(ByVal New_Zoom As Long)
    m_lZoom = IIf(New_Zoom < 1, 1, New_Zoom)
End Property
Public Property Get Zoom() As Long
Attribute Zoom.VB_MemberFlags = "400"
    Zoom = m_lZoom
End Property

'//

Public Property Get ScaleWidth() As Long
Attribute ScaleWidth.VB_MemberFlags = "400"
    ScaleWidth = UserControl.ScaleWidth
End Property
Public Property Get ScaleHeight() As Long
Attribute ScaleHeight.VB_MemberFlags = "400"
    ScaleHeight = UserControl.ScaleHeight
End Property

Public Property Get ScrollHMax() As Long
Attribute ScrollHMax.VB_MemberFlags = "400"
    ScrollHMax = m_lHMax
End Property
Public Property Get ScrollVMax() As Long
Attribute ScrollVMax.VB_MemberFlags = "400"
    ScrollVMax = m_lVMax
End Property
Public Property Get ScrollHPos() As Long
Attribute ScrollHPos.VB_MemberFlags = "400"
    ScrollHPos = m_lHPos
End Property
Public Property Get ScrollVPos() As Long
Attribute ScrollVPos.VB_MemberFlags = "400"
    ScrollVPos = m_lVPos
End Property

'//

Public Property Get hWnd() As Long
Attribute hWnd.VB_MemberFlags = "400"
    hWnd = UserControl.hWnd
End Property

'//

Private Sub UserControl_InitProperties()
    UserControl.BorderStyle = [eNone]
    m_oleBackColor = vbApplicationWorkspace
End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
    UserControl.BorderStyle = PropBag.ReadProperty("BorderStyle", [eNone])
    m_oleBackColor = PropBag.ReadProperty("BackColor", vbApplicationWorkspace)
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
    Call PropBag.WriteProperty("BorderStyle", UserControl.BorderStyle, [eNone])
    Call PropBag.WriteProperty("BackColor", m_oleBackColor, vbApplicationWorkspace)
End Sub

'========================================================================================
' Private
'========================================================================================

Private Sub pvEraseBackground()

  Dim hRgn1  As Long
  Dim hRgn2  As Long
  Dim Clr    As Long
  Dim hBrush As Long
    
    '-- Create brush (background)
    Call TranslateColor(m_oleBackColor, 0, Clr)
    hBrush = CreateSolidBrush(Clr)

    '-- Create Cls region (Control Rect. - Canvas Rect.)
    hRgn1 = CreateRectRgn(0, 0, ScaleWidth, ScaleHeight)
    hRgn2 = CreateRectRgn(m_lLeft, m_lTop, m_lLeft + m_lWidth, m_lTop + m_lHeight)
    Call CombineRgn(hRgn1, hRgn1, hRgn2, RGN_DIFF)
    
    '-- Fill it
    Call FillRgn(hDC, hRgn1, hBrush)
    
    '-- Clear
    Call DeleteObject(hBrush)
    Call DeleteObject(hRgn1)
    Call DeleteObject(hRgn2)
End Sub

Private Sub pvRefreshCanvas()
  
  Dim xOff As Long, yOff As Long
  Dim wDst As Long, hDst As Long
  Dim xSrc As Long, ySrc As Long
  Dim wSrc As Long, hSrc As Long
    
    If (Me.DIB.hDIB <> 0) Then
        
        '-- Get Left and Width of source image rectangle:
        If (m_lHMax And Not m_bFitMode) Then
            xOff = -m_lHPos Mod m_lZoom
            wDst = (m_lWidth \ m_lZoom) * m_lZoom + 2 * m_lZoom
            xSrc = m_lHPos \ m_lZoom
            wSrc = m_lWidth \ m_lZoom + 2
          Else
            xOff = m_lLeft
            wDst = m_lWidth
            xSrc = 0
            wSrc = Me.DIB.Width
        End If
        
        '-- Get Top and Height of source image rectangle:
        If (m_lVMax And Not m_bFitMode) Then
            yOff = -m_lVPos Mod m_lZoom
            hDst = (m_lHeight \ m_lZoom) * m_lZoom + 2 * m_lZoom
            ySrc = m_lVPos \ m_lZoom
            hSrc = m_lHeight \ m_lZoom + 2
          Else
            yOff = m_lTop
            hDst = m_lHeight
            ySrc = 0
            hSrc = Me.DIB.Height
        End If
        
        '-- Erase background
        If (m_bEraseBackground) Then
            Call pvEraseBackground
        End If
        
        '-- Paint visible source rectangle:
        Call Me.DIB.Stretch(hDC, xOff, yOff, wDst, hDst, xSrc, ySrc, wSrc, hSrc)
        
      Else
        '-- Erase background
        Call pvEraseBackground
    End If
End Sub

Private Sub pvResizeCanvas()
    
    With Me.DIB
        
        If (.hDIB <> 0) Then
        
            If (m_bFitMode = False) Then
            
                '-- Get new Width
                If (.Width * m_lZoom > ScaleWidth) Then
                    m_lHMax = .Width * m_lZoom - ScaleWidth
                    m_lWidth = ScaleWidth
                  Else
                    m_lHMax = 0
                    m_lWidth = .Width * m_lZoom
                End If
                
                '-- Get new Height
                If (.Height * m_lZoom > ScaleHeight) Then
                    m_lVMax = .Height * m_lZoom - ScaleHeight
                    m_lHeight = ScaleHeight
                  Else
                    m_lVMax = 0
                    m_lHeight = .Height * m_lZoom
                End If
                
                '-- Offsets
                m_lLeft = (ScaleWidth - m_lWidth) \ 2
                m_lTop = (ScaleHeight - m_lHeight) \ 2
              
              Else
                '-- Get best-fit info
                Call pvGetBestFitInfo(.Width, .Height, ScaleWidth, ScaleHeight, m_lLeft, m_lTop, m_lWidth, m_lHeight)
            End If
                                
            '-- Memorize position
            If (m_lLastHMax) Then
                m_lHPos = (m_lLastHPos * m_lHMax) \ m_lLastHMax
              Else
                m_lHPos = m_lHMax \ 2
            End If
            If (m_lLastVMax) Then
                m_lVPos = (m_lLastVPos * m_lVMax) \ m_lLastVMax
              Else
                m_lVPos = m_lVMax \ 2
            End If
            m_lLastHPos = m_lHPos
            m_lLastVPos = m_lVPos
            m_lLastHMax = m_lHMax
            m_lLastVMax = m_lVMax
          
          Else
            '-- 'Hide' canvas
            m_lWidth = 0
            m_lHeight = 0
        End If
    End With
    
    '-- Update mouse pointer
    Call pvUpdatePointer
End Sub

Private Sub pvUpdatePointer()

    If (m_bWorkMode = [eScrollMode]) Then
        If ((m_lHMax Or m_lVMax) And Not m_bFitMode) Then
            UserControl.MousePointer = vbSizeAll
          Else
            UserControl.MousePointer = vbDefault
        End If
      Else
        If (Not UserControl.MouseIcon Is Nothing) Then
            UserControl.MousePointer = vbCustom
        End If
    End If
End Sub

Private Function pvDIBx(ByVal x As Long) As Long

    If (Me.DIB.hDIB <> 0) Then
        If (m_bFitMode) Then
            pvDIBx = Int((x - m_lLeft) / (m_lWidth / Me.DIB.Width))
          Else
            pvDIBx = Int((m_lHPos + x - m_lLeft) / m_lZoom)
        End If
    End If
End Function

Private Function pvDIBy(ByVal y As Long) As Long

    If (Me.DIB.hDIB <> 0) Then
        If (m_bFitMode) Then
            pvDIBy = Int((y - m_lTop) / (m_lHeight / Me.DIB.Height))
          Else
            pvDIBy = Int((m_lVPos + y - m_lTop) / m_lZoom)
        End If
    End If
End Function

Private Sub pvGetBestFitInfo( _
            ByVal SrcWidth As Long, ByVal SrcHeight As Long, _
            ByVal DstWidth As Long, ByVal DstHeight As Long, _
            xBF As Long, yBF As Long, _
            BFWidth As Long, BFHeight As Long, _
            Optional ByVal StretchFit As Boolean = False _
            )
                          
  Dim cW As Single
  Dim cH As Single
    
    If ((SrcWidth > DstWidth Or SrcHeight > DstHeight) Or StretchFit) Then
        cW = DstWidth / SrcWidth
        cH = DstHeight / SrcHeight
        If (cW < cH) Then
            BFWidth = DstWidth
            BFHeight = SrcHeight * cW
          Else
            BFHeight = DstHeight
            BFWidth = SrcWidth * cH
        End If
      Else
        BFWidth = SrcWidth
        BFHeight = SrcHeight
    End If
    If (BFWidth < 1) Then BFWidth = 1
    If (BFHeight < 1) Then BFHeight = 1
    
    xBF = (DstWidth - BFWidth) \ 2
    yBF = (DstHeight - BFHeight) \ 2
End Sub


