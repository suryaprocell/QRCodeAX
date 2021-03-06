VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "NumericEncoder"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'------------------------------------------------------------------------------
' 数字モードエンコーダー
'------------------------------------------------------------------------------
Option Explicit

Implements IQRCodeEncoder

Private m_data()        As Long
Private m_charCounter   As Long
Private m_bitCounter    As Long

'------------------------------------------------------------------------------
' (概要)
'  ビット数を取得します。
'------------------------------------------------------------------------------
Private Property Get IQRCodeEncoder_BitCount() As Long

    IQRCodeEncoder_BitCount = m_bitCounter
    
End Property

'------------------------------------------------------------------------------
' (概要)
'  文字数を取得します。
'------------------------------------------------------------------------------
Private Property Get IQRCodeEncoder_CharCount() As Long

    IQRCodeEncoder_CharCount = m_charCounter
    
End Property

'------------------------------------------------------------------------------
' (概要)
'  符号化モードを表す EncodingMode 列挙体の値を取得します。
'------------------------------------------------------------------------------
Private Property Get IQRCodeEncoder_EncodingMode() As EncodingMode

    IQRCodeEncoder_EncodingMode = EncodingMode.NUMERIC
    
End Property

'------------------------------------------------------------------------------
' (概要)
'  モード指示子を取得します。
'------------------------------------------------------------------------------
Private Property Get IQRCodeEncoder_ModeIndicator() As Long

    IQRCodeEncoder_ModeIndicator = ModeIndicator.NUMERIC_VALUE
    
End Property

'------------------------------------------------------------------------------
' (概要)
'  現在のモードシーケンスに文字を追加し、追加に要したビット数を返します。
'------------------------------------------------------------------------------
Private Function IQRCodeEncoder_Append(ByVal c As String) As Long

#If [DEBUG] Then
    Debug.Assert Len(c) = 1
    Debug.Assert IQRCodeEncoder_IsInSubset(c)
#End If

    Dim ret As Long
    
    If m_charCounter Mod 3 = 0 Then
        If m_charCounter = 0 Then
            ReDim m_data(0)
        Else
            ReDim Preserve m_data(UBound(m_data) + 1)
        End If
        
        m_data(UBound(m_data)) = CLng(c)
        ret = 4
        
    Else
        m_data(UBound(m_data)) = m_data(UBound(m_data)) * 10 + CLng(c)
        ret = 3
        
    End If

    m_charCounter = m_charCounter + 1
    m_bitCounter = m_bitCounter + ret

    IQRCodeEncoder_Append = ret

End Function

'------------------------------------------------------------------------------
' (概要)
'  指定の文字をエンコードしたコード語のビット数を返します。
'------------------------------------------------------------------------------
Private Function IQRCodeEncoder_GetCodewordBitLength(ByVal c As String) As Long

#If [DEBUG] Then
    Debug.Assert Len(c) = 1
    Debug.Assert IQRCodeEncoder_IsInSubset(c)
#End If

    If m_charCounter Mod 3 = 0 Then
        IQRCodeEncoder_GetCodewordBitLength = 4
    Else
        IQRCodeEncoder_GetCodewordBitLength = 3
    End If
    
End Function

'------------------------------------------------------------------------------
' (概要)
'  エンコードされたデータのバイト配列を返します。
'------------------------------------------------------------------------------
Private Function IQRCodeEncoder_GetBytes() As Byte()

    Dim bs As BitSequence
    Set bs = New BitSequence
    
    Dim i As Long
    
    For i = 0 To UBound(m_data) - 1
        Call bs.Append(m_data(i), 10)
    Next
            
    Select Case m_charCounter Mod 3
        Case 1
            Call bs.Append(m_data(UBound(m_data)), 4)
    
        Case 2
            Call bs.Append(m_data(UBound(m_data)), 7)
            
        Case Else
            Call bs.Append(m_data(UBound(m_data)), 10)

    End Select
    
    IQRCodeEncoder_GetBytes = bs.GetBytes()

End Function

'------------------------------------------------------------------------------
' (概要)
'  指定の文字が符号化モードに適合する場合は True を返します。
'------------------------------------------------------------------------------
Private Function IQRCodeEncoder_IsInSubset(ByVal c As String) As Boolean

#If [DEBUG] Then
    Debug.Assert Len(c) = 1
#End If

    IQRCodeEncoder_IsInSubset = c >= "0" And c <= "9"
    
End Function

'------------------------------------------------------------------------------
' (概要)
'  指定の文字が符号化モードの排他的部分集合の場合は True を返します。
'------------------------------------------------------------------------------
Private Function IQRCodeEncoder_IsInExclusiveSubset(ByVal c As String) As Boolean

#If [DEBUG] Then
    Debug.Assert Len(c) = 1
#End If

    IQRCodeEncoder_IsInExclusiveSubset = IQRCodeEncoder_IsInSubset(c)
    
End Function
