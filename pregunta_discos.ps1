
    . C:\Users\TFG\Desktop\TfG\Tareas.ps1
    Clear-Host
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Comando a ejecutar'
    $form.Font = New-Object System.Drawing.Font("Arial", 12)
    $form.Size = New-Object System.Drawing.Size(520,300)
    $form.StartPosition = 'CenterScreen'

    $backgroundImage = [System.Drawing.Image]::FromFile('C:\Users\TFG\Desktop\TfG\imagen.jpg')
    $form.BackgroundImage = $backgroundImage
    $form.BackgroundImageLayout = 'Stretch' # Ajustar la imagen al tamaño del formulario

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(135,80)
    $label.Size = New-Object System.Drawing.Size(220,45)
    $label.Text = "Hay $Tlinea sin inicializar, ¿desea iniciarlos?"
    $form.Controls.Add($label)

    $OKButton = New-Object System.Windows.Forms.Button
	$OKButton.Location = New-Object System.Drawing.Point(175,220)
	$OKButton.Size = New-Object System.Drawing.Size(75,30)
    $OKButton.Text = 'SI'
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $OKButton
    $form.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Point(250,220)
	$CancelButton.Size = New-Object System.Drawing.Size(75,30)
    $CancelButton.Text = 'NO'
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $CancelButton
    $form.Controls.Add($CancelButton)

    $result = $form.ShowDialog()
	
		if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
			iniciar
		}elseif ($result -eq [System.Windows.Forms.DialogResult]::Cancel) {
			Discos
		}
		else {
			& "C:\Users\TFG\Desktop\TfG\Menu_PRINCIPAL.ps1"
            break
		}
