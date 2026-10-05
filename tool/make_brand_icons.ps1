# Draws the مُجتمعي icons (gold roof over three neighbours on the night
# tile — same mark as MogtamayLogo in lib/core/theme/app_logo.dart) into
# web/favicon.png and web/icons/.
#   powershell -File tool/make_brand_icons.ps1
Add-Type -AssemblyName System.Drawing
$web = Join-Path $PSScriptRoot '..\web'

function RoundRect([float]$x, [float]$y, [float]$w, [float]$h, [float]$r) {
  $p = New-Object System.Drawing.Drawing2D.GraphicsPath
  $d = 2 * $r
  $p.AddArc($x, $y, $d, $d, 180, 90); $p.AddArc($x + $w - $d, $y, $d, $d, 270, 90)
  $p.AddArc($x + $w - $d, $y + $h - $d, $d, $d, 0, 90); $p.AddArc($x, $y + $h - $d, $d, $d, 90, 90)
  $p.CloseFigure(); return $p
}

function Draw([int]$size, [string]$path, [bool]$maskable) {
  $bmp = New-Object System.Drawing.Bitmap $size, $size
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = 'AntiAlias'
  $g.Clear([System.Drawing.Color]::Transparent)
  $Full = [float]$size
  $bg = New-Object System.Drawing.Drawing2D.LinearGradientBrush ((New-Object System.Drawing.PointF 0, 0), (New-Object System.Drawing.PointF $Full, $Full),
    [System.Drawing.Color]::FromArgb(255, 0x24, 0x3F, 0x7A), [System.Drawing.Color]::FromArgb(255, 0x0B, 0x15, 0x30))
  if ($maskable) { $g.FillRectangle($bg, 0, 0, $Full, $Full) } else { $g.FillPath($bg, (RoundRect 0 0 $Full $Full ($Full * 0.26))) }

  # The mark is laid out on a 200-unit square; maskable icons shrink it into the safe zone.
  $k = if ($maskable) { 0.78 } else { 1.0 }
  $s = $Full / 200 * $k
  $o = ($Full - 200 * $s) / 2
  function P([float]$v) { return $o + $v * $s }

  $gold = New-Object System.Drawing.Drawing2D.LinearGradientBrush ((New-Object System.Drawing.PointF 0, (P 40)), (New-Object System.Drawing.PointF 0, (P 160)),
    [System.Drawing.Color]::FromArgb(255, 0xF8, 0xCB, 0x7E), [System.Drawing.Color]::FromArgb(255, 0xE8, 0xA2, 0x45))
  $pen = New-Object System.Drawing.Pen $gold, (13 * $s)
  $pen.StartCap = 'Round'; $pen.EndCap = 'Round'; $pen.LineJoin = 'Round'
  $roof = [System.Drawing.PointF[]]@((New-Object System.Drawing.PointF (P 42), (P 96)), (New-Object System.Drawing.PointF (P 100), (P 46)), (New-Object System.Drawing.PointF (P 158), (P 96)))
  $g.DrawLines($pen, $roof)

  $white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(224, 255, 255, 255))
  function Person([float]$cx, [float]$hy, [float]$r, $brush) {
    $g.FillEllipse($brush, (P ($cx - $r)), (P ($hy - $r)), (2 * $r * $s), (2 * $r * $s))
    $top = $hy + $r + 5; $w = $r * 3.6
    $g.FillPie($brush, (P ($cx - $w / 2)), (P $top), ($w * $s), ($r * 3.4 * $s), 180, 180)
  }
  Person 66 118 10.5 $white
  Person 134 118 10.5 $white
  Person 100 108 13.5 $gold

  $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $bmp.Dispose()
}

Draw 64 (Join-Path $web 'favicon.png') $false
Draw 192 (Join-Path $web 'icons\Icon-192.png') $false
Draw 512 (Join-Path $web 'icons\Icon-512.png') $false
Draw 192 (Join-Path $web 'icons\Icon-maskable-192.png') $true
Draw 512 (Join-Path $web 'icons\Icon-maskable-512.png') $true
'done'
