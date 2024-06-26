// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

using System.Collections.Immutable;
using Azure.Core;

namespace Bicep.Core.Tracing
{
    public static class DiagnosticOptionsExtensions
    {
        private static readonly ImmutableArray<string> ArmClientAdditionalLoggedHeaders =
        [
            "x-ms-ratelimit-remaining-subscription-reads",
            "x-ms-correlation-request-id",
            "x-ms-routing-request-id"
        ];

        private static readonly ImmutableArray<string> ArmClientAdditionalLoggedQueryParams =
        [
            "api-version"
        ];

        private static readonly ImmutableArray<string> AcrClientAdditionalLoggedHeaders =
        [
            "Accept-Ranges",
            "x-ms-version",
            "Docker-Content-Digest",
            "Docker-Distribution-Api-Version",
            "X-Content-Type-Options",
            "X-Ms-Correlation-Request-Id",
            "x-ms-ratelimit-remaining-calls-per-second"
        ];

        private static readonly ImmutableArray<string> AcrClientAdditionalLoggedQueryParams = [];

        public static void ApplySharedResourceManagerSettings(this DiagnosticsOptions options) =>
            options.ApplySharedDiagnosticsSettings(ArmClientAdditionalLoggedHeaders, ArmClientAdditionalLoggedQueryParams);

        public static void ApplySharedContainerRegistrySettings(this DiagnosticsOptions options) =>
            options.ApplySharedDiagnosticsSettings(AcrClientAdditionalLoggedHeaders, AcrClientAdditionalLoggedQueryParams);

        private static void ApplySharedDiagnosticsSettings(this DiagnosticsOptions options, ImmutableArray<string> additionalHeaders, ImmutableArray<string> additionalQueryParameters)
        {
            // ensure User-Agent mentions us
            options.ApplicationId = $"{LanguageConstants.LanguageId}/{ThisAssembly.AssemblyFileVersion}";

            // This option just controls whether the User-Agent header is sent
            options.IsTelemetryEnabled = true;

            options.IsLoggingContentEnabled = false;
            options.IsDistributedTracingEnabled = false;

            foreach (var header in additionalHeaders)
            {
                options.LoggedHeaderNames.Add(header);
            }

            foreach (var queryParam in additionalQueryParameters)
            {
                options.LoggedQueryParameters.Add(queryParam);
            }
        }
    }
}
