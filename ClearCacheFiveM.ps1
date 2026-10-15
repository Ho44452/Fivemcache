# FiveM + Windows Cleanup Tool (Red Theme)
# Save as ClearCacheFiveM.ps1 and run with PowerShell.
# Close FiveM before cleaning its cache. ไฟล์ชั่วคราว Windows cleanup may require "Run as administrator".

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$script:Red = [System.Drawing.Color]::FromArgb(220, 38, 38)
$script:Dark = [System.Drawing.Color]::FromArgb(24, 24, 27)
$script:Panel = [System.Drawing.Color]::FromArgb(39, 39, 42)
$script:Text = [System.Drawing.Color]::FromArgb(244, 244, 245)
$script:Muted = [System.Drawing.Color]::FromArgb(161, 161, 170)

$form = New-Object System.Windows.Forms.Form
$form.Text = "RED CLEANER | FiveM + Windows"
$form.Size = New-Object System.Drawing.Size(760, 650)
$form.MinimumSize = New-Object System.Drawing.Size(760, 650)
$form.StartPosition = "CenterScreen"
$form.BackColor = $script:Dark
$form.ForeColor = $script:Text
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false

$header = New-Object System.Windows.Forms.Panel
$header.Location = New-Object System.Drawing.Point(0, 0)
$header.Size = New-Object System.Drawing.Size(760, 105)
$header.BackColor = $script:Red
$form.Controls.Add($header)

$title = New-Object System.Windows.Forms.Label
$title.Text = "RED CLEANER"
$title.Font = New-Object System.Drawing.Font("Segoe UI", 23, [System.Drawing.FontStyle]::Bold)
$title.ForeColor = [System.Drawing.Color]::White
$title.Location = New-Object System.Drawing.Point(24, 14)
$title.AutoSize = $true
$header.Controls.Add($title)

$subtitle = New-Object System.Windows.Forms.Label
$subtitle.Text = "ล้างแคช FiveM และไฟล์ชั่วคราว Windows"
$subtitle.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$subtitle.ForeColor = [System.Drawing.Color]::White
$subtitle.Location = New-Object System.Drawing.Point(28, 61)
$subtitle.AutoSize = $true
$header.Controls.Add($subtitle)

$info = New-Object System.Windows.Forms.Label
$info.Text = "คำแนะนำ: ปิด FiveM ก่อนล้างแคช ไฟล์แคชจะถูกสร้างใหม่เมื่อเปิดเกม"
$info.Location = New-Object System.Drawing.Point(24, 120)
$info.Size = New-Object System.Drawing.Size(700, 34)
$info.ForeColor = $script:Muted
$form.Controls.Add($info)

$group = New-Object System.Windows.Forms.GroupBox
$group.Text = "เลือกสิ่งที่ต้องการล้าง"
$group.Location = New-Object System.Drawing.Point(24, 160)
$group.Size = New-Object System.Drawing.Size(700, 195)
$group.ForeColor = $script:Text
$group.BackColor = $script:Dark
$form.Controls.Add($group)

function Add-CleanCheckBox($text, $y, $checked) {
    $cb = New-Object System.Windows.Forms.CheckBox
    $cb.Text = $text
    $cb.Location = New-Object System.Drawing.Point(20, $y)
    $cb.Size = New-Object System.Drawing.Size(650, 28)
    $cb.Checked = $checked
    $cb.ForeColor = $script:Text
    $cb.BackColor = $script:Dark
    $cb
}

$cbFiveM = Add-CleanCheckBox "แคช FiveM (cache, server-cache, server-cache-priv, nui-storage)" 30 $true
$cbUserTemp = Add-CleanCheckBox "ไฟล์ชั่วคราวผู้ใช้ปัจจุบัน (%TEMP%)" 65 $true
$cbWindowsTemp = Add-CleanCheckBox "ไฟล์ชั่วคราว Windows (อาจต้องใช้สิทธิ์ผู้ดูแลระบบ)" 100 $false
$cbShader = Add-CleanCheckBox "แคช DirectX Shader (ระบบอาจสร้างใหม่หลังล้าง)" 135 $false
$group.Controls.AddRange(@($cbFiveM, $cbUserTemp, $cbWindowsTemp, $cbShader))

$cleanBtn = New-Object System.Windows.Forms.Button
$cleanBtn.Text = "ล้างรายการที่เลือก"
$cleanBtn.Location = New-Object System.Drawing.Point(24, 370)
$cleanBtn.Size = New-Object System.Drawing.Size(220, 48)
$cleanBtn.FlatStyle = "Flat"
$cleanBtn.FlatAppearance.BorderSize = 0
$cleanBtn.BackColor = $script:Red
$cleanBtn.ForeColor = [System.Drawing.Color]::White
$cleanBtn.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($cleanBtn)

$selectBtn = New-Object System.Windows.Forms.Button
$selectBtn.Text = "เลือกทั้งหมด"
$selectBtn.Location = New-Object System.Drawing.Point(255, 370)
$selectBtn.Size = New-Object System.Drawing.Size(135, 48)
$selectBtn.FlatStyle = "Flat"
$selectBtn.FlatAppearance.BorderColor = $script:Red
$selectBtn.BackColor = $script:Panel
$selectBtn.ForeColor = $script:Text
$form.Controls.Add($selectBtn)

$logTitle = New-Object System.Windows.Forms.Label
$logTitle.Text = "บันทึกการทำงาน"
$logTitle.Location = New-Object System.Drawing.Point(24, 435)
$logTitle.Size = New-Object System.Drawing.Size(200, 24)
$logTitle.ForeColor = $script:Red
$logTitle.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($logTitle)

$log = New-Object System.Windows.Forms.TextBox
$log.Location = New-Object System.Drawing.Point(24, 462)
$log.Size = New-Object System.Drawing.Size(700, 120)
$log.Multiline = $true
$log.ReadOnly = $true
$log.ScrollBars = "Vertical"
$log.BackColor = [System.Drawing.Color]::FromArgb(9, 9, 11)
$log.ForeColor = [System.Drawing.Color]::FromArgb(212, 212, 216)
$log.BorderStyle = "FixedSingle"
$log.Font = New-Object System.Drawing.Font("Consolas", 9)
$form.Controls.Add($log)

$status = New-Object System.Windows.Forms.Label
$status.Text = "พร้อมใช้งาน"
$status.Location = New-Object System.Drawing.Point(24, 586)
$status.Size = New-Object System.Drawing.Size(470, 24)
$status.ForeColor = $script:Muted
$form.Controls.Add($status)

$credit = New-Object System.Windows.Forms.Label
$credit.Text = "Credit by Mheedbt"
$credit.Location = New-Object System.Drawing.Point(520, 586)
$credit.Size = New-Object System.Drawing.Size(204, 24)
$credit.ForeColor = $script:Red
$credit.TextAlign = [System.Drawing.ContentAlignment]::MiddleRight
$credit.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($credit)

function Write-Log([string]$message) {
    $log.AppendText("[$(Get-Date -Format 'HH:mm:ss')] $message`r`n")
    $log.SelectionStart = $log.TextLength
    $log.ScrollToCaret()
    [System.Windows.Forms.Application]::DoEvents()
}

function Remove-FolderContents([string]$path, [string]$label) {
    if (-not (Test-Path -LiteralPath $path)) {
        Write-Log "$label - ไม่พบโฟลเดอร์ ข้ามรายการ"
        return
    }
    $removed = 0
    $failed = 0
    try {
        Get-ChildItem -LiteralPath $path -Force -ErrorAction SilentlyContinue | ForEach-Object {
            try {
                Remove-Item -LiteralPath $_.FullName -Recurse -Force -ErrorAction Stop
                $removed++
            } catch {
                $failed++
            }
        }
        Write-Log "$label - ลบได้ $removed รายการ; ข้าม/ถูกล็อก $failed รายการ"
    } catch {
        Write-Log "$label - เกิดข้อผิดพลาด: $($_.Exception.Message)"
    }
}

$selectBtn.Add_Click({
    $allChecked = $cbFiveM.Checked -and $cbUserTemp.Checked -and $cbWindowsTemp.Checked -and $cbShader.Checked
    $cbFiveM.Checked = -not $allChecked
    $cbUserTemp.Checked = -not $allChecked
    $cbWindowsTemp.Checked = -not $allChecked
    $cbShader.Checked = -not $allChecked
    $selectBtn.Text = if ($allChecked) { "เลือกทั้งหมด" } else { "DEเลือกทั้งหมด" }
})

$cleanBtn.Add_Click({
    if (-not ($cbFiveM.Checked -or $cbUserTemp.Checked -or $cbWindowsTemp.Checked -or $cbShader.Checked)) {
        [System.Windows.Forms.MessageBox]::Show("กรุณาเลือกอย่างน้อย 1 รายการที่ต้องการล้าง", "ยังไม่ได้เลือกรายการ", "OK", "Information") | Out-Null
        return
    }

    $confirm = [System.Windows.Forms.MessageBox]::Show(
        "ต้องการล้างแคชและไฟล์ชั่วคราวที่เลือกหรือไม่? ไฟล์ที่กำลังใช้งานอาจถูกข้าม กรุณาปิด FiveM ก่อน",
        "ยืนยันการล้างไฟล์", "YesNo", "Warning"
    )
    if ($confirm -ne [System.Windows.Forms.DialogResult]::Yes) { return }

    $cleanBtn.Enabled = $false
    $status.Text = "กำลังล้างไฟล์..."
    Write-Log "เริ่มล้างไฟล์"

    if ($cbFiveM.Checked) {
        $fivemData = Join-Path $env:LOCALAPPDATA "FiveM\FiveM.app\data"
        foreach ($name in @("cache", "server-cache", "server-cache-priv", "nui-storage")) {
            Remove-FolderContents (Join-Path $fivemData $name) "FiveM $name"
        }
    }

    if ($cbUserTemp.Checked) {
        Remove-FolderContents $env:TEMP "ไฟล์ชั่วคราวผู้ใช้"
    }

    if ($cbWindowsTemp.Checked) {
        Remove-FolderContents (Join-Path $env:WINDIR "Temp") "ไฟล์ชั่วคราว Windows"
    }

    if ($cbShader.Checked) {
        # Windows-managed DirectX shader cache; if unavailable, it is simply skipped.
        $shaderPaths = @(
            (Join-Path $env:LOCALAPPDATA "D3DSCache"),
            (Join-Path $env:LOCALAPPDATA "Microsoft\Windows\INetCache")
        )
        foreach ($path in $shaderPaths) {
            Remove-FolderContents $path "แคช Shader/ไฟล์ชั่วคราว"
        }
    }

    Write-Log "ล้างไฟล์เสร็จแล้ว อาจมีไฟล์ที่ถูกล็อกหรือไม่มีสิทธิ์เข้าถึงเหลืออยู่"
    $status.Text = "เสร็จแล้ว ลบไฟล์ชั่วคราวเท่าที่ระบบอนุญาต"
    $cleanBtn.Enabled = $true
    [System.Windows.Forms.MessageBox]::Show(
        "ล้างไฟล์เสร็จแล้ว`r`n`r`nไฟล์บางส่วนอาจยังอยู่ หากกำลังใช้งานหรือต้องใช้สิทธิ์ผู้ดูแลระบบ",
        "RED CLEANER", "OK", "Information"
    ) | Out-Null
})

Write-Log "พร้อมใช้งาน Choose cleanup options and click ล้างรายการที่เลือก."
[void]$form.ShowDialog()
