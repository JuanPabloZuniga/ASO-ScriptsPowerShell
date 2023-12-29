. $ruta
Clear-Host
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'AVISO DE ERROR'
$form.Font = New-Object System.Drawing.Font("Arial",12)
#$form.Size = New-Object System.Drawing.Size(350, 150)
$form.Size = New-Object System.Drawing.Size(520,300)
$form.StartPosition = 'CenterScreen'

$backgroundImage = [System.Drawing.Image]::FromFile('C:\Users\TFG\Desktop\TfG\amarillo.jpg')
$form.BackgroundImage = $backgroundImage
$form.BackgroundImageLayout = 'Stretch' # Ajustar la imagen al tamaño del formulario

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(150,90)
$label.Size = New-Object System.Drawing.Size(245, 42)
$label.Text = $error
$form.Controls.Add($label)

$OKButton = New-Object System.Windows.Forms.Button
#$OKButton.Location = New-Object System.Drawing.Point(50, 80)
#$OKButton.Size = New-Object System.Drawing.Size(75, 30)
$OKButton.Location = New-Object System.Drawing.Point(220,220)
$OKButton.Size = New-Object System.Drawing.Size(75,30)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$result = $form.ShowDialog()
if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
	return
}
