Attribute VB_Name = "Codeword"
'------------------------------------------------------------------------------
' コード語
'------------------------------------------------------------------------------
Option Private Module
Option Explicit

Private m_totalNumbers() As Variant

Private m_initialized As Boolean

'------------------------------------------------------------------------------
' (概要)
'  コード語総数を返します。
'------------------------------------------------------------------------------
Public Function GetTotalNumber(ByVal ver As Long) As Long

#If [DEBUG] Then
    Debug.Assert ver >= Constants.MIN_VERSION And _
                 ver <= Constants.MAX_VERSION
#End If

    Call Initialize

    GetTotalNumber = m_totalNumbers(ver)
    
End Function

'------------------------------------------------------------------------------
' (概要)
'  オブジェクトを初期化します。
'------------------------------------------------------------------------------
Private Sub Initialize()

    If m_initialized Then Exit Sub

    m_initialized = True

    m_totalNumbers = Array( _
        -1, _
        26, 44, 70, 100, 134, 172, 196, 242, 292, 346, _
        404, 466, 532, 581, 655, 733, 815, 901, 991, 1085, _
        1156, 1258, 1364, 1474, 1588, 1706, 1828, 1921, 2051, 2185, _
        2323, 2465, 2611, 2761, 2876, 3034, 3196, 3362, 3532, 3706 _
    )
        
End Sub
