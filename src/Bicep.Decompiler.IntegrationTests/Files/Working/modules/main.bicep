param location string = resourceGroup().location

@description('Base URL for the reference templates and scripts')
param baseUrl string = 'https://my.base/url'

var armBaseUrl = baseUrl
var module1Url = '${armBaseUrl}/nested/module1.json'
var module2Url = '${armBaseUrl}/nested/module2.jsonc'
//@[04:14) [no-unused-vars (Warning)] Variable "module2Url" is declared but never used. (bicep core linter https://aka.ms/bicep/linter-diagnostics#no-unused-vars) |module2Url|
var objectVar = {
  val1: 'a${location}b'
}
var arrayVar = [
  'abc'
  location
]

module module1Deploy 'nested/module1.json' = {
  name: 'module1Deploy'
  params: {
    location: location
    objectParam: objectVar
    arrayParam: arrayVar
  }
}

module module2Deploy 'nested/module2.jsonc' = {
  name: 'module2Deploy'
  params: {
    location: location
    objectParam: objectVar
    arrayParam: arrayVar
  }
}

module moduleWithDodgyUri '?' /*TODO: replace with correct path to [concat(parameters('location'), 'abc', variables('module2Url'))]*/ = {
//@[26:29) [BCP085 (Error)] The specified file path contains one ore more invalid path characters. The following are not permitted: """, "*", ":", "<", ">", "?", "\", "|". (bicep https://aka.ms/bicep/core-diagnostics#BCP085) |'?'|
  name: 'moduleWithDodgyUri'
  params: {
    location: location
    objectParam: objectVar
    arrayParam: arrayVar
  }
}

module moduleWithRg 'nested/module1.json' = {
  name: 'moduleWithRg'
  scope: resourceGroup('test${module1Url}')
  params: {}
//@[02:08) [BCP035 (Error)] The specified "object" declaration is missing the following required properties: "arrayParam", "location", "objectParam". (bicep https://aka.ms/bicep/core-diagnostics#BCP035) |params|
}

module moduleWithRgAndSub 'nested/module1.json' = {
  name: 'moduleWithRgAndSub'
  scope: resourceGroup('${module1Url}test', 'test${module1Url}')
  params: {}
//@[02:08) [BCP035 (Error)] The specified "object" declaration is missing the following required properties: "arrayParam", "location", "objectParam". (bicep https://aka.ms/bicep/core-diagnostics#BCP035) |params|
}

module moduleWithSub 'nested/module1.json' = {
  name: 'moduleWithSub'
  scope: subscription('${module1Url}test')
//@[09:42) [BCP134 (Error)] Scope "subscription" is not valid for this module. Permitted scopes: "resourceGroup". (bicep https://aka.ms/bicep/core-diagnostics#BCP134) |subscription('${module1Url}test')|
  params: {}
//@[02:08) [BCP035 (Error)] The specified "object" declaration is missing the following required properties: "arrayParam", "location", "objectParam". (bicep https://aka.ms/bicep/core-diagnostics#BCP035) |params|
}

