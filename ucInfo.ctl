VERSION 5.00
Begin VB.UserControl ucInfo 
   Alignable       =   -1  'True
   AutoRedraw      =   -1  'True
   CanGetFocus     =   0   'False
   ClientHeight    =   240
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4800
   ClipControls    =   0   'False
   FillColor       =   &H80000005&
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   9
      Charset         =   0
      Weight          =   700
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   ForeColor       =   &H00000000&
   ScaleHeight     =   16
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   320
End
Attribute VB_Name = "ucInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'================================================
' UserControl:   ucInfo.ctl
'                Use on this project only (Lems)
'
' Author:        Carles P.V.
' Dependencies:  Project
' Last revision: 2011.11.20
'================================================

Option Explicit

'-- API:

Private Type RECT
    x1 As Long
    y1 As Long
    x2 As Long
    y2 As Long
End Type

Private Declare Function SetRect Lib "user32" (lpRect As RECT, ByVal x1 As Long, ByVal y1 As Long, ByVal x2 As Long, ByVal y2 As Long) As Long
                         
'-- Private constants and variables:

Private Const FIXED_WIDTH    As Long = 90
Private Const PANEL_HEIGHT   As Long = 14
Private Const TEXT_INDENT    As Long = 4
Private Const SEP            As Long = 2
   
Private m_uPanelRect(1 To 5) As RECT
Private m_sPanelText(1 To 5) As String



'========================================================================================
' UserControl
'========================================================================================

Private Sub UserControl_Resize()
    
  Dim i As Long
  
    Height = (PANEL_HEIGHT + 2 * SEP) * Screen.TwipsPerPixelY
    
    On Error Resume Next
    
    '-- Set panel and text rects.
    For i = 5 To 2 Step -1
        Call SetRect( _
             m_uPanelRect(i), _
             ScaleWidth - (5 - i + 1) * FIXED_WIDTH, _
             SEP, _
             ScaleWidth - (5 - i) * FIXED_WIDTH - SEP, _
             PANEL_HEIGHT + SEP _
             )
    Next i
    Call SetRect(m_uPanelRect(1), SEP, SEP, m_uPanelRect(2).x1 - SEP, PANEL_HEIGHT + SEP)
    
    Call Cls
    Call Me.Refresh
    
    On Error GoTo 0
End Sub

Private Sub UserControl_Click()
    
    '-- Cycle through 'Lems Saved' panel modes
    Call CycleLemsSavedModes
End Sub

'========================================================================================
' Methods
'========================================================================================

Public Sub Refresh()

  Dim bIsSystem As Boolean
  Dim bCaption  As Boolean
  Dim c         As Long
  Dim i         As Long
  
    bIsSystem = (BackColor = vbButtonFace)
    bCaption = (m_sPanelText(1) <> vbNullString)
    
    c = TranslateColor(BackColor)
    c = IIf(bCaption, _
        IIf(bIsSystem, vb3DHighlight, ShiftColor(c, &H40)), _
        c _
        )
        
    '-- Draw panels
    For i = 1 To 5
        
        With m_uPanelRect(i)
            Line (.x1, .y1)-(.x2 - 1, .y2 - 1), c, BF
        End With

        CurrentY = 1
        If (bCaption) Then
            CurrentX = m_uPanelRect(i).x1
            If (i = 1) Then
                CurrentX = CurrentX + TEXT_INDENT
              Else
                CurrentX = CurrentX + (FIXED_WIDTH - TextWidth(m_sPanelText(i))) \ 2
            End If
            CurrentY = SEP + (PANEL_HEIGHT - TextHeight(vbNullString)) \ 2 - 1
            
            If (i = 4) Then
                If ((LemsSavedMode = [eSavedModePercentageRemaining] Or _
                     LemsSavedMode = [eSavedModeCountRemaining]) And _
                     m_sPanelText(4) <> "Done!" _
                    ) Then
                    ForeColor = &H80&
                  Else
                    ForeColor = &H0
                End If
              Else
                ForeColor = &H0
            End If
            Print m_sPanelText(i);
        End If
    Next i
    
    '-- Update
    Call UserControl.Refresh
End Sub

'========================================================================================
' Properties
'========================================================================================

Public Property Let BackColor(ByVal New_BackColor As OLE_COLOR)
    UserControl.BackColor = New_BackColor
    Call Me.Refresh
End Property
Public Property Get BackColor() As OLE_COLOR
    BackColor = UserControl.BackColor
End Property

Public Property Let PanelText(ByVal Index As Integer, ByVal New_Text As String)
    If (m_sPanelText(Index) <> New_Text) Then
        m_sPanelText(Index) = New_Text
        Call Me.Refresh
    End If
End Property
Public Property Get PanelText(ByVal Index As Integer) As String
Attribute PanelText.VB_MemberFlags = "400"
    PanelText = m_sPanelText(Index)
End Property

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
    UserControl.BackColor = PropBag.ReadProperty("BackColor", vbButtonFace)
End Sub
Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
    Call PropBag.WriteProperty("BackColor", UserControl.BackColor, vbButtonFace)
End Sub
