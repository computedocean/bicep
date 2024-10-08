var boolVal = true

var vmProperties = {
  diagnosticsProfile: {
    bootDiagnostics: {
      enabled: 123
      storageUri: true
      unknownProp: 'asdf'
    }
  }
  evictionPolicy: boolVal
}

resource vm 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: 'vm'
  location: 'West US'
  properties: vmProperties
//@[14:26) [BCP036 (Warning)] The property "enabled" expected a value of type "bool | null" but the provided value in source declaration "vmProperties" is of type "123". If this is a resource type definition inaccuracy, report it using https://aka.ms/bicep-type-issues. (bicep https://aka.ms/bicep/core-diagnostics#BCP036) |vmProperties|
//@[14:26) [BCP036 (Warning)] The property "evictionPolicy" expected a value of type "null | string" but the provided value in source declaration "vmProperties" is of type "true". If this is a resource type definition inaccuracy, report it using https://aka.ms/bicep-type-issues. (bicep https://aka.ms/bicep/core-diagnostics#BCP036) |vmProperties|
//@[14:26) [BCP036 (Warning)] The property "storageUri" expected a value of type "null | string" but the provided value in source declaration "vmProperties" is of type "true". If this is a resource type definition inaccuracy, report it using https://aka.ms/bicep-type-issues. (bicep https://aka.ms/bicep/core-diagnostics#BCP036) |vmProperties|
//@[14:26) [BCP037 (Warning)] The property "unknownProp" from source declaration "vmProperties" is not allowed on objects of type "BootDiagnostics". No other properties are allowed. If this is a resource type definition inaccuracy, report it using https://aka.ms/bicep-type-issues. (bicep https://aka.ms/bicep/core-diagnostics#BCP037) |vmProperties|
}

var ipConfigurations = [for i in range(0, 2): {
  id: true
  name: 'asdf${i}'
  properties: {
    madeUpProperty: boolVal
    subnet: 'hello'
  }
}]

resource nic 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: 'abc'
  properties: {
    ipConfigurations: ipConfigurations
//@[22:38) [BCP036 (Warning)] The property "id" expected a value of type "null | string" but the provided value in source declaration "ipConfigurations" is of type "true". If this is a resource type definition inaccuracy, report it using https://aka.ms/bicep-type-issues. (bicep https://aka.ms/bicep/core-diagnostics#BCP036) |ipConfigurations|
//@[22:38) [BCP037 (Warning)] The property "madeUpProperty" from source declaration "ipConfigurations" is not allowed on objects of type "NetworkInterfaceIPConfigurationPropertiesFormat". Permissible properties include "applicationGatewayBackendAddressPools", "applicationSecurityGroups", "loadBalancerBackendAddressPools", "loadBalancerInboundNatRules", "primary", "privateIPAddress", "privateIPAddressVersion", "privateIPAllocationMethod", "publicIPAddress", "virtualNetworkTaps". If this is a resource type definition inaccuracy, report it using https://aka.ms/bicep-type-issues. (bicep https://aka.ms/bicep/core-diagnostics#BCP037) |ipConfigurations|
//@[22:38) [BCP036 (Warning)] The property "subnet" expected a value of type "Subnet | null" but the provided value in source declaration "ipConfigurations" is of type "'hello'". If this is a resource type definition inaccuracy, report it using https://aka.ms/bicep-type-issues. (bicep https://aka.ms/bicep/core-diagnostics#BCP036) |ipConfigurations|
  }
}

resource nicLoop 'Microsoft.Network/networkInterfaces@2020-11-01' = [for i in range(0, 2): {
  name: 'abc${i}'
  properties: {
    ipConfigurations: [
      // TODO: fix this
      ipConfigurations[i]
//@[06:25) [BCP036 (Warning)] The property "id" expected a value of type "null | string" but the provided value is of type "true". If this is a resource type definition inaccuracy, report it using https://aka.ms/bicep-type-issues. (bicep https://aka.ms/bicep/core-diagnostics#BCP036) |ipConfigurations[i]|
//@[06:25) [BCP037 (Warning)] The property "madeUpProperty" is not allowed on objects of type "NetworkInterfaceIPConfigurationPropertiesFormat". Permissible properties include "applicationGatewayBackendAddressPools", "applicationSecurityGroups", "loadBalancerBackendAddressPools", "loadBalancerInboundNatRules", "primary", "privateIPAddress", "privateIPAddressVersion", "privateIPAllocationMethod", "publicIPAddress", "virtualNetworkTaps". If this is a resource type definition inaccuracy, report it using https://aka.ms/bicep-type-issues. (bicep https://aka.ms/bicep/core-diagnostics#BCP037) |ipConfigurations[i]|
//@[06:25) [BCP036 (Warning)] The property "subnet" expected a value of type "Subnet | null" but the provided value is of type "'hello'". If this is a resource type definition inaccuracy, report it using https://aka.ms/bicep-type-issues. (bicep https://aka.ms/bicep/core-diagnostics#BCP036) |ipConfigurations[i]|
    ]
  }
}]

resource nicLoop2 'Microsoft.Network/networkInterfaces@2020-11-01' = [for ipConfig in ipConfigurations: {
  name: 'abc${ipConfig.name}'
  properties: {
    ipConfigurations: [
      // TODO: fix this
      ipConfig
//@[06:14) [BCP036 (Warning)] The property "id" expected a value of type "null | string" but the provided value in source declaration "ipConfig" is of type "true". If this is a resource type definition inaccuracy, report it using https://aka.ms/bicep-type-issues. (bicep https://aka.ms/bicep/core-diagnostics#BCP036) |ipConfig|
//@[06:14) [BCP037 (Warning)] The property "madeUpProperty" from source declaration "ipConfig" is not allowed on objects of type "NetworkInterfaceIPConfigurationPropertiesFormat". Permissible properties include "applicationGatewayBackendAddressPools", "applicationSecurityGroups", "loadBalancerBackendAddressPools", "loadBalancerInboundNatRules", "primary", "privateIPAddress", "privateIPAddressVersion", "privateIPAllocationMethod", "publicIPAddress", "virtualNetworkTaps". If this is a resource type definition inaccuracy, report it using https://aka.ms/bicep-type-issues. (bicep https://aka.ms/bicep/core-diagnostics#BCP037) |ipConfig|
//@[06:14) [BCP036 (Warning)] The property "subnet" expected a value of type "Subnet | null" but the provided value in source declaration "ipConfig" is of type "'hello'". If this is a resource type definition inaccuracy, report it using https://aka.ms/bicep-type-issues. (bicep https://aka.ms/bicep/core-diagnostics#BCP036) |ipConfig|
    ]
  }
}]

