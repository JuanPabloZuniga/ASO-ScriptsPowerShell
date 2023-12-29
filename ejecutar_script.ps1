	do{
    . C:\Users\TFG\Desktop\TfG\Tareas.ps1
    Clear-Host
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Comando a ejecutar'
    $form.Font = New-Object System.Drawing.Font("Arial", 12)
    #$form.Size = New-Object System.Drawing.Size(350, 150)
	$form.Size = New-Object System.Drawing.Size(520,300)
    $form.StartPosition = 'CenterScreen'

    $backgroundImage = [System.Drawing.Image]::FromFile('C:\Users\TFG\Desktop\TfG\imagen.jpg')
    $form.BackgroundImage = $backgroundImage
    $form.BackgroundImageLayout = 'Stretch' # Ajustar la imagen al tama√±o del formulario

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(135,80)
    $label.Size = New-Object System.Drawing.Size(288,30)
    $label.Text = 'Introduzca la ruta absoluta del archivo'
    $form.Controls.Add($label)

    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(135,120)
    $textBox.Size = New-Object System.Drawing.Size(288,30)
    $form.Controls.Add($textBox)

    $OKButton = New-Object System.Windows.Forms.Button
    #$OKButton.Location = New-Object System.Drawing.Point(50, 80)
    #$OKButton.Size = New-Object System.Drawing.Size(75, 30)
    $OKButton.Location = New-Object System.Drawing.Point(175,220)
	$OKButton.Size = New-Object System.Drawing.Size(75,30)
	$OKButton.Text = 'OK'
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $OKButton
    $form.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    #$CancelButton.Location = New-Object System.Drawing.Point(150, 80)
    #$CancelButton.Size = New-Object System.Drawing.Size(80, 30)
    $CancelButton.Location = New-Object System.Drawing.Point(250,220)
	$CancelButton.Size = New-Object System.Drawing.Size(75,30)
	$CancelButton.Text = 'Cancelar'
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $CancelButton
    $form.Controls.Add($CancelButton)

    $result = $form.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        $global:accion = $textBox.Text

        if (Test-Path $global:accion -PathType Leaf) {
			& "C:\Users\TFG\Desktop\TfG\nombreTarea.ps1"
			frecuencia
			return
		} else {
			$ruta = "$((Get-Location).Path)$($MyInvocation.MyCommand.Name)"
			$error = "°Ruta no existente!"
			& "C:\Users\TFG\Desktop\TfG\error_comando.ps1"
		}
    }
	else {
		& "C:\Users\TFG\Desktop\TfG\menu_tareas"
	}
	}while($true)

