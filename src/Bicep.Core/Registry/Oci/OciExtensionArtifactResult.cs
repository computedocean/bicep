// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

namespace Bicep.Core.Registry.Oci
{
    public class OciExtensionArtifactResult : OciArtifactResult
    {
        private readonly OciArtifactLayer mainLayer;

        public OciExtensionArtifactResult(BinaryData manifestBits, string manifestDigest, IEnumerable<OciArtifactLayer> layers, OciArtifactLayer? config) :
            base(manifestBits, manifestDigest, layers)
        {
            var manifest = this.Manifest;
            if (manifest.ArtifactType is null || !manifest.ArtifactType.Equals(BicepMediaTypes.BicepExtensionArtifactType, MediaTypeComparison))
            {
                throw new InvalidArtifactException($"Unknown artifactType: '{manifest.ArtifactType}'.", InvalidArtifactExceptionKind.WrongArtifactType);
            }
            if (!manifest.Config.MediaType.Equals(BicepMediaTypes.BicepExtensionConfigV1, MediaTypeComparison))
            {
                throw new InvalidArtifactException($"Unknown config.mediaType: '{manifest.Config.MediaType}'.", InvalidArtifactExceptionKind.WrongArtifactType);
            }

            var expectedLayerMediaType = BicepMediaTypes.BicepExtensionArtifactLayerV1TarGzip;
            this.mainLayer = this.Layers.Where(l => l.MediaType.Equals(expectedLayerMediaType, MediaTypeComparison)).Single();
            Config = config;
        }

        public override OciArtifactLayer GetMainLayer() => this.mainLayer;

        public OciArtifactLayer? Config { get; }
    }
}
