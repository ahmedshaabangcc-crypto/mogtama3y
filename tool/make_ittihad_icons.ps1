# Draws the "اتحاد الملاك" (owners' union) icons: a gold apartment building
# with lit windows on the night gradient used across the app — so the union
# app no longer installs with the same icon as مُجتمعي. Output:
# web/ittihad_icons/ — the deploy workflow copies them over the default icons
# in the ittihad build (like web/tajer_icons for متجري).
#   powershell -File tool/make_ittihad_icons.ps1
Add-Type -AssemblyName System.Drawing
$out = Join-Path $PSScriptRoot '..\web\ittihad_icons'
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

  # Building: smaller inside the maskable safe zone.
  $k = if ($maskable) { 0.46 } else { 0.56 }
  $bw = $s * $k; $bh = $bw * 1.18
  $bx = ($s - $bw) / 2; $by = ($s - $bh) / 2 + $bh * 0.02
  $gold = New-Object System.Drawing.Drawing2D.LinearGradientBrush ((New-Object System.Drawing.PointF 0, $by), (New-Object System.Drawing.PointF 0, ($by + $bh)),
    [System.Drawing.Color]::FromArgb(255, 0xF8, 0xCB, 0x7E), [System.Drawing.Color]::FromArgb(255, 0xE8, 0xA2, 0x45))
  $g.FillPath($gold, (RoundRect $bx $by $bw $bh ($bw * 0.10)))

  # Windows: 3 floors x 3, one dark (a "neighbourhood at night" feel).
  $night = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 0x0B, 0x15, 0x30))
  $lit = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 0xFF, 0xF4, 0xDC))
  $ww = $bw * 0.17; $wh = $bh * 0.13
  $gapX = ($bw - 3 * $ww) / 4; $top = $by + $bh * 0.12; $gapY = $bh * 0.07
  for ($r = 0; $r -lt 3; $r++) {
    for ($c = 0; $c -lt 3; $c++) {
      $x = $bx + $gapX + $c * ($ww + $gapX); $y = $top + $r * ($wh + $gapY)
      $brush = if (($r -eq 1 -and $c -eq 0) -or ($r -eq 2 -and $c -eq 2)) { $lit } else { $night }
      $g.FillPath($brush, (RoundRect $x $y $ww $wh ($ww * 0.18)))
    }
  }
  # Door
  $dw = $bw * 0.24; $dh = $bh * 0.20
  $g.FillPath($night, (RoundRect ($bx + ($bw - $dw) / 2) ($by + $bh - $dh) $dw $dh ($dw * 0.30)))

  $bmp.Save((Join-Path $out $name), [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $bmp.Dispose()
}

Draw 64 'favicon.png' $false
Draw 192 'Icon-192.png' $false
Draw 512 'Icon-512.png' $false
Draw 192 'Icon-maskable-192.png' $true
Draw 512 'Icon-maskable-512.png' $true
Get-ChildItem $out | Select-Object -ExpandProperty Name
