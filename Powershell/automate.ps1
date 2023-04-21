# Variáveis
$SubscriptionId = "xxxx-xxxx-xxxx-xxxx"
$ResourceGroupName = "meuResourceGroup"
$Location = "brazilsouth"
$StorageAccountName = "meustorageaccount"
$VnetName = "meuVnet"
$SubnetName = "meuSubnet"
$VMName = "minhaVM"
$AdminUsername = "adminuser"
$AdminPassword = ConvertTo-SecureString "SuaSenhaAqui" -AsPlainText -Force

# Selecionar a assinatura do Azure
Select-AzSubscription -SubscriptionId $SubscriptionId

# Criar grupo de recursos
New-AzResourceGroup -Name $ResourceGroupName -Location $Location

# Criar conta de armazenamento
New-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName -Location $Location -SkuName Standard_LRS -Kind StorageV2

# Criar rede virtual e subnet
$Vnet = New-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Location $Location -Name $VnetName -AddressPrefix "10.0.0.0/16"
$SubnetConfig = Add-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $Vnet -AddressPrefix "10.0.1.0/24"
$Vnet | Set-AzVirtualNetwork

# Criar interface de rede
$Nic = New-AzNetworkInterface -ResourceGroupName $ResourceGroupName -Location $Location -Name "myNic" -SubnetId $SubnetConfig.Id

# Criar máquina virtual
$VMConfig = New-AzVMConfig -VMName $VMName -VMSize "Standard_B2s"
$VMConfig = Set-AzVMOperatingSystem -VM $VMConfig -Windows -ComputerName $VMName -Credential (New-Object System.Management.Automation.PSCredential ($AdminUsername, $AdminPassword))
$VMConfig = Set-AzVMSourceImage -VM $VMConfig -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2016-Datacenter" -Version "latest"
$VMConfig = Add-AzVMNetworkInterface -VM $VMConfig -Id $Nic.Id
$VMConfig = Set-AzVMBootDiagnostics -VM $VMConfig -Enable -StorageAccountName $StorageAccountName
$OSDiskUri = "https://" + $StorageAccountName + ".blob.core.windows.net/" + $VMName + "/osdisk.vhd"
$VMConfig = Set-AzVMOSDisk -VM $VMConfig -Name "osDisk" -VhdUri $OSDiskUri -Windows -Caching ReadWrite -CreateOption FromImage

# Iniciar a implantação da máquina virtual
New-AzVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $VMConfig