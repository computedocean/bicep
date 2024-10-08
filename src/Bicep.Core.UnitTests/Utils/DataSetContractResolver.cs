// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
using Newtonsoft.Json.Converters;
using Newtonsoft.Json.Serialization;

namespace Bicep.Core.UnitTests.Utils
{
    public class DataSetContractResolver : CamelCasePropertyNamesContractResolver
    {
        protected override JsonContract CreateContract(Type objectType)
        {
            var contract = base.CreateContract(objectType);

            // the omnisharp library specifies the NumberEnumConverter on some of the enum types
            // which supersedes our serialization settings
            if (objectType.IsEnum && !(contract.Converter is StringEnumConverter))
            {
                // force our converter on enum types
                contract.Converter = DataSetSerialization.CreateEnumConverter();
            }

            return contract;
        }
    }
}
