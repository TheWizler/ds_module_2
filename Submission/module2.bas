VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Sub Quarterly_Change_All()
    Dim ws As Worksheet
    
    For Each ws In ThisWorkbook.Sheets
        Quarterly_Change ws
    Next ws
End Sub

Sub Quarterly_Change(ws As Worksheet)
    Dim lastRow As Long
    lastRow = ws.Cells(ws.Rows.Count, 1).End(xlUp).row
    
    Dim startRow As Integer
    startRow = 2
    
    Dim ticker As String
    Dim initialOpen As Double
    Dim finalClose As Double
    Dim totalVolume As Double
    Dim row As Long
    Dim outputColStart As Integer
    outputColStart = 9
    
    Dim greatestIncrease As Double
    Dim greatestDecrease As Double
    Dim greatestVolume As Double
    Dim increaseTicker As String
    Dim decreaseTicker As String
    Dim volumeTicker As String
    
    greatestIncrease = 0
    greatestDecrease = 0
    greatestVolume = 0
    
    ws.Cells(1, outputColStart).Value = "Ticker"
    ws.Cells(1, outputColStart + 1).Value = "Quarterly Change"
    ws.Cells(1, outputColStart + 2).Value = "Percent Change"
    ws.Cells(1, outputColStart + 3).Value = "Total Stock Volume"
    
    ticker = ws.Cells(startRow, 1).Value
    initialOpen = ws.Cells(startRow, 3).Value
    totalVolume = 0
    
    Dim percentChange As Double
    Dim outputRow As Long
    outputRow = 2
    
    For row = startRow To lastRow
        If ws.Cells(row, 1).Value <> ticker Then
            finalClose = ws.Cells(row - 1, 6).Value
            percentChange = (finalClose - initialOpen) / initialOpen * 100
            ws.Cells(outputRow, outputColStart).Value = ticker
            ws.Cells(outputRow, outputColStart + 1).Value = finalClose - initialOpen
            ws.Cells(outputRow, outputColStart + 2).Value = percentChange
            ws.Cells(outputRow, outputColStart + 3).Value = totalVolume
            
            ' Check for greatest increase, decrease, and volume
            If percentChange > greatestIncrease Then
                greatestIncrease = percentChange
                increaseTicker = ticker
            ElseIf percentChange < greatestDecrease Then
                greatestDecrease = percentChange
                decreaseTicker = ticker
            End If
            
            If totalVolume > greatestVolume Then
                greatestVolume = totalVolume
                volumeTicker = ticker
            End If
            
            ticker = ws.Cells(row, 1).Value
            initialOpen = ws.Cells(row, 3).Value
            totalVolume = ws.Cells(row, 7).Value
            outputRow = outputRow + 1
        Else
            totalVolume = totalVolume + ws.Cells(row, 7).Value
        End If
    Next row
    
    ' Output greatest values
    Dim outputStatRow As Integer
    outputStatRow = 2
    ws.Cells(1, 14).Value = "Metric"
    ws.Cells(1, 15).Value = "Ticker"
    ws.Cells(1, 16).Value = "Value"
    
    ws.Cells(outputStatRow, 14).Value = "Greatest % Increase"
    ws.Cells(outputStatRow, 15).Value = increaseTicker
    ws.Cells(outputStatRow, 16).Value = Format(greatestIncrease, "0.00") & "%"
    
    ws.Cells(outputStatRow + 1, 14).Value = "Greatest % Decrease"
    ws.Cells(outputStatRow + 1, 15).Value = decreaseTicker
    ws.Cells(outputStatRow + 1, 16).Value = Format(greatestDecrease, "0.00") & "%"
    
    ws.Cells(outputStatRow + 2, 14).Value = "Greatest Total Volume"
    ws.Cells(outputStatRow + 2, 15).Value = volumeTicker
    ws.Cells(outputStatRow + 2, 16).Value = greatestVolume
    
    ' Add conditional formatting
    Call AddConditionalFormatting(ws, outputColStart + 1, outputRow)
    Call AddConditionalFormatting(ws, outputColStart + 2, outputRow)
End Sub




Sub AddConditionalFormatting(ws As Worksheet, col As Integer, lastRow As Long)
    Dim rng As range
    Set rng = ws.range(ws.Cells(2, col), ws.Cells(lastRow, col))
    With rng
        .FormatConditions.Delete
        .FormatConditions.Add Type:=xlCellValue, Operator:=xlGreater, Formula1:="0"
        .FormatConditions(1).Interior.Color = RGB(0, 176, 80)  ' Green for positive
        .FormatConditions.Add Type:=xlCellValue, Operator:=xlLess, Formula1:="0"
        .FormatConditions(2).Interior.Color = RGB(255, 0, 0)   ' Red for negative
    End With
End Sub
