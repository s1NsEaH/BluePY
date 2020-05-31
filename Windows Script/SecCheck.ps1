#Sheet_write ##
Write-Host "Please excute by Admin" –foregroundcolor "Yellow"; sleep 3
chcp 65001 | Out-Null; $path="C:\SecCheck.inf"
secedit /export /cfg $path | Out-Null
#Security Management
function step82{
$Global:count++;
$flag="이터널 블루 취약점 점검:취약:상"
$SMB1=Get-Item "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" | findstr /I "SMB1"
$SMB2=Get-Item "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" | findstr /I "SMB2"
if($SMB1-and$SMB2)
{
    if(([int]$SMB1.split(":")[1]-eq0)-and([int]$SMB2.split(":")[1]-eq0))
    { $flag="이터널 블루 취약점 점검:양호:상" }
}return $flag
}
function step81{
$Global:count++;
$flag="시작프로그램 목록 분석:수동 점검:중"
HyperLink $Global:count "AB3"
Detail_Report "81"
return $flag
}
function step80{
$Global:count++;
$flag="컴퓨터 계정 암호 최대 사용 기간:취약:중"
$DisChange=Get-Content $path | findstr "DisablePasswordChange"
$MaxPasswd=Get-Content $path | findstr "\Parameters\MaximumPasswordAge" 
if($DisChange -and $MaxPasswd)
{
    if(([int]$DisChange.split(",")[1] -eq 0) -and ([int]$MaxPasswd.split(",")[1] -eq 90))
    {
        $flag="컴퓨터 계정 암호 최대 사용 기간:양호:중"
    }
    elseif(([int]$DisChange.split(",")[1] -eq 0) -and ([int]$MaxPasswd.split(",")[1] -ne 90))
    {
        $comment="암호 최대 사용기간:`n90일 권장"
        [void] $Sheet.Range("D$Global:count").Addcomment("comment")
        [void] $Sheet.Range("D$Global:count").Comment.Text($comment)
    }
}return $flag
}
function step79{
$Global:count++;
$flag="파일 및 디렉터리 보호:양호:중"
$DonotUse="FAT"; $FAT=""
$Vol=Get-volume | Select-Object FileSystem | ft -AutoSize | findstr /I $DonotUse
if($?)
{
    $FAT=Get-Volume | Select-Object DriveLetter,FileSystem | ft -AutoSize | findstr /I $DonotUse
    $flag="파일 및 디렉터리 보호:취약:중"
}if($FAT)
{
     $FAT=$FAT -replace($DonotUse,"") -replace(" ","")
     [void] $Sheet.Range("D$Global:count").Addcomment("comment")
     [void] $Sheet.Range("D$Global:count").Comment.Text("FAT파일 시스템:`n$FAT")
}return $flag
}
function step78{
$Global:count++;
$flag="보안 채널 데이터 디지털 암호화 또는, 서명:취약:중"
$Context=Get-Content $path
$A=$Context | findstr /I "RequireSignOrSeal"
$B=$Context | findstr /I "SealSecureChannel"
$C=$Context | findstr /I "SignSecureChannel" | findstr /V "PasswSignSecureChannelordComplexity"
if($A -and $B -and $C)
{
    if([int]$A.split(",")[1] -eq [int]$B.split(",")[1] -eq [int]$C.split(",")[1] -eq 1)
    {
        $flag="보안 채널 데이터 디지털 암호화 또는, 서명:양호:중"
    }
}return $flag
}
function step77{
$Global:count++;
$flag="LAN Manager인증 수준:취약:중"
$Lmlevel=Get-Content $path | findstr /I "LmCompatibilityLevel"
if($Lmlevel)
{
    if([int]$Lmlevel.split(",")[1] -eq 3)
    {
        $flag="LAN Manager 인증 수준:양호:중"
    }
}else{
    [void] $Sheet.Range("D$Global:count").Addcomment("comment")
    [void] $Sheet.Range("D$Global:count").Comment.Text("해당 정책 내용이 없습니다.")
}return $flag
}
function step76{
$Global:count++;
$Direct=Get-ChildItem C:\Users | Select-Object -ExpandProperty Name | findstr /V /I "Public"
$AclList=@("Administrators","SYSTEM")
$Everyfolder=@(); $WrongAcl=@(); $offset=0; $offon=0;
foreach($i in 0..($Direct.Count-1))
{
    $User=$Direct.split("`n")[$i]
    $Acl="C:\Users\"+$User;
    if(icacls $Acl | findstr /I "Everyone")
    {
        $flag="사용자별 홈 디렉터리 권한 설정:취약:중"
        $Everyfolder+=$User+"/"; $offset=1
    }
    else
    {
        if(icacls $Acl | findstr /V $AclList[0] | findstr /V $AclList[1] | findstr /V $User | findstr ":")
        {
            $flag="사용자별 홈 디렉터리 권한 설정:취약:중"
            $WrongAcl+=$User+"/"; $offon=1
        }
    }
}if(($offset -eq 0) -and ($offon -eq 0))
{
    $flag="사용자별 홈 디렉터리 권한 설정:양호:중"
}
else{
    $row=3;$col=24;$coordinates="X3"
    HyperLink $Global:count "Y3"
    Detail_Report_Deco $row $col
    Back_HyperLink 4 $col A76
    $Sheet.Range($coordinates).EntireColumn.Columnwidth = 56.00
    $Sheet.Range($coordinates)="사용자별 홈 디렉터리 권한 취약 정보"; 
    $Sheet.Range($coordinates).HorizontalAlignment = -4108;
    if($offset-eq1)
    { $A="Everyone권한 발견:C:\Users\$Everyfolder"; $Sheet.Range("X5")="$A"; $Sheet.Range("X5").Font.Size=9} # echo $A; }
    if($offon-eq1)
    { $B="사용자 이외의 권한 발견:C:\Users\ $WrongAcl"; $Sheet.Range("X6")="$B"; $Sheet.Range("X6").Font.Size=9} # echo $B; }
}return $flag
}
function step75{
$Global:count++;
$flag="경고 메시지 설정:양호:하"; $comment=""; $set=0
$Caption=Get-Content $path | findstr /I "LegalNoticeCaption"
if($Caption)
{
    if([string]$Caption.split(",")[1] -replace("""","")-eq"")
    {
        $flag="경고 메시지 설정:취약:하"
        $comment+="Caption "; $set=1
    }
}
$Notice=Get-Content $path | findstr /I "LegalNoticeText"
if($Notice)
{
    if($Notice.split(",")[1] -eq "")
    {
       $flag="경고 메시지 설정:취약:하"
       $comment+="Text "; $set=1
    }
}if($set-eq1)
{
    [void] $Sheet.Range("D$Global:count").Addcomment("comment")
    [void] $Sheet.Range("D$Global:count").Comment.Text("취약값 목록:`n"+$comment)
}
return $flag
}
function step74{
$Global:count++;
$flag="세션 연결을 중단하기 전에 필요한 유휴시간:취약:중"
$LogOff=Get-Content $path | findstr "EnableForcedLogOff"
$AutoDis=Get-Content $path | findstr "AutoDisconnect"
if($LogOff -and $AutoDis)
{
    if(([int]$LogOff.split(",")[1]-eq1) -and ($AutoDis.split(",")[1] -eq 15))
    { $flag="세션 연결을 중단하기 전에 필요한 유휴시간:양호:중" }
}
elseif($LogOff -and (!$AutoDis))
{
    if(([int]$LogOff.split(",")[1]-eq1))
    { 
        [void] $Sheet.Range("D$Global:count").Addcomment("comment")
        [void] $Sheet.Range("D$Global:count").Comment.Text("설정된 유휴시간 없습니다.(15분 권장)")
    }
}
return $flag
}
function step73{
$Global:count++;
$flag="사용자가 프린터 드라이버를 설치할 수 없게 함:취약:중"
try{
    if([int](Get-Content $path -ErrorAction Stop | findstr "AddPrinterDrivers").split(",")[1] -eq 1)
    { $flag="사용자가 프린터 드라이버를 설치할 수 없게 함:양호:중" }
}catch{
    [void] $Sheet.Range("D$Global:count").Addcomment("comment")
    [void] $Sheet.Range("D$Global:count").Comment.Text("해당 정책 내용이 없습니다.")
    $flag="사용자가 프린터 드라이버를 설치할 수 없게 함:취약:중"
}
return $flag
}
function step72{
$Global:count++;
$systeminfo=(Get-WmiObject -class Win32_OperatingSystem).caption
$reg="Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\"
$setReg=@("SynAttackProtect","EnableDeadGWDetect","KeepAliveTime","NoNameReleaseOnDemand");
$flag=""; $offset=0; $comment="";
if(($systeminfo | findstr "2003") -or ($systeminfo | findstr "2000") -or ($systeminfo | findstr "NT"))
{
    foreach($i in 0..3)
    {
       switch($i)
       {
         0 { $syn=Get-Item $reg | findstr $setReg[$i]
             if($syn)
             {
                if([int]$syn.split(":")[1] -le 0)
                { $comment+=" SynAttackProtect "; $offset=1 }
             }break;
           }
         1 { $GW=Get-Item $reg | findstr $setReg[$i] 
             if($GW)
             {
                if([int]$GW.split(":")-eq1)
                { $comment+=" EnableDeadGWDetect "; $offset=1 }
             }break;
           }
         2 { $Keep=Get-Item $reg | findstr $setReg[$i]
             if($Keep)
             {
                if([int]$Keep.split(":")-ne300000)
                { $comment+=" KeepAliveTime "; $offset=1 }
             }break;
           }
         3 { $Demand=Get-Item $reg | findstr $setReg[$i]
             if($Demand)
             {
                if([int]$Demand.split(":")-ne1)
                { $comment+=" NoNameReleaseOnDemand "; $offset=1 }
             }break;
           }
       }
    }
    if($offset-eq1)
    {
        [void] $Sheet.Range("D$Global:count").Addcomment("comment")
        [void] $Sheet.Range("D$Global:count").Comment.Text("취약 레지스트리 목록:`n$comment")
        $flag="공격 방버 레지스트리 설정:취약:중"
    }
    else
    { $flag="공격 방버 레지스트리 설정:양호:중" }
}else{
[void] $Sheet.Range("D$Global:count").Addcomment("comment")
[void] $Sheet.Range("D$Global:count").Comment.Text("해당 버전:`n2000 / 2003 / NT")
$flag="공격 방버 레지스트리 설정:양호:중"
}return $flag
}
function step71{
$Global:count++;
$systeminfo=(Get-WmiObject -class Win32_OperatingSystem).caption
$flag="디스크볼륨 암호화 설정:양호:상"
if(($systeminfo | findstr "2003") -or ($systeminfo | findstr "2000"))
{ $flag="디스크볼륨 암호화 설정:수동 점검:상" }
[void] $Sheet.Range("D$Global:count").Addcomment("comment")
[void] $Sheet.Range("D$Global:count").Comment.Text("해당 버전:`n2000 / 2003")
return $flag
}
function step70{
$Global:count++;
$flag="이동식 미디어 포맷 및 꺼내기 허용:취약:상"
$DASD=Get-Content $path | findstr "\AllocateDASD"
if($?)
{
    $DASD=$DASD -replace("""","")
    if([int]$DASD.split(",")[1]-eq0)
    { $flag="이동식 미디어 포맷 및 꺼내기 허용:양호:상" }
}else{
    [void] $Sheet.Range("D$Global:count").Addcomment("comment")
    [void] $Sheet.Range("D$Global:count").Comment.Text("해당 정책 내용이 없습니다.")
}
return $flag
}
function step69{
$Global:count++;
$flag="Autologon 기능 제어:양호:상"
$Winlogon="Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$Auto=Get-Item $Winlogon | findstr /I "AutoAdminLogon"
if($?)
{
    if([int]$Auto.split(":")[1]-eq1)
    { $flag="Autologon 기능 제어:취약:상"}
}
return $flag
}
function step68{
$Global:count++;
[int]$WithSam=(get-content $path | findstr "RestrictAnonymousSAM").split(",")[1]
[int]$Anonymous=(get-content $path | findstr "RestrictAnonymous").split(",")[1]
if(($WithSam -eq 1) -and ($Anonymous -eq 1))
{ $flag="계정과 공유의 익명 열거 허용 안함:양호:상" }
else
{ $flag="계정과 공유의 익명 열거 허용 안함:취약:상" }
return $flag
}
function step67{
$Global:count++;
[int]$Creash=(get-content $path | findstr "CrashOnAuditFail").split(",")[1]
if($Creash -eq 0)
{ $flag="보안 감사를 로그할 수 없는 경우 즉시 시스템 종료:양호:상" }
else
{ $flag="보안 감사를 로그할 수 없는 경우 즉시 시스템 종료:취약:상" }
return $flag
}
function step66{
$Global:count++;
[string]$admin=(get-content $path | findstr "SeRemoteShutdownPrivilege").split("=")[1] -replace(" ","")
if($admin -eq "*S-1-5-32-544")
{ $flag="원격 시스템에서 강제로 시스템 종료:양호:상" }
else
{ $flag="원격 시스템에서 강제로 시스템 종료:취약:상" }
return $flag
}
function step65{
$Global:count++;
[int]$Logon=(Get-Item "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system" | findstr /I "ShutdownWithoutLogon").split(":")[1]
if($Logon -eq 0)
{ $flag="로그온 하지 않고 시스템 종료 허용:양호:상" }
else
{ $flag="로그온 하지 않고 시스템 종료 허용:취약:상" }
return $flag
}
function step64{
$Global:count++;
$com=Get-Item "Registry::HKEY_CURRENT_USER\Control Panel\Desktop"
if($com | findstr "ScreenSaveActive")
{
    [int]$active=($com | findstr "ScreenSaveActive").split(":")[1]
    if($active -eq 1)
    {
        $secure=$com | findstr /I "ScreenSaverisSecure"
        if($?)
        {
            if(($secure.split(":")[1] -eq 1) -and $com | findstr "SCRNSAVE")
            {
                if(($com | findstr /I "ScreenSaveTimeOut").split(":")[1] -le 600)
                { $flag="화면 보호기 설정:양호:상" }
                else
                { $flag="화면 보호기 설정:취약:상" }
            }
            else
            { $flag="화면 보호기 설정:취약:상" }
        }
        else
        { $flag="화면 보호기 설정:취약:상" }
    }
    else
    { $flag="화면 보호기 설정:취약:상" }
}else
{ $flag="화면 보호기 설정:해당/無:상" }
return $flag
}
function step63{
$Global:count++;
$sam="C:\Windows\System32\config\Sam"
$if=icacls $sam | findstr /V "Administrators" | findstr /V "SYSTEM"
if($if | findstr $sam)
{ $flag="파일 접근 통제 설정:취약:상"}
elseif($if.count -eq 2)
{ $flag="파일 접근 통제 설정:양호:상" }
else
{ $flag="파일 접근 통제 설정:취약:상" }
return $flag
}
function step62{
$Global:count++;
$flag="백신 프로그램 설치:수동 점검:상"
[void] $Sheet.Range("D$Global:count").Addcomment("comment")
try{
$comment=get-wmiObject -Namespace "root\securitycenter2" -Class antivirusproduct -ErrorAction Stop | Select-Object -ExpandProperty displayName
[void] $Sheet.Range("D$Global:count").Comment.Text("사용중인 백신:`n"+$comment)
}catch{
    $comment="[해당 운영체제는 지원하지 않습니다.]"
    [void] $Sheet.Range("D$Global:count").Comment.Text($comment)
}return $flag
}
#Log Management
function step61{
$Global:count++;
$flag="원격에서 이벤트 로그 파일 접근 차단:양호:중"
$conf=icacls "C:\Windows\System32\config" | findstr -I "everyone"
$Log=icacls "C:\Windows\System32\LogFiles" | findstr -I "everyone"
if($conf -or $Log)
{
    $flag="원격에서 이벤트 로그 파일 접근 차단:취약:중"
}return $flag
}
function step60{
$Global:count++;
$reg="Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\"
$search=@("Application","Security","System","MaxSize","Retention")
[int]$decimal=0xA00000; $offset=0; $flag=""; $comment=""
try{
foreach($i in 0..2)
{
    $temp=$reg+$search[$i]
    [int]$Msize=(Get-Item $temp -ErrorAction Stop | findstr $search[3] | findstr /v "Upper").split(":")[1]
    [double]$Retent=(Get-Item $temp | findstr $search[4]).split(":")[1]
    if(!(($decimal -le $Msize) -and ($Retent -eq 0)))
    {
        $offset=1
        $comment+=$search[$i]+" "
    }
}
    if($offset -ne 1)
    {
        $flag="이벤트 로그 관리 설정:양호:하" 
    }
    else
    {
        $flag="이벤트 로그 관리 설정:취약:하"
        [void] $Sheet.Range("D$Global:count").Addcomment("comment")
        [void] $Sheet.Range("D$Global:count").Comment.Text("취약 로그 목록:`n"+$comment)
    }
}catch{
    $flag="[해당 사항 없음]"
}return $flag
}
function step59{
$Global:count++;
try{
[string]$start=Get-Item Registry::HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\RemoteRegistry -ErrorAction Stop| findstr "Start"
   [int]$int=$start.Split(":")[1]
    if($int -eq 4)
    {
        $flag="원격으로 액세스할 수 있는 레지스트리 경로 : 양호"
    }
    else
    {
        if(Get-Service "Remote Registry" | findstr /I "Stopped")
        {
            [void] $Sheet.Range("D$Global:count").Addcomment("comment")
            [void] $Sheet.Range("D$Global:count").Comment.Text("시작 유형:`n사용 안함 권장")
            $flag="원격으로 액세스할 수 있는 레지스트리 경로:양호:상"
        }
        else
        {
            $flag="원격으로 액세스할 수 있는 레지스트리 경로:취약:상"
        }
    }
}catch{
    $flag="원격으로 액세스할 수 있는 레지스트리 경로:해당/無:상"
}return $flag
}
function step58{
$Global:count++;
$flag="로그의 정기적 검토 및 보고:수동 점검:상"
[void] $Sheet.Range("D$Global:count").Addcomment("comment")
[void] $Sheet.Range("D$Global:count").Comment.Text("로그 기록 검토 및 분석을 시행하여 리포트 작성하고 정기적 보고")
return $flag
}
#Patch Manegement
function step57{
$Global:count++;
$check=@("AuditLogonEvents = 3","AuditPrivilegeUse = 2","AuditPolicyChange = 3","AuditAccountManage = 2","AuditDSAccess = 2","AuditAccountLogon = 3")
$ToCheck=@(); $flag=0;
foreach($i in 0..5)
{
$bool=(get-content $path) -match $check[$i]
    if(!$bool)
    {
        $flag=1
        [string]$ToString=$check[$i]
        $ToCheck+=$ToString.split(" ")[0]
    }
}
if($flag-eq1)
{
    $tag="정책에 따른 시스템 로깅 설정:취약:중"
    [void] $Sheet.Range("D$Global:count").Addcomment("comment")
    [void] $Sheet.Range("D$Global:count").Comment.Text("이벤트 감사 설정항목:`n"+$ToCheck)
}
else
{
    $tag="정책에 따른 시스템 로깅 설정:양호:중"
}return $tag
}
function step56{
$Global:count++;
$flag="백신 프로그램 업데이트:수동 점검:상"
return $flag
}
function step55{
$Global:count++;
$flag="최신 HOT FIX적용:수동 점검:상"
    HyperLink $Global:count "W3"
    Detail_Report "55"
return $flag
}
#Service management
function step54{
$Global:count++;
$flag="예약된 작업에 의심스러운 명령 등록 유무 점검:수동 점검:중"
    HyperLink $Global:count "S3"
    Detail_Report "54"
return $flag
}
function step53{
$Global:count++;
try{
[int]$IdleTime=(Get-WmiObject -namespace "ROOT\CIMV2\TerminalServices" -ErrorAction Stop -class Win32_TSSessionSetting | findstr /I "IdleSessionLimit" |findstr /V "Policy").split(":")[1]
if($IdleTime -ne 0)
{ $flag="원격터미널 접속 타임아웃 설정:양호:중" }
else
{ $flag="원격터미널 접속 타임아웃 설정:취약:중" }
}catch{
  Get-Item "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -ErrorAction Ignore | findstr /I "MaxIdleTime" | Out-Null
    if($? -eq $true)
    {$flag="원격터미널 접속 타임아웃 설정:양호:중"}
    else
    {$flag="원격터미널 접속 타임아웃 설정:취약:중"}
}
return $flag
}
function step52{
$Global:count++;
$reg="Registry::HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBC.INI"
$source=@(); $data=@(); $offset=0; $flag=""; $on=0
try{
$source+=get-Item "$reg\ODBC Data Sources" -ErrorAction Stop | Select-Object -ExpandProperty property
$data+=get-ChildItem $reg | Select-Object -ExpandProperty name
$count=$source.Count-1
if($count -eq -1)
{ $flag="불필요한 ODBC/OLE-DB 데이터 소스와 드라이브 제거:양호:중"}
else
{
foreach($i in 0..$count)
{
    $bool=$data | findstr $source[$i]
    if(!$bool)
    {
        $offset=1
        $flag+=$source[$i]+" "
    }
}
    if($offset-eq1)
    {
        $comment="불필요한 리소스: $flag"; $on=1
        $flag="불필요한 ODBC/OLE-DB 데이터 소스와 드라이브 제거:취약:중";
    }
    else
    {
        $comment="불필요한 리소스를 찾지 못했습니다.`n리소스 항목: $source"; $on=1
        $flag="불필요한 ODBC/OLE-DB 데이터 소스와 드라이브 제거:수동 점검:중"
    }
}
}catch{
    $flag="불필요한 ODBC/OLE-DB 데이터 소스와 드라이브 제거:양호:중"
}if($on-eq1){
    [void] $Sheet.Range("D$Global:count").Addcomment("comment")
    [void] $Sheet.Range("D$Global:count").Comment.Text("$comment")
}
return $flag
}
function step51{
$Global:count++;
try{
    if(Get-Service tlntsvr -ErrorAction Stop)
    {
    $passwd=tlntadmn | findstr /I "Password"
    $NTLM=tlntadmn | findstr /I "NTLM"
        if(($passwd) -or (($NTLM) -and ($passwd)))
        {
            $flag="Telnet 보안 설정:취약:중"
        }
        else
        {
            $flag="Telnet 보안 설정:양호:중"
        }
    }
}catch{
    $flag="Telnet 보안 설정:양호:중"
}return $flag
}
function step50{
$Global:count++;
[int]$flag="0"
$web="localhost"; $smtp="localhost"
$Iflag="";$Fflag="";$Mflag=""
$dict=@("Server","X-Powered-By","ftpsvc","DefaultBanner","Version")
try{
    if(netstat -anp tcp | findstr ":80")
    {
      $com=(Invoke-WebRequest $web -ErrorAction Stop).headers
        if(($com | findstr /I $dict[0]) -or ($com | findstr /I $dict[1]))
        {    $Iflag="HTTP"    }
        else
        {    $flag++    }
    }
    else
    {
        $Iflag="Not working IIS service"
    }
}catch{
    $flag++;
}

$ftp="C:\Windows\System32\inetsrv\config\applicationHost.config"
try{
if((Get-service) -match $dict[2])
{
$Banner=(Get-content $ftp -ErrorAction Stop | findstr /I $dict[3]) -match "false"
    if($Banner)
    {
        $Fflag="FTP";
    }
    else
    {
        $flag++;
    }
}else{
    $flag++
}
}catch{
    $flag++
}
try{
$socket=new-object System.Net.Sockets.TcpClient($smtp, "25") -ErrorAction Stop
$stream=$socket.GetStream()
$buffer=new-object System.Byte[] 1024
$len=$stream.Read($buffer,0,1024)
$encode=new-object System.Text.ASCIIEncoding

    if($encode.GetString($buffer,0,$len) -match $dict[4])
    {
        $Mflag="SMTP"
    }
    else
    {
        $flag++;
    }
}catch{
    $flag++;
}
if($flag -eq 3)
{
    [string]$flag="HTTP/FTP/SMTP 배너 차단:양호:하"
}
else
{
    $comment="취약:$Iflag/$Fflag/$Mflag"
    [void] $Sheet.Range("D$Global:count").Addcomment("comment")
    [void] $Sheet.Range("D$Global:count").Comment.Text("$comment")   
    [string]$flag="HTTP/FTP/SMTP 배너 차단:취약:하"
}return $flag
}
function step49{
$Global:count++;
$reg="Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones"
$ls=@(); $vul=""; $set=0
try{
$ls+=Get-ChildItem $reg -ErrorAction Stop | ForEach-Object -MemberName Name
$count=$ls.count-1

    foreach($i in 0..$count)
    { 
        $temp=reg query $ls[$i] | findstr /I "AllowUpdate"
        if($?)
        {
        [int]$compare=(reg query $ls[$i] | findstr /I "AllowUpdate").split("x")[1]
            if(($compare -ne 1))
            {
                $flag="DNS 서비스 구동 점검:양호:중"
            }
            else
            {
                $vul+=($ls[$i]).split("\")[7]+"  "
                $comment="Zone File: $vul"; $set=1
                $flag="DNS 서비스 구동 점검:취약:중"
            }
        }
        else
        {
            $flag="DNS 서비스 구동 점검:양호:중"
        }
    }
}catch{
    $flag="DNS 서비스 구동 점검:양호:중"
}if($set-eq1)
{
    [void] $Sheet.Range("D$Global:count").Addcomment("comment")
    [void] $Sheet.Range("D$Global:count").Comment.Text("$comment")   
}return $flag
}
function step48{
$Global:count++;
$reg="Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers"
try{
$count=(get-Item $reg -ErrorAction Stop | Select-Object -ExpandProperty Property).count
    if($count -eq 0)
    { $flag="SNMP Access control 설정:취약:중" }
    else
    { $flag="SNMP Access control 설정:양호:중" }
}catch{
    $flag="SNMP Access control 설정:양호:중"
}return $flag
}
function step47{
$Global:count++;
$reg="Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities"
$ban=@("public","private")
try{
    $bool=(get-Item $reg -ErrorAction Stop | findstr $ban[0]) -or (get-Item $reg | findstr  $ban[1])
    if($bool)
    { $flag="SNMP 서비스 커뮤니티스트링의 복잡성 설정:취약:중" }
    else
    { $flag="SNMP 서비스 커뮤니티스트링의 복잡성 설정:양호:중" }
}catch{
    $flag="SNMP 서비스 커뮤니티스트링의 복잡성 설정:양호:중"
}return $flag
}
function step46{
$Global:count++;
try{
$info=get-service snmp -ErrorAction Stop
    if($?)
    {
        $com=$info | findstr /I "Running"
        if($?)
        { $flag="SNMP 서비스 구동 점검:취약:중" }
        else
        { 
            $flag="SNMP 서비스 구동 점검:양호:중"
            [void] $Sheet.Range("D$Global:count").Addcomment("comment")
            [void] $Sheet.Range("D$Global:count").Comment.Text("SNMP 서비스가 필요하지 않다면 서비스 삭제")
        }
    }
    else
    { $flag="SNMP 서비스 구동 점검:양호:중" }
}catch{
    $flag="SNMP 서비스 구동 점검:양호:중"
}return $flag
}
function step45{
$Global:count++;
$find="error statusCode"
$error_code=@("401","403","404","405","406","412","500","501","502")
$list=@(); $set=0; $on=0
$count=$error_code.Count
try{
$get=get-content C:\Windows\System32\inetsrv\config\applicationHost.config -ErrorAction  Stop | select-string $find
for($i=0;$i-lt$count;$i++)
{
    $bool=$get -cmatch $error_code[$i]
    if(!$bool)
    {
        $set=1
        $list+=$error_code[$i]        
    }
}
    if($set-eq1)
    {
        $flag="IIS 웹 서비스 정보 숨김:취약:중"
        $comment="ErrorPage:`n[$list]"; $on=1
    }
    else
    {
        $flag="IIS 웹 서비스 정보 숨김:양호:중"
        $comment="ErrorPage:부재`n[$error_code]"; $on=1
    }
}catch{
    $flag="IIS 웹 서비스 정보 숨김:해당/無:중"
}if($on-eq1){
    [void] $Sheet.Range("D$Global:count").Addcomment("comment")
    [void] $Sheet.Range("D$Global:count").Comment.Text("$comment")
}return $flag
}
function step44{
$Global:count++;
$find="MinEncryptionLevel"
try{
[int]$get=(get-Item "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\" -ErrorAction Stop | findstr $find).split(":")[1]
    if(2 -le $get)
    { $flag="터미널 서비스 암호화 수준 설정:양호:중"}
    else
    { $flag="터미널 서비스 암호화 수준 설정:취약:중"}
}catch{
    $flag="터미널 서비스 암호화 수준 설정:양호:중"
}
return $flag
}
function step43{
$Global:count++;
$comment=systeminfo | find /I "OS 버전" | select-object -First 1
[void] $Sheet.Range("D$Global:count").Addcomment("comment")
[void] $Sheet.Range("D$Global:count").Comment.Text("$comment")
$flag="최신 서비스팩 적용:수동 점검:상"
return $flag
}
function step42{
$Global:count++;
$flag="RDS(Remote Data Services) 제거:양호:상"
$list=@("RDSServer.DataFactory","AdvancedDataFactory","VbBusObj.VbBusObjCls")
$delist=@(); $set=0
try{
    for($i=0;$i-le2;$i++)
    {
        $text=get-Item Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters\ADCLaunch -ErrorAction Stop | findstr /I $list[$i]
        if($?)
        { $delist+=$list[$i]; $set=1 }
    }
    if($set-eq1)
    {
         $comment=$delist; $flag="RDS(Remote Data Services) 제거:취약:상" 
         [void] $Sheet.Range("D$Global:count").Addcomment("comment")
         [void] $Sheet.Range("D$Global:count").Comment.Text(" $comment")
    }
}catch{
    $flag="RDS(Remote Data Services) 제거:양호:상"
}return $flag
}
function step41{
$Global:count++;
$reg="Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DNS Server\Zones"
$flag="DNS Zone Transfer 설정:양호:상"
try{
$ls=@(); $vul=""; $set=0
$ls+=Get-ChildItem $reg -ErrorAction Stop | ForEach-Object -MemberName Name
$count=$ls.count-1

    foreach($i in 0..$count)
    {
        [int]$compare=(reg query $ls[$i] | findstr /I "SecureSecondaries").split("x")[1]
        if(($compare -eq 2) -or ($compare -eq 3))
        { $flag="DNS Zone Transfer 설정:양호:상" }
        else
        {
            $vul+=($ls[$i]).split("\")[7]+"  "
            $comment="List: $vul"
            $flag="DNS Zone Transfer 설정:취약:상"
            $set=1
        }
    }  
}catch{
    $flag="DNS Zone Transfer 설정:양호:상"
}if($set-eq1){
    [void] $Sheet.Range("D$Global:count").Addcomment("comment")
    [void] $Sheet.Range("D$Global:count").Comment.Text(" $comment")
}
return $flag
}
function step40{
$Global:count++;
$Fpath="C:\Windows\System32\inetsrv\config\applicationHost.config"
$line=@("<system.ftpServer>","</system.ftpServer>")
$flag="FTP 접근 제어 설정:취약:상"
try{
$start=(get-content $Fpath -ErrorAction Stop | findstr -n $line[0]).split(":")[0]-1
$end=(get-content $Fpath | findstr -n $line[1]).split(":")[0]-1
$parser=get-content $Fpath | Select-string $line[0] -context 0,($end-$start)
    if($parser | findstr /I "ipaddress")
    {
        $flag="FTP 접근 제어 설정:양호:상"
    }
}catch{
    $flag="FTP 접근 제어 설정:해당/無:상"
}
return $flag
}
function step39{
$Global:count++;
$Fpath="C:\Windows\System32\inetsrv\config\applicationHost.config"
$str="<anonymousAuthentication enabled=""true"" />"
$flag="Anonymous FTP 금지:양호:상"
try{
$parser=Get-Content $Fpath -ErrorAction Stop | findstr $str
    if($parser)
    { $flag="Anonymous FTP 금지:취약:상" }
    else
    { $flag="Anonymous FTP 금지:양호:상" } 
}catch{
    $flag="Anonymous FTP 금지:양호:상"
}return $flag
}
function step38{
$Global:count++;
$service=@(); $port=@(); $comment=@(); $flag="FTP 디렉터리 접근권한 설정:양호:상"
try{
$service+=Get-content C:\Windows\System32\inetsrv\config\applicationHost.config -ErrorAction Stop | find "binding protocol="
$port+=Get-content C:\Windows\System32\inetsrv\config\applicationHost.config | select-string "physicalPath"
$count=$service.count-1
    foreach($i in 0..$count)
    {
        if($service[$i] | findstr "ftp")
        {
            $folder=($port[$i].ToString()).split("""")[3]
            if(icacls $folder | findstr /I "Everyone")
            {
                $comment+=$folder;
                [void] $Sheet.Range("D$Global:count").Addcomment("comment")
                [void] $Sheet.Range("D$Global:count").Comment.Text(" $comment")
                $flag="FTP 디렉터리 접근권한 설정:취약:상"
            }
        }
    }
}catch{
    $comment.Clear(); $comment="FTP 설정 파일이 없거나 찾을 수 없습니다."
   [void] $Sheet.Range("D$Global:count").Addcomment("comment")
   [void] $Sheet.Range("D$Global:count").Comment.Text(" $comment")
}return $flag
}
function step37{
$Global:count++;
try
{
    $info=get-service ftpsvc -ErrorAction Stop
    if($?)
    {
        if($info | findstr /I "Running")
        { $flag="FTP 서비스 구동 점검:취약:상" }
       else
        {
            $flag="FTP 서비스 구동 점검:양호:상"
            [void] $Sheet.Range("D$Global:count").Addcomment("comment")
            [void] $Sheet.Range("D$Global:count").Comment.Text("FTP 서비스가 필요하지 않다면 서비스 삭제")
        }
    }
    else
    { $flag="FTP 서비스 구동 점검:양호:상" }
}catch{
    $flag="FTP 서비스 구동 점검:양호:상"
}return $flag
}
function step36{
$Global:count++;
$flag="NetBIOS 바인딩 서비스 구동 점검:양호:상"
$info=reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards" /s | findstr "ServiceName"
[string]$str=($info).split("{,}")[1]
$info2=reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\services\NetBT\Parameters\Interfaces" /s | select-string $str -context 0,2 | findstr "NetbiosOptions"
[int]$int=($info2).split("x")[1]
if($int -eq 1)
{ $flag="NetBIOS 바인딩 서비스 구동 점검:취약:상" }
return $flag
}
function step35{
$Global:count++;
$flag="IIS WebDAV 비활성화:양호:상"
try{
$info=Get-ItemProperty -ErrorAction Stop -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\W3SVC\Parameters"
$version=$info | findstr "DisableWebDAV"
[int]$int=($version).split(":")[1]
    if($int -eq 1)
    { $flag="IIS WebDAV 비활성화:양호:상" }
    else
    { $flag="IIS WebDAV 비활성화:취약:상" }
}catch{
    $flag="IIS WebDAV 비활성화:양호:상"
}return $flag
}
function step34{
$Global:count++;
try{
$info=Get-ItemProperty -ErrorAction Stop -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp"
$version=$info | findstr "MajorVersion"
[int]$int=($version).split(":")[1]

    if($int -ge 6)
    { $flag="IIS Exec 명령어 쉘 호출 진단:양호:상" }
    else
    {
        $info2=Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\W3SVC\Parameters"
        $version2=$info2 | findstr "SSlEnableCmdDirective"
        [int]$int2=($version2).split(":")[1]

        if($int2 -eq 0)
        { $flag="IIS Exec 명령어 쉘 호출 진단:양호:상" }
        else
        { $flag="IIS Exec 명령어 쉘 호출 진단:취약:상" }
    }
}catch{
    $flag="IIS Exec 명령어 쉘 호출 진단:양호:상"
}
return $flag
}
function step33{
$Global:count++;
$flag="IIS 미사용 스크립트 매핑 제거:양호:상"
$list=@("\.htr","\.idc","\.stm","\.shtm","\.shtml","\.printer","\.htw","\.ida","\.id")
$comment=@(); $set=0;
$count=$list.count-1
try
{
    foreach($i in 0..$count)
    {
        $bool=get-content "C:\Windows\System32\inetsrv\config\applicationHost.config"`
         -ErrorAction Stop | findstr /e $list[$i]
        
         if($bool)
         {
            $comment+=$list[$i]; $set=1
            $flag="IIS 미사용 스크립트 매핑 제거:취약:상"
         }
    }
}catch{
    $flag="IIS 미사용 스크립트 매핑 제거:양호:상"
}if($set-eq1)
{
    $j=$comment.Count-1
    foreach($i in 0..$j)
    { $comment[$i]=$comment[$i] -replace("\\","*") }
   [void] $Sheet.Range("D$Global:count").Addcomment("comment")
   [void] $Sheet.Range("D$Global:count").Comment.Text(" $comment")
}
return $flag
}
function step32{
$Global:count++;
try{
$array=@(); [System.Collections.ArrayList]$comment=@();
$flag="IIS 데이터 파일 ACL 적용:양호:상";  $set=0;
$array+=Get-ChildItem -Recurse -Path C:\inetpub\wwwroot -ErrorAction Stop| get-acl | Select-Object -ExpandProperty path
$count=$array.Count-1
foreach($i in 0..$count)
{
    $Rename=$array[$i].Replace("Microsoft.PowerShell.Core\FileSystem::","")
    if(icacls $Rename | findstr /I "Everyone")
    {
        $set=1
        $comment+=$Rename
        if(($Rename | findstr ".htm") -or ($Rename | findstr ".gif") -or ($Rename | findstr ".jpg") -or ($Rename | findstr ".txt"))
        {
            if(icacls $Rename | findstr "Everyone:(R)")
            {
                $comment.Remove($Rename)
            }
        }
    }
}
}catch{
    $flag="IIS 데이터 파일 ACL 적용:양호:상"
}
if($set-eq1){
   [void] $Sheet.Range("D$Global:count").Addcomment("comment")
   [void] $Sheet.Range("D$Global:count").Comment.Text(" $comment")
    $flag="IIS 데이터 파일 ACL 적용:취약:상"
}return $flag
}
function step31{
$Global:count++;
try{
$info=Get-ItemProperty -ErrorAction Stop -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp"
$version=$info | findstr "MajorVersion"
[int]$int=($version).split(":")[1]
    if($int -ge 6)
    {
        $flag="IIS 가상 디렉터리 삭제:양호:상"
    }
    else
    {
        $flag="IIS 가상 디렉터리 삭제:수동 점검:상"
    }
}catch{
    $flag="IIS 가상 디렉터리 삭제:양호:상"
}return $flag
}
function step30{
$Global:count++;
$Fpath="C:\Windows\System32\inetsrv\config\applicationHost.config"
try{
    $parser=get-content $Fpath -ErrorAction Stop | findstr ".asa"
    if($parser)
    {
        if($parser | findstr /I "false")
        { $flag="IIS DB 연결 취약점 점검:양호:상" }
        else
        { $flag="IIS DB 연결 취약점 점검:취약:상" }
    }
    else
    { $flag="IIS DB 연결 취약점 점검:취약:상" }
}catch{ 
   $flag="IIS DB 연결 취약점 점검:양호:상"
   [void] $Sheet.Range("D$Global:count").Addcomment("comment")
   [void] $Sheet.Range("D$Global:count").Comment.Text("IIS 설정 파일이 없거나 찾을 수 없습니다.")
}return $flag
}
function step29{
$Global:count++;
$Fpath="C:\Windows\System32\inetsrv\config\applicationHost.config"
$str=@("maxAllowedContentLength","bufferingLimit","maxRequestEntityAllowed")
$flag="IIS 파일 업로드 및 다운로드 제한:취약:상"
try{
    $result=Get-ChildItem $Fpath -ErrorAction Stop
    $A=get-content $result | findstr $str[0]
    $B=get-content $result | findstr $str[1]
    $C=get-content $result | findstr $str[2]
    if($A -and $B -and $C)
    {
        $flag="IIS 파일 업로드 및 다운로드 제한:양호:상"
    }
}catch{ 
   $flag="IIS 파일 업로드 및 다운로드 제한:양호:상"
   [void] $Sheet.Range("D$Global:count").Addcomment("comment")
   [void] $Sheet.Range("D$Global:count").Comment.Text("IIS 설정 파일이 없거나 찾을 수 없습니다.")
}return $flag
}
function step28{
$Global:count++;
$flag="IIS 링크 사용금지:양호:상"
try{
$link=get-ChildItem "C:\inetpub\wwwroot" -ErrorAction Stop | findstr "lnk"
    if($link)
    {
        $flag="IIS 링크 사용금지:취약:상"
    }
}catch{
    $flag="IIS 링크 사용금지:양호:상"
}return $flag
}
function step27{
$Global:count++;
$com=netstat -anp tcp | findstr "80" | findstr " LISTENING"
if($com)
{
    $flag="IIS 웹 프로세스 권한 제한:수동 점검:상"
    HyperLink $Global:count "P3"
    Detail_Report "27"
}
else
{
    $flag="IIS 웹 프로세스 권한 제한:양호:상"
}return $flag
}
function step26{
$Global:count++;
$flag="IIS 불필요한 파일 제거:양호:상"
try{
$info=Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InetStp" -ErrorAction Stop
$version=$info | findstr "MajorVersion"
if($version){
[int]$int=($version).split(":")[1]
    if($int -ge 7)
    {
        $flag="IIS 불필요한 파일 제거:양호:상"
    }
    else
    {
        $flag="IIS 불필요한 파일 제거:수동 점검:상"
        $comment="[ 파일 조치 및 버전 업데이트 요망 ]`nc:\inetpub\iissamples`nc:\winnt\help\iishelp`nc:\program files\common files\system\msadc\sample"
        [void] $Sheet.Range("D$Global:count").Addcomment("comment")
        [void] $Sheet.Range("D$Global:count").Comment.Text("$comment")
    }
}
}catch{
    $flag="IIS 불필요한 파일 제거:양호:상"
}return $flag
}
function step25{
$Global:count++;
$Fpath="C:\Windows\System32\inetsrv\config\applicationHost.config"
$str="enableParentPaths"
try{
    $result=Get-ChildItem $Fpath -ErrorAction Stop
    $parser=get-content $Fpath | findstr /I $str
    if($parser)
    {
        if($parser | findstr /I "true")
        {$flag="IIS 상위 디렉터리 접근 금지:취약:상"}
        else
        {$flag="IIS 상위 디렉터리 접근 금지:양호:상"}
    }
    else
    {
        $flag="IIS 상위 디렉터리 접근 금지:양호:상"
    }
}catch{ 
   [void] $Sheet.Range("D$Global:count").Addcomment("comment")
   [void] $Sheet.Range("D$Global:count").Comment.Text("IIS 설정 파일이 없거나 찾을 수 없습니다.")
   $flag="IIS 상위 디렉터리 접근 금지:양호:상"
}return $flag
}
function step24{
$Global:count++;
$flag="IIS CGI 실행 제한:양호:상"
try{
   $Everyone=Get-Acl -Path "C:\inetpub\scripts" -ErrorAction Stop | Select-Object -ExpandProperty Access | select-object -Property IdentityReference, FileSystemrights | format-table -auto | findstr /I "Everyone"
   $A=$Everyone | findstr /I "FullControl"; $B=$Everyone | findstr /I "Write"; $C=$Everyone | findstr /I "Modify"
   if($A -or $B -or $C)
   {
       $flag="IIS CGI 실행 제한:취약:상"; $on=1
       $comment=$Everyone -replace(" ","") -replace("Everyone","Everyone: ")
   }
}catch{
    $flag="IIS CGI 실행 제한:양호:상"; $on=1
    $comment="C:\inetpub\scripts IIS CGI 파일이 없거나 찾을 수 없습니다."   
}if($on -eq 1){
   [void] $Sheet.Range("D$Global:count").Addcomment("comment")
   [void] $Sheet.Range("D$Global:count").Comment.Text("$comment")
}return $flag
}
function step23{
$Global:count++;
$Fpath="C:\Windows\System32\inetsrv\config\applicationHost.config"
$str="directoryBrowse enabled"
try{
    $result=Get-ChildItem $Fpath -ErrorAction Stop
    $parser=get-content $Fpath | find /I $str
    if($parser)
    {
        if($parser | findstr /I "true")
        {$flag="IIS 디렉터리 리스팅 제거:취약:상"}
        else
        {$flag="IIS 디렉터리 리스팅 제거:양호:상"}
    }
    else
    {
        $flag="IIS 디렉터리 리스팅 제거:양호:상"
    }
}catch{ 
   [void] $Sheet.Range("D$Global:count").Addcomment("comment")
   [void] $Sheet.Range("D$Global:count").Comment.Text("IIS 설정 파일이 없거나 찾을 수 없습니다.")
   $flag="IIS 디렉터리 리스팅 제거:양호:상"
}return $flag
}
function step22{
$Global:count++;
$flag="IIS 서비스 구동 점검:양호:상"
$W3SVC=get-service | findstr "W3SVC"
$IIS=get-service | findstr /I "iisadmin"
if($W3SVC -or $IIS)
{
    $flag="IIS 서비스 구동 점검:취약:상"
}return $flag
}
function step21{
$Global:count++;
$StopService=@(); $set=0; $flag="불필요한 서비스 제거:양호:상"
$alerter=net start | findstr /I "alerter"
$Clipbook=net start | findstr /I "Clipbook"
$Messenger=net start | findstr /I "Messenger"
$Simple=net start | find /I "Simple Tcp/IP"
if($alerter -or $Clipbook -or $Messenger -or $Simple)
{
    $set=1; $flag="불필요한 서비스 제거:취약:상"
    if($Clipbook){$StopService+="Clipbook"}
    if($alerter){$StopService+="alerter"}
    if($Messenger){$StopService+="Messenger"}
    if($Simple){$StopService+="Simple Tcp/IP"}
}if($set -eq 1)
{
    [void] $Sheet.Range("D$Global:count").Addcomment("comment")
    [void] $Sheet.Range("D$Global:count").Comment.Text("$StopService")
}return $flag
}
function step20{
$Global:count++;
$Auto=Get-Item "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" | findstr /I "AutoShareServer"
$flag="하드디스크 기본 공유 제거:취약:상";
if($Auto)
{
    $DFS=net share | select-string "기본 공유","Default share"
    if(([int]$Auto.split(":")[1]-eq0) -and ($DFS))
    {
        $flag="하드디스크 기본 공유 제거:양호:상"
    }
}return $flag
}
function step19{
$Global:count++;
$a=@("기본 공유","원격 IPC","원격 관리")
$b=@("Remote Admin","Default share","Remote IPC")
try{
get-smbshare -ErrorAction Stop | Out-Null
$list=net share | select-string -notmatch $a[0] | select-string -notmatch $a[1] | select-string -notmatch $a[2] `
                | select-string -notmatch $b[0] | select-string -notmatch $b[1] | select-string -notmatch $b[2]
$len=($list).length
$fin="명령을"
for($line=0;$line -lt $len;$line++)
{
    $com=net share | select-object -index $line
    $bool=$com -cmatch "--------"
       if($bool -eq "True")
    {
         $get=$line
         break
    }
}
$get=$get+1
$array=@()
$j=0
for(;$get -lt $len; $get++)
{
    $aa=$list | select-object -index $get
    $bb=("$aa").split(" ")[0]
    $boolean=$bb -cmatch $fin
    if($boolean -eq "True")
    { 
        $length=$j
        break 
    }
    $array+=$bb   
    $j++
}
if($j -eq 0)
{ $flag="공유 권한 및 사용자 그룹 설정:양호:상" }
else{
for($i=0;$i-lt$j;$i++){
    if(net share $array[$i] | findstr /I "Everyone")
    {
        $comment=(net share $array[$i] | findstr "경로") -replace(" ","") -replace("경로","경로 ")
        $flag="공유 권한 및 사용자 그룹 설정:취약:상"
        [void] $Sheet.Range("D$Global:count").Addcomment("comment")
        [void] $Sheet.Range("D$Global:count").Comment.Text("$comment")
    }
    else
    {
        $flag="공유 권한 및 사용자 그룹 설정:양호:상"
    }
  }
}
}#try
catch{
        $comment="System error:1058 net share does not started."
        [void] $Sheet.Range("D$Global:count").Addcomment("comment")
        [void] $Sheet.Range("D$Global:count").Comment.Text("$comment")
}
return $flag
}
#Account management
function step18{
$Global:count++;
$flag="원격터미널 접속 가능한 사용자 그룹 제한:그룹/無:중"
$command='net localgroup "Remote Desktop Users"'
if(net localgroup | find "Remote Desktop Users")
{ 
    $flag="원격터미널 접속 가능한 사용자 그룹 제한:수동 점검:중" 
    $list=Invoke-Expression $command
    $len=($list).length
    $fin="명령을"
   
    for($line=0;$line -lt $len;$line++)
    {
        $com=Invoke-Expression $command | select-object -index $line
        $bool=$com -cmatch "--------"
            if($bool -eq "True")
            {
                $get=$line
                break
            }
    }
$get=$get+1
$array=@()

for(;$get -lt $len; $get++)
{
    $aa=$list | select-object -index $get
    $boolean=$aa -cmatch $fin
    if($boolean -eq $True)
    { break }
    $array+=$aa
}
    $comment=$array
    if($comment.Length -eq 0)
    {$flag="원격터미널 접속 가능한 사용자 그룹 제한:그룹/無:중" }
    else
    {
    [void] $Sheet.Range("D$Global:count").Addcomment("comment")
    [void] $Sheet.Range("D$Global:count").Comment.Text("$comment")
    }
}
else
{ $flag="원격터미널 접속 가능한 사용자 그룹 제한:그룹/無:중" }

return $flag
}
function step17{
$Global:count++;
$bool=Get-Content $path | findstr "LimitBlankPasswordUse"
$offset=$bool -cmatch "1"
if($offset -ne "True"){
    $offset="콘솔 로그온 시 로컬 계정에서 빈 암호 사용 제한:취약:중"
}
else{
    $offset="콘솔 로그온 시 로컬 계정에서 빈 암호 사용 제한:양호:중"
}
return $offset
}
function step16{
$Global:count++;
$Password=net accounts | select-string "Length of password history maintained"
$flag="최근 암호 기억:취약:중"
[String]$minu=("$Password").split(":")[1]
$bool= $minu -match "None"
if($bool -eq "True"){
    $flag="최근 암호 기억:취약:중"
}
elseif ($bool -ne "False"){
    if([int]$minu -ge 12){
    $flag="최근 암호 기억:양호:중"
    }
}
else { $flag="최근 암호 기억:취약:중"}
return $flag
}
function step15{
$Global:count++;
$bool=Get-Content $path | findstr "LSAAnonymousNameLookup"
$offset=$bool -cmatch "0"
if($offset -eq "True"){
    $offset="익명 SID/이름 변환 허용:양호:중"
}
else{
    $offset="익명 SID/이름 변환 허용:취약:중"
}
return $offset
}
function step14{
$Global:count++;
[string]$LogonRight=(get-content $path | findstr /I "SeInteractiveLogonRight").split("=")[1] -replace(" ","")
if(($LogonRight | findstr "S-1-5-32-544")-and($LogonRight | findstr "S-1-5-17"))
{  $flag="로컬 로그온 허용:양호:중" }
elseif($LogonRight -eq "*S-1-5-32-544")
{ $flag="로컬 로그온 허용:양호:중" }
else
{ $flag="로컬 로그온 허용:취약:중" }
return $flag
}
function step13{
$Global:count++;
$bool=Get-Content $path | findstr "DontDisplayLastUserName"
$offset=$bool -cmatch "0"
if($offset -eq "True"){
    $offset="마지막 사용자 이름 표시 안함:취약:중"
}
else{
    $offset="마지막 사용자 이름 표시 안함:양호:중"
}
return $offset
}
function step12{
$Global:count++;
$Password=net accounts | select-string "Minimum password age"
$flag="패스워드 최소 사용 기간:취약:중"
[int]$minu=("$Password").split(":")[1]
if($minu -le 0){
    $flag="패스워드 최소 사용 기간:취약:중"
}
else{
    $flag="패스워드 최소 사용 기간:양호:중"
}
return $flag
}
function step11{
$Global:count++;
$Password=net accounts | select-string "Maximum password age"
$flag="패스워드 최대 사용 기간:취약:중"
[int]$minu=("$Password").split(":")[1]
if($minu -ge 90){
    $flag="패스워드 최대 사용 기간:취약:중"
}
else{
    $flag="패스워드 최대 사용 기간:양호:중"
}
return $flag
}
function step10{
$Global:count++;
$Password=net accounts | select-string "Minimum password length"
$flag="weak"
[int]$minu=("$Password").split(":")[1]
if($minu -lt 7){
    $flag="패스워드 최소 암호 길이:취약:중"
}
else{
    $flag="패스워드 최소 암호 길이:양호:중"
}
return $flag
}
function step9{
$Global:count++;
$bool=Get-Content $path | findstr "PasswordComplexity"
$offset=$bool -cmatch "0"
if($offset -eq $True){
    $offset="패스워드 복잡성 설정:취약:중"
}
else{
    $offset="패스워드 복잡성 설정:양호:중"
}
return $offset
}
function step8{
$Global:count++;
$Guest=net accounts | select-string "Lockout duration"
$flag="weak"
[int]$minu=("$Guest").split(":")[1]
if($minu -lt 60){
    $flag="계정 잠금 기간 설정:취약:중"
}
else{
    $flag="계정 잠금 기간 설정:양호:중"
}
return $flag
}
function step7{
$Global:count++;
$bool=type $path | findstr "EveryoneIncludesAnonymous"
$offset=$bool -cmatch "0"
if($offset -eq $True){
    $offset="Everyone 사용 권한을 익명 사용자에게 적용:양호:중"
}
else{
    $offset="Everyone 사용 권한을 익명 사용자에게 적용:취약:중"
}
return $offset
}
function step6{
$Global:count++;
$group=net localgroup administrators
$len=($group).length
for($line=0;$line -lt $len;$line++)
{
    $com=$group | select-object -index $line
    $bool=$com -cmatch "--------"
       if($bool -eq "True")
    {
         $get=$line
         break
    }
}
$get=$get+1; $array=@(); $j=0
for(;$get -lt $len; $get++)
{
    $aa=$group | select-object -index $get
    $bb=("$aa").split(" ")[0]
    $boolean=$bb -cmatch $fin
    if($boolean -eq "True")
    { 
        $length=$j
    }
    $array+=$bb   
    $j++
}
$j=$j-2; $comment=@()
for($i=0;$i-lt$j;$i++){
      $comment+=$array[$i]
}
[void] $Sheet.Range("D$Global:count").Addcomment("comment")
[void] $Sheet.Range("D$Global:count").Comment.Text("AdminGroup:`n"+$comment)
$flag="관리자 그룹에 최소한의 사용자 포함:수동 점검:상"
return $flag
}
function step5{
$Global:count++; 
$bool=type $path | findstr "ClearTextPassword"
$offset=$bool -cmatch "0"
if($offset -eq $True){
    $offset="해독 가능한 암호화를 사용하여 암호 저장:양호:상"
}
else{
    $offset="해독 가능한 암호화를 사용하여 암호 저장:취약:상"
}
return $offset
}
function step4{
$Global:count++; 
$threshold=net accounts | select-string "Lockout threshold"
$index=("$threshold").split(":")[1]
$bool=$index -cmatch "Never"
$flag="계정 잠금 임계값 설정:취약:상"
if($bool -eq $True){
    $flag="계정 잠금 임계값 설정:취약:상"
}
elseif ($bool -eq $False){
    if([int]$index -le 5){
    $flag="계정 잠금 임계값 설정:양호:상"
    }
}
else { $flag="계정 잠금 임계값 설정:취약:상"}
return $flag
}
function step3{
$Global:count++;
$comment=Get-LocalUser | Select-Object -ExpandProperty name
[void] $Sheet.Range("D$Global:count").Addcomment("comment")
[void] $Sheet.Range("D$Global:count").Comment.Text("LocalUser:`n"+$comment)
$offset="불필요한 계정 제거:수동 점검:상"
return $offset
}
function step2{
$Global:count++; 
$Guest=net user Guest | select-string "Account active"
$bool=$Guest -cmatch "Yes"
$offset="Guest 계정 상태:취약:상"
if($bool -eq "True"){
    $offset="Guest 계정 상태:취약:상"
}
else{
    $offset="Guest 계정 상태:양호:상"
}
return $offset
}
function step1{
$Global:count++; 
$Default=net user | findstr "Administrator"
$bool=$Default -match "Administrator"
$offset="Administrator 계정 이름 바꾸기:취약:상"
if($bool -eq "True"){
    $offset="Administrator 계정 이름 바꾸기:취약:상"
}
else{
    $offset="Administrator 계정 이름 바꾸기:양호:상"
}
return $offset
}
function Sheet_write{
    $Global:count=4
    # 통계를 위한 변수 초기화
    $Result_A=0; $Result_Ser=0; $Result_P=0; $Result_L=0; $Result_Secu=0;
    $Self_A=0; $Self_Ser=0; $Self_P=0; $Self_L=0; $Self_Secu=0;
    $Good_A=0; $Good_Ser=0; $Good_P=0; $Good_L=0; $Good_Secu=0;
    $Weak_A=0; $Weak_Ser=0; $Weak_P=0; $Weak_L=0; $Weak_Secu=0;
    $Prog=""
    foreach($num in 1..100)
    {
        Write-Progress -Activity "Processing" -Status "$num% Complete:" -PercentComplete $num | Clear-Host

        if($num-eq100){ Write-Host "Done"}
        #When you add function
        if($num-le82)
        {
            $print="step"+"$num";
            if($print -eq "step18") { chcp 949 | Out-Null }; if($num-eq51){ chcp 65001 | Out-Null }; $print=&$print
            $Title=$print.split(":")[0]; $Result=$print.split(":")[1]; $Level=$print.split(":")[2]
            $Sheet.Range("C$Global:count").Cells=$Title
            $Sheet.Range("D$Global:count").Cells=$Result
            $Sheet.Range("E$Global:count").Cells=$Level
            
            # When you change Level Font Color
            if($Level-eq"상"){$Sheet.Range("E$Global:count").font.ColorIndex = 3}
            if($Level-eq"중"){$Sheet.Range("E$Global:count").font.ColorIndex = 5}
            if($Level-eq"하"){$Sheet.Range("E$Global:count").font.ColorIndex = 1}
            
            # When you change Result Font Color to Weak
            if($Result-eq"취약"){$Sheet.Range("D$Global:count").font.ColorIndex = 3}

            # 통계를 위한 값 추출
            if($num-le18)
            { if($Result-eq"취약") { $Weak_A++ } elseif($Result-eq"양호") { $Good_A++ } elseif($Result-eq"수동 점검") { $Self_A++ } }
            elseif($num-le54)
            { if($Result-eq"취약") { $Weak_Ser++ } elseif($Result-eq"양호") { $Good_Ser++ } elseif($Result-eq"수동 점검") { $Self_Ser++ } }
            elseif($num-le57)
            { if($Result-eq"취약") { $Weak_P++ } elseif($Result-eq"양호") { $Good_P++ } elseif($Result-eq"수동 점검") { $Self_P++ } }
            elseif($num-le61) 
            { if($Result-eq"취약") { $Weak_L++ } elseif($Result-eq"양호") { $Good_L++ } elseif($Result-eq"수동 점검") { $Self_L++ } }
            elseif($num-le82)
            { if($Result-eq"취약") { $Weak_Secu++ } elseif($Result-eq"양호") { $Good_Secu++ } elseif($Result-eq"수동 점검") { $Self_Secu++; } }
            # 취약:통계별로 계산 계정:6점 서비스:3점 패치:35점 로그:25점 보안:5점
            $Result_A=$Weak_A*6; $Result_Ser=$Weak_Ser*3; $Result_P=$Weak_P*35; $Result_L=$Weak_L*25; $Result_Secu=$Weak_Secu*5;
            CHART_Design $Weak_Secu $Good_Secu $Self_Secu $Result_Secu $Weak_L $Good_L $Self_L $Result_L $Weak_P $Good_P $Self_P $Result_P $Weak_Ser $Good_Ser $Self_Ser $Result_Ser $Weak_A $Good_A $Self_A $Result_A
        }
    }
}

function HyperLink{
    param($row,$Move_Cell)
  $Sheet.Hyperlinks.Add(`
  $Sheet.Cells.Item($row,4), ""`
 ,"Report_Result!$Move_Cell", "", "") | Out-Null
}

function Back_HyperLink{
    param($row,$col,$Move_Cell)
  $Sheet.Hyperlinks.Add(`
  $Sheet.Cells.Item($row,$col), ""`
 ,"Report_Result!$Move_Cell", "", "Back") | Out-Null
}

function Detail_Report_Deco{
        param($row,$col)
    $colorIndex = "microsoft.office.interop.excel.xlColorIndex" -as [type]
    $borderWeight = "microsoft.office.interop.excel.xlBorderWeight" -as [type]
    $Sheet.cells.item($row,$col).borders.ColorIndex = $colorIndex::xlColorIndexAutomatic
    $Sheet.cells.item($row,$col).borders.weight = $borderWeight::xlMedium
    $Sheet.Cells.Item($row,$col).Font.Size = 15
    $Sheet.Cells.Item($row,$col).Font.Bold = $True
}

function Detail_Report{
    param($step_number)
    $colorIndex = "microsoft.office.interop.excel.xlColorIndex" -as [type]; $borderWeight = "microsoft.office.interop.excel.xlBorderWeight" -as [type]
    switch($step_number)
       {
        27
         {
            $row=3; $col=15
            $Sheet.cells.item($row,$col).columnWidth=80.00;
            $Sheet.cells.item($row,$col) = "웹 서비스 구동자의 권한 SID"
            Detail_Report_Deco $row $col
            Back_HyperLink 4 $col A27

            $str=get-content $path; $x=5
            $sid=($str | findstr "SeServiceLogonRight")
            $charCount = ($sid.ToCharArray() | Where-Object {$_ -eq '*'} | Measure-Object).Count
            foreach($i in 1..$charCount)
            { ($Sheet.Cells.Item($x,$col) = $sid -replace(",","`r:") -replace("= ","`n:") | ForEach-Object{$_.split(":")[$i]}) -replace("`n",""); $x++}
            break;
         }
         54
          {
            $Sheet.range("Q3:R3").borders.ColorIndex = $colorIndex::xlColorIndexAutomatic; $Sheet.range("Q3:R3").borders.weight = $borderWeight::xlMedium
            
            $row=3; $col=17
            $Sheet.cells.item($row,$col).columnWidth=40.00;
            $Sheet.cells.item($row,$col) = "예약된 작업 내용"
            ($Sheet.Range("Q3:R3")).Merge(); $Sheet.range("Q3").HorizontalAlignment = -4108;
            Detail_Report_Deco $row $col
            Back_HyperLink 4 $col A62

            $Sheet.cells.item($row,$col+1).columnWidth=40.00;
            $Sheet.cells.item($row+2,$col) = "TaskName"; $Sheet.Cells.Item($row+2,$col).Font.Bold=$True;
            $Sheet.cells.item($row+2,$col+1) = "Next Run Time"; $Sheet.Cells.Item($row+2,$col+1).Font.Bold=$True;
            
            [string]$year=date
            $at=@()
            foreach($i in 0..1)
            { $at+=((schtasks | findstr /I /V "N/A" | findstr ($year).split("/ ")[2]) -replace("2017","/2017")) -replace("\?\?","오") | ForEach-Object{$_.split("/")[$i]} }
            [int]$middle=$at.Count/2
            $x=6;$y=6
            foreach($j in 0..$at.Count)
            {
                if($j-lt$middle)
                {$Sheet.Cells.Item($x, 17) = $at[$j]; $x++}
                if($j-ge$middle)
                {$Sheet.Cells.Item($y, 18) = $at[$j]; $y++}
            }
            break;
          }
          55
          {
            $Sheet.range("T3:V3").borders.ColorIndex = $colorIndex::xlColorIndexAutomatic; $Sheet.Range("T3:V3").borders.weight = $borderWeight::xlMedium
            ($Sheet.Range("T3:V3")).Merge(); $Sheet.Range("T3").HorizontalAlignment = -4108; $Sheet.Range("T3:V3").EntireColumn.Columnwidth = 20.00
            $row=3; $col=20
            Detail_Report_Deco $row $col
            Back_HyperLink 4 $col A62
            
            $Sheet.Cells.Item($row,$col) = "최신 Hot FIX 적용 판단"
            $Sheet.Range("T5").cells="HotFixID";  $Sheet.Range("U5").cells="Description"; $Sheet.Range("V5").cells="InstalledOn";
            $Sheet.Cells.Item($row+2,$col).Font.Bold=$True; $Sheet.Cells.Item($row+2,$col+1).Font.Bold=$True; $Sheet.Cells.Item($row+2,$col+2).Font.Bold=$True;

            $HotFix=Get-HotFix; $x=6
            Foreach($HotFix_Info in $HotFix)
            {
                $Sheet.cells.item($x,$col) = $HotFix_Info.HotfixID
                $Sheet.cells.item($x,$col+1) = $HotFix_Info.Description
                $Sheet.cells.item($x,$col+2) = $HotFix_Info.InstalledOn
                $x++
            }
            break;
          }
          81
          {
            $Sheet.range("Z3:AA3").borders.ColorIndex = $colorIndex::xlColorIndexAutomatic; $Sheet.Range("Z3:AA3").borders.weight = $borderWeight::xlMedium
            ($Sheet.Range("Z3:AA3")).Merge(); $Sheet.Range("Z3").HorizontalAlignment = -4108; $Sheet.Range("Z3").EntireColumn.Columnwidth = 68.00; $Sheet.Range("AA3").EntireColumn.Columnwidth = 30.00
            $row=3; $col=26
            Detail_Report_Deco $row $col
            Back_HyperLink 4 $col A81

            $Sheet.Cells.Item($row,$col) = "시작 프로그램 목록"
            $Sheet.Range("Z5").cells="Command";  $Sheet.Range("AA5").cells="Description";
            $Sheet.Cells.Item($row+2,$col).Font.Bold=$True; $Sheet.Cells.Item($row+2,$col+1).Font.Bold=$True;

            $startup=Get-CimInstance -ClassName Win32_startupCommand; $x=6
            Foreach($startup_Info in $startup)
            {
                $Sheet.cells.item($x,$col) = $startup_Info.Command
                $Sheet.cells.item($x,$col+1) = $startup_Info.Description
                $x++
            }
            break;
          }
        }

}

function CHART_Design{
    Param($Weak_Secu,$Good_Secu,$Self_Secu,$Result_Secu,$Weak_L,$Good_L,$Self_L,$Result_L,$Weak_P,$Good_P,$Self_P,$Result_P,$Weak_Ser,$Good_Ser,$Self_Ser,$Result_Ser,$Weak_A,$Good_A,$Self_A,$Result_A)
    $long=@($Weak_Secu,$Good_Secu,$Self_Secu,$Result_Secu,$Weak_L,$Good_L,$Self_L,$Result_L,$Weak_P,$Good_P,$Self_P,$Result_P,$Weak_Ser,$Good_Ser,$Self_Ser,$Result_Ser,$Weak_A,$Good_A,$Self_A,$Result_A)
    $Sheet.Range("L5").cells="계정관리"; $Sheet.Range("K5").cells="서비스관리"; $Sheet.Range("J5").cells="패치관리"; $Sheet.Range("I5").cells="로그관리"; $Sheet.Range("H5").cells="보안관리";
    $Sheet.Range("G6").cells="취약"; $Sheet.Range("G7").cells="양호"; $Sheet.Range("G8").cells="수동점검"; $Sheet.Range("G9").cells="결과";
    $i=0
    foreach($col in 8..12)
    {
        foreach($row in 6..9)
        {
            $Sheet.Cells.Item($row,$col)=$long[$i]
            $i++;
        }
    }
}

function INITIAL{
    $row=4;
    #If you wanna Sell size to Auto
    #$usedRange = $Sheet.UsedRange             
    #$usedRange.EntireColumn.AutoFit() | Out-Null;

    #When you change Text Sort 
    foreach($i in 4..86){ $Sheet.range("C4,D$i,E$i").HorizontalAlignment = -4108; }
    $Sheet.range("A4").cells="분류"; $Sheet.Range("B4").cells="항목코드"; $Sheet.Range("C4").cells="점검 항목"; $Sheet.Range("D4").cells="결과"; $Sheet.Range("E4").cells="위험도"
    #When you change Cell Color And Font Bold
    foreach($col in 1..5){$Sheet.Cells.Item($row,$col).Font.Bold=$True; $Sheet.Cells.Item($row,$col).Interior.ColorIndex=48}
    #Cell Merge
    ($Sheet.Range("A5:A22,A23:A58,A59:A61,A62:A65,A66:A86")).Merge()
    #Change Cell Size
    $Sheet.Range("A1").columnWidth=13.25; $Sheet.Range("B1").columnWidth=8.75; $Sheet.Range("C1").ColumnWidth=48; $Sheet.Range("E1").ColumnWidth=6.88
    $Sheet.range("A5").cells="1. 계정 관리";  $Sheet.range("A23").cells="2. 서비스 관리"; $Sheet.Range("A59").cells="3. 패치 관리";
    $Sheet.Range("A62").cells="4. 로그 관리"; $Sheet.Range("A66").cells="5. 보안 관리"
    $Sheet.range("A5,A23,A59,A62,A66").Font.Bold=$True
    #When you wanna add cell
    foreach($i in 5..86)
    {
    $j=$i-4
    $Sheet.range("B$i").cells="W-$j"
    }
    $dataRange=$Sheet.Range(("A{0}"  -f 4),("E{0}"  -f 86))
7..12 | ForEach {
    $dataRange.Borders.Item($_).LineStyle = 1
    $dataRange.Borders.Item($_).Weight = 2
    }
}
function TITLE{
$info=get-date
$row = 1; $Column = 1
$Sheet.Cells.Item($row,$column)= "취약점 분석 보고서 ($info)"
$Sheet.Cells.Item($row,$column).Font.Size = 18
$Sheet.Cells.Item($row,$column).Font.Bold = $True
$Sheet.Cells.Item($row,$column).Font.ThemeFont = 1
$Sheet.Cells.Item($row,$column).Font.ThemeColor = 4
$Sheet.Cells.Item($row,$column).Font.ColorIndex = 55
$Sheet.Cells.Item($row,$column).Font.Color = 8210719
}
function Make_Chart{
    param($fileName)
$xlChart=[Microsoft.Office.Interop.Excel.XLChartType]

$xl = new-object -ComObject Excel.Application   
$wb = $xl.Workbooks.Open($fileName) 
$wsData = $wb.WorkSheets.item(1) 

#Activating the Data sheet
$wsData.activate() 

#Selecting the source data - We cn select the first cell with Range and select CurrentRegion which selects theenire table
$DataforFirstChart = $wsData.Range("G5").CurrentRegion

#Adding the Charts
$firstChart = $wsData.Shapes.AddChart().Chart

# Providing the chart types
$firstChart.ChartType = $xlChart::xlBarClustered

#Providing the source data
$firstChart.SetSourceData($DataforFirstChart)

# Set y row in Chart
#xlValue	2	Axis displays values.
$firstChart.Axes(2).MaximumScale=100

# Set it true if want to have chart Title
$firstChart.HasTitle = $true

# Providing the Title for the chart
$firstChart.ChartTitle.Text = "Windows 취약점 분석 통계"

# Setting up the position of chart (Not required if the sheet has just one chart). It will create the chart at top left corner
$wsData.shapes.item("Chart 1").top = 70
$wsData.shapes.item("Chart 1").left = 580

# Saving the sheet
$wb.Save();

# Closing the work book and xl
$wb.close() 
$xl.Quit()
# Releasting the com object
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($xl) | Out-Null
}
# Create Excel object
$excel = new-object -comobject Excel.Application

# Make Excel visible
#$excel.visible = $false
$excel.DisplayAlerts = $false
 
# Create a new workbook
$workbook = $excel.workbooks.add()
 
# Get sheet and update sheet name
$Sheet = $workbook.sheets | where {$_.name -eq 'Sheet1'}
$Sheet.name = "Report_Result"

# Update workbook properties
$workbook.author = "Jang.Hyeok:ysa7293@naver.com"
$workbook.title = "취약점 보고서"
$workbook.subject = "Windows 취약점 분석 보고서"
 
# Decorate Function
INITIAL 
TITLE
# Effective Function
Sheet_write
# And save it away:
$Report="C:\Report.xlsx"
if(Test-Path $Report)
{
    Remove-Item $Report
    $Sheet.saveas($Report)
    $workbook.Close()
    $excel.Quit()
}
else
{
    $Sheet.saveas($Report)
    $workbook.Close()
    $excel.Quit()
}
# Releasting the com object
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null

Make_Chart $Report