# Generates favicon PNGs and the social preview image (og-image.jpg).
# Run after changing the portrait or headline: powershell -File tools\make-graphics.ps1
Add-Type -AssemblyName System.Drawing
$img = Join-Path $PSScriptRoot '..\assets\img'
$ink = [Drawing.Color]::FromArgb(242, 239, 232)
$paper = [Drawing.Color]::FromArgb(11, 11, 10)
$accent = [Drawing.Color]::FromArgb(214, 178, 94)
$grey = [Drawing.Color]::FromArgb(214, 178, 94)

function Save-Jpeg($bmp, $path) {
  $codec = [Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
  $p = New-Object Drawing.Imaging.EncoderParameters 1
  $p.Param[0] = New-Object Drawing.Imaging.EncoderParameter ([Drawing.Imaging.Encoder]::Quality), ([long]88)
  $bmp.Save($path, $codec, $p)
}

# Favicons: "K" monogram with an accent square
foreach ($size in 32, 180) {
  $bmp = New-Object Drawing.Bitmap $size, $size
  $g = [Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = 'AntiAlias'; $g.TextRenderingHint = 'AntiAliasGridFit'
  $g.Clear([Drawing.Color]::FromArgb(11, 11, 10))
  $f = New-Object Drawing.Font 'Arial', ($size * 0.62), ([Drawing.FontStyle]::Bold), ([Drawing.GraphicsUnit]::Pixel)
  $sf = New-Object Drawing.StringFormat; $sf.Alignment = 'Center'; $sf.LineAlignment = 'Center'
  $g.DrawString('K', $f, (New-Object Drawing.SolidBrush $accent), (New-Object Drawing.RectangleF (-$size * 0.04), ($size * 0.03), $size, $size), $sf)
  $q = [int]($size * 0.13)
  $g.DrawRectangle((New-Object Drawing.Pen $accent, ([math]::Max(1, $size / 24))), [int]($size * 0.06), [int]($size * 0.06), [int]($size * 0.88), [int]($size * 0.88))
  $name = if ($size -eq 32) { 'favicon-32.png' } else { 'apple-touch-icon.png' }
  $bmp.Save((Join-Path $img $name), [Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $bmp.Dispose()
}

# Social preview 1200 x 630
$W = 1200; $H = 630
$bmp = New-Object Drawing.Bitmap $W, $H
$g = [Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = 'AntiAlias'; $g.TextRenderingHint = 'AntiAlias'; $g.InterpolationMode = 'HighQualityBicubic'
$g.Clear($paper)
$portrait = [Drawing.Image]::FromFile((Join-Path $img 'portrait-1024.jpg'))
# portrait panel on the right, cropped to the upper body
$pw = 440; $ph = $H
$srcH = [int]($portrait.Width * $ph / $pw)
$g.DrawImage($portrait, (New-Object Drawing.Rectangle ($W - $pw), 0, $pw, $ph), 0, 40, $portrait.Width, $srcH, [Drawing.GraphicsUnit]::Pixel)
$portrait.Dispose()
$g.DrawLine((New-Object Drawing.Pen $ink, 2), 64, 96, 736, 96)
$small = New-Object Drawing.Font 'Arial', 26, ([Drawing.FontStyle]::Bold), ([Drawing.GraphicsUnit]::Pixel)
$g.DrawString('Kint John Libot', $small, (New-Object Drawing.SolidBrush $grey), 60, 120)
$big = New-Object Drawing.Font 'Arial', 56, ([Drawing.FontStyle]::Bold), ([Drawing.GraphicsUnit]::Pixel)
$g.DrawString("Marketing and executive`nsupport, from the first`npost to the final invoice.", $big, (New-Object Drawing.SolidBrush $ink), (New-Object Drawing.RectangleF 56, 168, 700, 300))
$body = New-Object Drawing.Font 'Arial', 24, ([Drawing.FontStyle]::Regular), ([Drawing.GraphicsUnit]::Pixel)
$g.FillRectangle((New-Object Drawing.SolidBrush $accent), 64, 506, 4, 64)
$g.DrawString("Marketing Virtual Assistant & Executive Assistant.`nWeb, email, e-commerce, events. Portfolio and resume.", $body, (New-Object Drawing.SolidBrush $ink), 84, 506)
Save-Jpeg $bmp (Join-Path $img 'og-image.jpg')
$g.Dispose(); $bmp.Dispose()
'done'
