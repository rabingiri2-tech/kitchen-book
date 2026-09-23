param([string]$Repo)
# Kitchen Book logo: an open book with a spoon standing above the spine,
# cream on aubergine. Drawn on a 130-unit grid (the option-B sketch), then
# rendered at every size the web app and the Android app need.
Add-Type -AssemblyName System.Drawing
$out = Join-Path $Repo "android-res"
$brand = [System.Drawing.ColorTranslator]::FromHtml("#6E2E58")
$cream = [System.Drawing.ColorTranslator]::FromHtml("#FBFCFA")
$rows = @(@("mdpi",48,108), @("hdpi",72,162), @("xhdpi",96,216), @("xxhdpi",144,324), @("xxxhdpi",192,432))

function Add-Page($path, $u, $off, $outerX){
  # a page: top edge curves up into the spine, bottom edge curves in to it
  # quadratic curves converted to cubic: c1 = p0 + 2/3(c - p0), c2 = p2 + 2/3(c - p2)
  $P = { param($x, $y) New-Object System.Drawing.PointF([single]($off + $x*$u), [single]($off + $y*$u)) }
  $sx = 65
  $path.StartFigure()
  $path.AddBezier((& $P $outerX 60), (& $P ($outerX + 2/3*($sx-$outerX)) (60 + 2/3*(48-60))), (& $P $sx (62 + 2/3*(48-62))), (& $P $sx 62))
  $path.AddLine((& $P $sx 62), (& $P $sx 104))
  $path.AddBezier((& $P $sx 104), (& $P $sx (104 + 2/3*(92-104))), (& $P ($outerX + 2/3*($sx-$outerX)) (104 + 2/3*(92-104))), (& $P $outerX 104))
  $path.CloseFigure()
}

function Draw-Icon($size, $scale, $withBg, $round){
  $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $g.Clear([System.Drawing.Color]::Transparent)
  $bgBrush = New-Object System.Drawing.SolidBrush($brand)
  if($withBg){
    if($round){ $g.FillEllipse($bgBrush, 0, 0, $size, $size) } else { $g.FillRectangle($bgBrush, 0, 0, $size, $size) }
  }
  $u = $size / 130.0 * $scale
  $off = ($size - 130.0 * $u) / 2
  $cb = New-Object System.Drawing.SolidBrush($cream)

  $pages = New-Object System.Drawing.Drawing2D.GraphicsPath
  Add-Page $pages $u $off 23
  Add-Page $pages $u $off 107
  $g.FillPath($cb, $pages)
  # spoon: bowl and handle, standing on the spine
  $g.FillEllipse($cb, [single]($off + 57*$u), [single]($off + 26*$u), [single](16*$u), [single](20*$u))
  $g.FillRectangle($cb, [single]($off + 62*$u), [single]($off + 41*$u), [single](6*$u), [single](14*$u))

  # the gutter between the pages is cut out, so it shows whatever is behind
  # (whole pixels and no antialiasing, or the edges leave a faint half-transparent outline)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::None
  $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Default
  $gx = [int][Math]::Round($off + 62*$u); $gw = [Math]::Max(1, [int][Math]::Round($off + 68*$u) - $gx)
  $gy = [int][Math]::Round($off + 56*$u); $gh = [int][Math]::Round($off + 104.5*$u) - $gy
  if($withBg){ $g.FillRectangle($bgBrush, $gx, $gy, $gw, $gh) }
  else {
    $g.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
    $g.FillRectangle((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Transparent)), $gx, $gy, $gw, $gh)
  }
  $g.Dispose()
  return $bmp
}
function Save($bmp, $path){ $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png); $bmp.Dispose() }

# web app: favicon / install icons. The maskable one keeps the mark inside
# the circle a phone may crop it to.
Save (Draw-Icon 1024 1.0 $true $false) (Join-Path $Repo "assets\icon.png")
Save (Draw-Icon 192 1.0 $true $false) (Join-Path $Repo "icon-192.png")
Save (Draw-Icon 512 1.0 $true $false) (Join-Path $Repo "icon-512.png")
Save (Draw-Icon 512 0.8 $true $false) (Join-Path $Repo "icon-maskable-512.png")

foreach($r in $rows){
  $d = $r[0]; $s = $r[1]; $a = $r[2]
  $dir = Join-Path $out ("mipmap-" + $d)
  New-Item -ItemType Directory -Force $dir | Out-Null
  Save (Draw-Icon $s 1.0 $true $false) (Join-Path $dir "ic_launcher.png")
  Save (Draw-Icon $s 1.0 $true $true)  (Join-Path $dir "ic_launcher_round.png")
  $bg = New-Object System.Drawing.Bitmap($a, $a); $gg = [System.Drawing.Graphics]::FromImage($bg); $gg.Clear($brand); $gg.Dispose()
  Save $bg (Join-Path $dir "ic_launcher_background.png")
  # Android may crop the adaptive icon to a circle 61% of the canvas wide; 0.68 keeps the book inside it
  Save (Draw-Icon $a 0.68 $false $false) (Join-Path $dir "ic_launcher_foreground.png")
}

$xml = "<?xml version=`"1.0`" encoding=`"utf-8`"?>`n<adaptive-icon xmlns:android=`"http://schemas.android.com/apk/res/android`">`n    <background android:drawable=`"@mipmap/ic_launcher_background`"/>`n    <foreground android:drawable=`"@mipmap/ic_launcher_foreground`"/>`n</adaptive-icon>`n"
$any = Join-Path $out "mipmap-anydpi-v26"
New-Item -ItemType Directory -Force $any | Out-Null
$utf8 = New-Object System.Text.UTF8Encoding($false)
foreach($n in @("ic_launcher", "ic_launcher_round")){ [System.IO.File]::WriteAllText((Join-Path $any ($n + ".xml")), $xml, $utf8) }

# contact sheet: square, round, adaptive as a launcher crops it, and a small size
$sheet = New-Object System.Drawing.Bitmap(900, 240)
$g = [System.Drawing.Graphics]::FromImage($sheet); $g.Clear([System.Drawing.Color]::FromArgb(235,235,230))
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.DrawImage([System.Drawing.Image]::FromFile((Join-Path $out "mipmap-xxxhdpi\ic_launcher.png")), 20, 24, 192, 192)
$g.DrawImage([System.Drawing.Image]::FromFile((Join-Path $out "mipmap-xxxhdpi\ic_launcher_round.png")), 250, 24, 192, 192)
$fg = [System.Drawing.Image]::FromFile((Join-Path $out "mipmap-xxxhdpi\ic_launcher_foreground.png"))
$clip = New-Object System.Drawing.Drawing2D.GraphicsPath; $clip.AddEllipse(480, 24, 192, 192)
$g.SetClip($clip); $g.Clear($brand); $g.DrawImage($fg, 480 - 60, 24 - 60, 312, 312); $g.ResetClip()
$g.DrawImage([System.Drawing.Image]::FromFile((Join-Path $out "mipmap-mdpi\ic_launcher_round.png")), 720, 96, 48, 48)
$g.DrawImage([System.Drawing.Image]::FromFile((Join-Path $Repo "icon-maskable-512.png")), 790, 84, 72, 72)
$g.Dispose()
$sheet.Save((Join-Path $env:TEMP "kb-icon-sheet.png"), [System.Drawing.Imaging.ImageFormat]::Png)
"done"
