New-AzResourceGroup -Name 'myResourceGroup' -Location 'WestEurope'
New-AzVm -ResourceGroupName 'myResourceGroup' -Name 'myVM' -Location 'WestEurope' -VirtualNetworkName 'myVnet' -SubnetName 'mySubnet' -SecurityGroupName 'myNetworkSecurityGroup' -PublicIpAddressName 'myPublicIpAddress' -OpenPorts 80,3389
$publicIpAddress = Get-AzPublicIpAddress -ResourceGroupName 'myResourceGroup' | Select-Object -Property  'IpAddress'
mstsc /v:$publicIpAddress