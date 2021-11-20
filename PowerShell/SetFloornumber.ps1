Install-Module -Name ExchangeOnlineManagement
Import-Module ExchangeOnlineManagement


Connect-ExchangeOnline -UserPrincipalName admin@contoso.com

# https://docs.microsoft.com/ja-jp/powershell/module/exchange/get-mailbox
#     $mailboxes = Get-Mailbox | Where-Object {($_.RecipientTypeDetails -eq "RoomMailbox") -or ($_.RecipientTypeDetails -eq "EquipmentMailbox")}
$mailboxes = Get-Mailbox | Where-Object {$_.RecipientTypeDetails -eq "RoomMailbox"}
$rooms = $mailboxes | ForEach-Object{Get-Place -Identity $_.PrimarySmtpAddress}
$rooms | Select-Object Identity,DisplayName,Floor,FloorLabel | Sort-Object PrimarySmtpAddress | Format-List



# https://docs.microsoft.com/ja-jp/powershell/module/exchange/set-place
#     Set-Place -Identity room0201@contoso.com -Floor 2 -FloorLabel "2F" -Label 0201
$mailboxes = Get-Mailbox | Where-Object {$_.RecipientTypeDetails -eq "RoomMailbox"}

$mailboxes | Where-Object {$_.PrimarySmtpAddress.StartsWith("room02") } | ForEach-Object{Write-Host $_.PrimarySmtpAddress}
$mailboxes | Where-Object {$_.PrimarySmtpAddress.StartsWith("room02") } | ForEach-Object{Set-Place -Identity $_.PrimarySmtpAddress -Floor 2 -FloorLabel "2F"}

$mailboxes | Where-Object {$_.PrimarySmtpAddress.StartsWith("room12") } | ForEach-Object{Write-Host $_.PrimarySmtpAddress}
$mailboxes | Where-Object {$_.PrimarySmtpAddress.StartsWith("room12") } | ForEach-Object{Set-Place -Identity $_.PrimarySmtpAddress -Floor 12 -FloorLabel "12F"}



# https://docs.microsoft.com/ja-jp/powershell/module/exchange/new-distributiongroup
$groupName = '全会議室'
$groupAlias = 'AllRooms'
New-DistributionGroup -Name $groupName -Alias $groupAlias -RoomList
Get-DistributionGroup | Select-Object DisplayName,PrimarySmtpAddress | Sort-Object PrimarySmtpAddress | Format-List

$mailboxes | ForEach-Object{ Add-DistributionGroupMember $groupAlias -Member $_.PrimarySmtpAddress }

Get-DistributionGroupMember $groupAlias
