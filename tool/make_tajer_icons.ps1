# Draws the "متجري" (merchant app) icons: a gold shopping bag on the night
# gradient used across the app. Output: web/tajer_icons/ — the deploy workflow
# copies them over the default icons in the tajer build.
#   powershell -File tool/make_tajer_icons.ps1
Add-Type -AssemblyName System.Drawing
$out = Join-Path $PSScriptRoot '..\web\tajer_icons'
New-Item -ItemType Directory -Force $out | Out-Null

function RoundRect([float]$x, [float]$y, [float]$w, [float]$h, [float]$r) {
  $p = New-Object System.Drawing.Drawing2D.GraphicsPath
  $d = 2 * $r
  $p.AddArc($x, $y, $d, $d, 180, 90); $p.AddArc($x + $w - $d, $y, $d, $d, 270, 90)
  $p.AddArc($x + $w - $d, $y + $h - $d, $d, $d, 0, 90); $p.AddArc($x, $y + $h - $d, $d, $d, 90, 90)
  $p.CloseFigure(); return $p
}

function Draw([int]$size, [string]$name, [bool]$maskable) {
  $bmp = New-Object System.Drawing.Bitmap $size, $size
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = 'AntiAlias'
  $g.Clear([System.Drawing.Color]::Transparent)
  $s = [float]$size
  $bg = New-Object System.Drawing.Drawing2D.LinearGradientBrush ((New-Object System.Drawing.PointF 0, 0), (New-Object System.Drawing.PointF $s, $s),
    [System.Drawing.Color]::FromArgb(255, 0x1E, 0x33, 0x66), [System.Drawing.Color]::FromArgb(255, 0x0B, 0x15, 0x30))
  if ($maskable) { $g.FillRectangle($bg, 0, 0, $s, $s) } else { $g.FillPath($bg, (RoundRect 0 0 $s $s ($s * 0.22))) }

  # Bag: smaller inside the maskable safe zone.
  $k = if ($maskable) { 0.50 } else { 0.62 }
  $bw = $s * $k; $bh = $bw * 0.86
  $bx = ($s - $bw) / 2; $by = ($s - $bh) / 2 + $bh * 0.12
  $gold = New-Object System.Drawing.Drawing2D.LinearGradientBrush ((New-Object System.Drawing.PointF 0, $by), (New-Object System.Drawing.PointF 0, ($by + $bh)),
    [System.Drawing.Color]::FromArgb(255, 0xF8, 0xCB, 0x7E), [System.Drawing.Color]::FromArgb(255, 0xE8, 0xA2, 0x45))
  # Handle
  $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 0xF2, 0xB6, 0x61)), ($bw * 0.085)
  $pen.StartCap = 'Round'; $pen.EndCap = 'Round'
  $hw = $bw * 0.46; $hh = $bh * 0.62
  $g.DrawArc($pen, ($s - $hw) / 2, $by - $hh / 2, $hw, $hh, 180, 180)
  # Body
  $g.FillPath($gold, (RoundRect $bx $by $bw $bh ($bw * 0.14)))
  # Smile (a happy shop)
  $pen2 = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 0x0B, 0x15, 0x30)), ($bw * 0.07)
  $pen2.StartCap = 'Round'; $pen2.EndCap = 'Round'
  $sw = $bw * 0.42
  $g.DrawArc($pen2, ($s - $sw) / 2, $by + $bh * 0.22, $sw, $bh * 0.42, 20, 140)

  $bmp.Save((Join-Path $out $name), [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $bmp.Dispose()
}

Draw 64 'favicon.png' $false
Draw 192 'Icon-192.png' $false
Draw 512 'Icon-512.png' $false
Draw 192 'Icon-maskable-192.png' $true
Draw 512 'Icon-maskable-512.png' $true
Get-ChildItem $out | Select-Object -ExpandProperty Name
