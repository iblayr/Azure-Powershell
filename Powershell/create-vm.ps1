# Conecte em sua conta Azure
Connect-AzAccount

# Pegue o ID da assinatura e defina como padrão
$subscriptionId = (Get-AzContext).Subscription.Id
Set-AzContext -SubscriptionId $subscriptionId

# Defina as variáveis para criação da máquina virtual
$resourceGroupName = "RG-Onpremises"
$vmName = "myVM"
$location = "eastus2"
$vmSize = "Standard_B1s"
$imagePublisher = "Canonical"
$imageOffer = "UbuntuServer"
$imageSku = "18_04-lts-gen2"

# Crie um grupo de recursos se não existir
New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

# Crie uma configuração de máquina virtual
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize $vmSize

# Defina um SO para a máquina virtual
Set-AzVMOperatingSystem -VM $vmConfig `
    -Windows `
    -ComputerName $vmName `
    -Credential (Get-Credential) `
    -ProvisionVMAgent `
    -EnableAutoUpdate

Set-AzVMSourceImage -VM $vmConfig `
    -PublisherName $imagePublisher `
    -Offer $imageOffer `
    -Skus $imageSku `
    -Version latest

# Crie uma nova rede e sub-rede se não existir
$vnet = Get-AzVirtualNetwork `
            -ResourceGroupName $resourceGroupName `
            -Name "${vmName}Vnet" `
            -ErrorAction Ignore

if (-not $vnet) {
    # Crie uma nova rede e sub-rede
    Write-Host "Creating new virtual network and subnet..."
    New-AzVirtualNetworkSubnetConfig `
        -Name "${vmName}Subnet" `
        -AddressPrefix 10.0.0.0/24 | Out-Null

    New-AzVirtualNetwork `
        -ResourceGroupName $resourceGroupName `
        -Location $location `
        -Name "${vmName}Vnet" `
    -AddressPrefix 10.0.0.0/16 `
    -Subnet $subnets | Out-Null
}

# Add uma interface de rede a máquina virtual
Add-AzVMNetworkInterface -VM $vmConfig `
    -Id (New-AzNetworkInterface `
            -Name "${vmName}Nic" `
            -ResourceGroupName $resourceGroupName `
            -Location $location `
            -SubnetId (Get-AzVirtualNetworkSubnetConfig `
                            -Name "${vmName}Subnet" `
                            -VirtualNetwork (Get-AzVirtualNetwork `
                                                -ResourceGroupName $resourceGroupName `
                                                -Name "${vmName}Vnet")).Id).Id

# Crie a máquina virtual
New-AzVM -ResourceGroupName $resourceGroupName -Location $location -VM $vmConfig