# Iniciar criação de redes virtuais
$createNewVnet = $true
while ($createNewVnet) {
    # Solicitar informações da rede virtual
    $virtualNetworkName = Read-Host "Digite o nome da rede virtual"
    $region = Read-Host "Digite a região para a rede virtual"
    $virtualNetworkAddressPrefix = Read-Host "Digite o endereço IP da rede virtual (ex: 10.0.0.0/16)"

    # Perguntar ao usuário se deseja criar um novo grupo de recursos
    $createResourceGroup = Read-Host "Deseja criar um novo grupo de recursos? (s/n)"
    
    # Se o usuário deseja criar um novo grupo de recursos
    if ($createResourceGroup -eq "s") {
        # Solicitar nome e região do grupo de recursos
        $resourceGroupName = Read-Host "Digite o nome do grupo de recursos:"
        $resourceGroupLocation = Read-Host "Digite a região para o grupo de recursos:"
        # Criação do grupo de recursos
        New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
    }
    # Se o usuário não deseja criar um novo grupo de recursos
    else {
        # Lista os grupos de recursos existentes
        $resourceGroups = Get-AzResourceGroup | Select-Object ResourceGroupName, Location
        Write-Host "Grupos de recursos existentes:"
        $resourceGroups | ForEach-Object { Write-Host $_.ResourceGroupName }
        # Solicita ao usuário para escolher um grupo de recursos
        $resourceGroupName = Read-Host "Digite o nome do grupo de recursos escolhido:"
    }

    $subnets = @()

    # Criação da rede virtual
    $vnet = New-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $virtualNetworkName -Location $region -AddressPrefix $virtualNetworkAddressPrefix

    # Solicitar informações de sub-redes ao usuário
    $addSubnet = $true
    while ($addSubnet) {
        $subnetName = Read-Host "Digite o nome da sub-rede"
        $subnetAddressPrefix = Read-Host "Digite o endereço IP da sub-rede (ex: 10.0.1.0/24)"

        # Criação da sub-rede
        $subnet = New-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix $subnetAddressPrefix
        $subnets += $subnet

        # Perguntar se deseja criar outra sub-rede
        $addSubnet = Read-Host "Deseja criar outra sub-rede? (S/N)" | Where-Object { $_ -eq "S" }
    }

    # Associar sub-redes à rede virtual e atualizar a rede virtual
    $vnet.Subnets = $subnets
    Set-AzVirtualNetwork -VirtualNetwork $vnet

    # Exibir informações da rede virtual e sub-redes criadas
    Write-Host "Rede virtual '$virtualNetworkName' criada com sucesso:"
    Write-Host " - Endereço IP da rede virtual: $virtualNetworkAddressPrefix"
    Write-Host " - Sub-redes:"
    foreach ($subnet in $subnets) {
        Write-Host "   * Nome: $($subnet.Name) | Endereço IP: $($subnet.AddressPrefix)"
    }

    # Perguntar se deseja criar outra rede virtual
    $createNewVnet = Read-Host "Deseja criar outra rede virtual? (S/N)" | Where-Object { $_ -eq "S" }
}