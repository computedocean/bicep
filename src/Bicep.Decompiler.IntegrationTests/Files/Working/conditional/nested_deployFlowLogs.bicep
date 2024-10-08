param location string
param NetworkWatcherName string
param FlowLogName string
param existingNSG string
param RetentionDays int
param FlowLogsversion string
param storageAccountResourceId string

resource NetworkWatcherName_FlowLog 'Microsoft.Network/networkWatchers/flowLogs@2020-06-01' = if ((1 + 2) == 3) {
  name: '${NetworkWatcherName}/${FlowLogName}'
  location: location
  properties: {
    targetResourceId: existingNSG
    storageId: storageAccountResourceId
    enabled: true
    retentionPolicy: {
      days: RetentionDays
      enabled: true
    }
    format: {
      type: 'JSON'
      version: FlowLogsversion
//@[15:30) [BCP036 (Warning)] The property "version" expected a value of type "int | null" but the provided value is of type "string". If this is a resource type definition inaccuracy, report it using https://aka.ms/bicep-type-issues. (bicep https://aka.ms/bicep/core-diagnostics#BCP036) |FlowLogsversion|
    }
  }
}

