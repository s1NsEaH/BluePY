# -*- coding: cp949 -*-
import xlsxwriter
from datetime import datetime

with open("ResultLine.txt","r",encoding='utf-8', errors='ignore') as f:
    result_data = f.read()
f.closed

with open("CommentLine.txt","r",encoding='utf-8', errors='ignore') as f:
    comment_data = f.read()
f.closed
  
workbook = xlsxwriter.Workbook('Linux_Report.xlsx')
worksheet = workbook.add_worksheet('Linux_Report')
worksheet2 = workbook.add_worksheet('Comment_Report')

workbook.set_properties({
    'title':    '취약점 분석 보고서',
    'subject':  'Linux 취약점 분석 보고서',
    'author':   'Jang.Hyeok:ysa7293@naver.com',
})

title_format = workbook.add_format({
    'bold': 1,
    'border': 1,
    'align': 'center',
    'valign': 'vcenter',
    'bg_color': 'gray'
})

title_format2 = workbook.add_format({
    'border': 1,
    'align': 'center',
    'valign': 'vcenter',
})


font_RISK = workbook.add_format({
    'border': 1,
    'align': 'center',
    'valign': 'vcenter',
    'font_color' : 'red'
})

font_Level_Middle = workbook.add_format({
    'border': 1,
    'align': 'center',
    'valign': 'vcenter',
    'font_color' : 'blue'
})
font_LEFT = workbook.add_format({
    'border': 1,
    'align': 'left',
    'valign': 'vcenter'
})
font_Merge = workbook.add_format({
    'bold': 1,
    'border': 1,
    'align': 'left',
    'valign': 'vcenter'
})
font_pro = workbook.add_format()
font_pro.set_font_size(18)
font_pro.set_font_name('맑은 고딕')
font_pro.set_font_color('navy')

Comment_format = workbook.add_format()
Comment_format.set_font_size(15)
Comment_format.set_font_name('맑은 고딕')
Comment_format.set_font_color('black')
Comment_format.set_bold()

#SET ROW TITLE
headings = ['분류', '항목코드', '점검 항목', '결과', '위험도']
worksheet.write_row(4,0, headings, title_format)

#CELL MERGE
worksheet.merge_range('A6:A20', '1.계정관리', font_Merge)
worksheet.merge_range('A21:A40','2.파일 및 디렉터리 관리', font_Merge)
worksheet.merge_range('A41:A75','3.서비스관리', font_Merge)
worksheet.merge_range('A76:A78','4.패치관리', font_Merge)
worksheet.write('A79:A79','4.로그관리', font_Merge)

#SET Cell Width
worksheet.set_column('C:C', 48.88)
worksheet.set_column('A:A', 13.88)

#SET Time
TimeStamp=(str(datetime.now()))
worksheet.write(0,0,'취약점 분석 보고서:(%s)'%TimeStamp,font_pro)

#Set column for comment report
comment_data = comment_data.split("\n")
for line in range(len(comment_data)-1):
    worksheet2.write(line+3,0,comment_data[line])
    if "[U" in comment_data[line]:
        worksheet2.write(line+3,0,comment_data[line],Comment_format)

#Divide for definition
Acc = 14; Fil = 33; Ser = 67; Pat = 69
Cnt_WeakA = 0; Cnt_WeakF = 0; Cnt_WeakS = 0; Cnt_WeakP = 0
Cnt_GoodA = 0; Cnt_GoodF = 0; Cnt_GoodS = 0; Cnt_GoodP = 0
Cnt_SelfA = 0; Cnt_SelfF = 0; Cnt_SelfS = 0; Cnt_SelfP = 0

#Set column for result report
result_data = result_data.split("\n")
for col in range(len(result_data)-1):
  Chunk = result_data[col].split(":")
  for row in range(0,3):
    worksheet.write(col+5,row+2,Chunk[row],title_format2)
    if row == 0:
        worksheet.write(col+5,row+2,Chunk[row],font_LEFT)
    if Chunk[row] == "상":
        worksheet.write(col+5,row+2,Chunk[row],font_RISK)
    elif Chunk[row] == "중":
        worksheet.write(col+5,row+2,Chunk[row],font_Level_Middle)
# Make a statistical chart
    if Chunk[row] == "취약":
        worksheet.write(col+5,row+2,Chunk[row],font_RISK)
        if col <= Acc:
          Cnt_WeakA=Cnt_WeakA+1;
        elif Acc < col <= Fil:
          Cnt_WeakF=Cnt_WeakF+1;
        elif Fil < col <= Ser:
          Cnt_WeakS=Cnt_WeakS+1;
        elif Ser < col <= Pat:
          Cnt_WeakP=Cnt_WeakP+1;
          
    elif Chunk[row] == "양호":
        if col <= Acc:
          Cnt_GoodA=Cnt_GoodA+1;
        elif Acc < col <= Fil:
          Cnt_GoodF=Cnt_GoodF+1;
        elif Fil < col <= Ser:
          Cnt_GoodS=Cnt_GoodS+1;
        elif Ser < col <= Pat:
          Cnt_GoodP=Cnt_GoodP+1;
          
    elif Chunk[row] == "수동판단":
        if col <= Acc:
          Cnt_SelfA=Cnt_SelfA+1;
        elif Acc < col <= Fil:
          Cnt_SelfF=Cnt_SelfF+1;
        elif Fil < col <= Ser:
          Cnt_SelfS=Cnt_SelfS+1;
        elif Ser < col <= Pat:
          Cnt_SelfP=Cnt_SelfP+1;
          
row=1
for col in range(len(result_data)-1):
    worksheet.write(col+5,row,'U-%d'%(col+1),font_LEFT)

# Add the worksheet data that the charts will refer to.
headings = ['Patch', 'Service', 'File', 'Accounts']
data = [
    [Cnt_GoodP, Cnt_GoodS, Cnt_GoodF, Cnt_GoodA],
    [Cnt_WeakP, Cnt_WeakS, Cnt_WeakF, Cnt_WeakA],
    [Cnt_SelfP, Cnt_SelfS, Cnt_SelfF, Cnt_SelfA],
    ['양호', '취약' , '수동판단'],
]
worksheet.write_row('H6', headings)
worksheet.write_row('H7', data[0])
worksheet.write_row('H8', data[1])
worksheet.write_row('H9', data[2])
worksheet.write_column('G7', data[3])

# Create a new bar chart.
chart = workbook.add_chart({'type': 'bar'})

# Configure the first series.
chart.add_series({
    'name':       '양호',
    'categories': ['Linux_Report', 5, 7, 5, 10],
    'values':     ['Linux_Report', 6, 7, 6, 10],
})
chart.add_series({
    'name':       '취약',
    'values':     ['Linux_Report', 7, 7, 7, 10],
})
chart.add_series({
    'name':       '수동판단',
    'values':     ['Linux_Report', 8, 7, 8, 10],
})

# Add a chart title and some axis labels.
chart.set_title ({'name': 'Linux Risk Rate'})

# Change a chart title and some axis labels of font
chart.set_x_axis({'num_font':  {'name': 'Arial'}})

# Set an Excel chart style.
chart.set_style(10)

# Insert the chart into the worksheet (with an offset).
worksheet.insert_chart('F5', chart, {'x_offset': 45, 'y_offset': 0,
                                     'x_scale': 0.8, 'y_scale': 1})

workbook.close()

