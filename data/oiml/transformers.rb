# frozen_string_literal: true

# Per-taste document-model transformer registration for the OIML taste.
#
# Discovered and required lazily by Metanorma::TasteRegister the first time an
# OIML build resolves its output formats. The `require` below therefore loads
# metanorma-oiml only for OIML builds, and metanorma-taste keeps no hard
# dependency on metanorma-oiml.
#
# The returned spec conforms to the metanorma-core
# Processor#document_transformers contract (reader / transformer /
# strip_default_namespace / to_xml_options), plus two keys the metanorma
# compile driver reads to make the format selectable (suffix / presentation).
Metanorma::TasteRegister.register_document_transformers(:oiml) do
  require "metanorma/oiml/sts"

  {
    oimlsts: {
      reader: Metanorma::Oiml::Sts::Transformer::SourceDocument,
      transformer: Metanorma::Oiml::Sts::Transformer::Standard,
      strip_default_namespace: false,
      to_xml_options: {},
      suffix: "oiml.sts.xml",
      presentation: true,
    },
  }
end
