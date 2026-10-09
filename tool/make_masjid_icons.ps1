# Draws the «مسجدي» (masjid) icons: a gold dome and minaret with a crescent
# on the night gradient used across the app — same style as the union
# (gold building) and متجري (gold bag) icons. Output: web/masjid_icons/ —
# the deploy workflow copies them over the default icons in the masjid
# build (like web/ittihad_icons for the union app).
#   powershell -File tool/make_masjid_icons.ps1
Add-Type -AssemblyName System.Drawing
$out = Join-Path $PSScriptRoot '..\web\masjid_icons'
New-Item -ItemType Directory -Force $out | Out-Null

function RoundRect([float]$x, [float]$y, [float]$w, [float]$h, [float]$r) {
  $p = New-Object System.Drawing.Drawing2D.GraphicsPath
  $d = 2 * $r
  $p.AddArc($x, $y, $d, $d, 180, 90); $p.AddArc($x + $w - $d, $y, $d, $d, 270, 90)
  $p.AddArc($x + $w - $d, $y + $h - $d, $d, $d, 0, 90); $p.AddArc($x, $y + $h - $d, $d, $d, 90, 90)
  $p.CloseFigure(); return $p
}

function Crescent($g, $brush, $bgBrush, [float]$cx, [float]$cy, [float]$r) {
  $g.FillEllipse($brush, $cx - $r, $cy - $r, 2 * $r, 2 * $r)
  $g.FillEllipse($bgBrush, $cx - $r * 0.45, $cy - $r * 1.05, 2 * $r * 0.95, 2 * $r * 0.95)
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

  # Everything sits in a box of side $k*$s, centred (smaller for maskable).
  $k = if ($maskable) { 0.50 } else { 0.62 }
  $u = $s * $k
  $ox = ($s - $u) / 2; $oy = ($s - $u) / 2
  $gold = New-Object System.Drawing.Drawing2D.LinearGradientBrush ((New-Object System.Drawing.PointF 0, $oy), (New-Object System.Drawing.PointF 0, ($oy + $u)),
    [System.Drawing.Color]::FromArgb(255, 0xF8, 0xCB, 0x7E), [System.Drawing.Color]::FromArgb(255, 0xE8, 0xA2, 0x45))
  $night = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 0x0B, 0x15, 0x30))
  $lit = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 0xFF, 0xF4, 0xDC))

  # Prayer hall (base) across the bottom.
  $baseX = $ox + $u * 0.06; $baseW = $u * 0.70; $baseY = $oy + $u * 0.62; $baseH = $u * 0.38
  $g.FillPath($gold, (RoundRect $baseX $baseY $baseW $baseH ($u * 0.04)))

  # Dome: a half-ellipse on a short drum, with a finial and crescent.
  $domeW = $u * 0.56; $domeX = $baseX + ($baseW - $domeW) / 2
  $drumY = $baseY - $u * 0.06
  $g.FillRectangle($gold, $domeX + $u * 0.02, $drumY, $domeW - $u * 0.04, $u * 0.08)
  $dome = New-Object System.Drawing.Drawing2D.GraphicsPath
  $dome.AddArc($domeX, $drumY - $domeW * 0.62, $domeW, $domeW * 1.24, 180, 180)
  $dome.CloseFigure()
  $g.FillPath($gold, $dome)
  $cx = $domeX + $domeW / 2
  $topY = $drumY - $domeW * 0.62
  $g.FillRectangle($gold, $cx - $u * 0.012, $topY - $u * 0.08, $u * 0.024, $u * 0.09)
  Crescent $g $gold $bg $cx ($topY - $u * 0.12) ($u * 0.05)

  # Minaret on the right: tall shaft, balcony, small cap.
  $mw = $u * 0.13; $mx = $ox + $u * 0.82; $my = $oy + $u * 0.14
  $g.FillRectangle($gold, $mx, $my + $u * 0.10, $mw, ($oy + $u) - ($my + $u * 0.10))
  $g.FillRectangle($gold, $mx - $u * 0.025, $my + $u * 0.30, $mw + $u * 0.05, $u * 0.04)
  $cap = New-Object System.Drawing.Drawing2D.GraphicsPath
  $cap.AddPolygon(@((New-Object System.Drawing.PointF ($mx - $u * 0.01), ($my + $u * 0.11)), (New-Object System.Drawing.PointF ($mx + $mw / 2), $my), (New-Object System.Drawing.PointF ($mx + $mw + $u * 0.01), ($my + $u * 0.11))))
  $g.FillPath($gold, $cap)
  # Minaret window
  $g.FillPath($lit, (RoundRect ($mx + $mw * 0.3) ($my + $u * 0.42) ($mw * 0.4) ($u * 0.08) ($mw * 0.18)))

  # Arched door and two lit windows in the hall.
  $dw = $baseW * 0.22; $dh = $baseH * 0.62
  $door = New-Object System.Drawing.Drawing2D.GraphicsPath
  $dx = $baseX + ($baseW - $dw) / 2; $dy = $baseY + $baseH - $dh
  $door.AddArc($dx, $dy, $dw, $dw, 180, 180)
  $door.AddLine($dx + $dw, $dy + $dw / 2, $dx + $dw, $dy + $dh)
  $door.AddLine($dx + $dw, $dy + $dh, $dx, $dy + $dh)
  $door.CloseFigure()
  $g.FillPath($night, $door)
  $ww = $baseW * 0.11; $wh = $baseH * 0.32
  foreach ($wx in @(($baseX + $baseW * 0.12), ($baseX + $baseW * 0.77))) {
    $win = New-Object System.Drawing.Drawing2D.GraphicsPath
    $wy = $baseY + $baseH * 0.28
    $win.AddArc($wx, $wy, $ww, $ww, 180, 180)
    $win.AddLine($wx + $ww, $wy + $ww / 2, $wx + $ww, $wy + $wh)
    $win.AddLine($wx + $ww, $wy + $wh, $wx, $wy + $wh)
    $win.CloseFigure()
    $g.FillPath($lit, $win)
  }

  $bmp.Save((Join-Path $out $name), [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $bmp.Dispose()
}

Draw 64 'favicon.png' $false
Draw 192 'Icon-192.png' $false
Draw 512 'Icon-512.png' $false
Draw 192 'Icon-maskable-192.png' $true
Draw 512 'Icon-maskable-512.png' $true
Get-ChildItem $out | Select-Object -ExpandProperty Name
