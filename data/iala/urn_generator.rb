# frozen_string_literal: true

# The iala taste's bibdata-URN generator: the document's identifier fields
# (series letter + docnumber + edition) build a Pubid::Iala identifier,
# whose to_urn is the publication URN form IALA prints on its cover pages.
# pubid is the identifier SSOT and canonicalizes the printed casing and
# padding variants; generation from fields beats transcription
# (metanorma-taste#250).
#
# Required lazily by Metanorma::Taste::Base on the generator's first use,
# so pubid loads only for builds that run the iala taste.
require "pubid"

unless defined?(Pubid::Iala)
  raise LoadError,
        "urn-generator pubid-iala needs pubid >= 2.0.26 (Pubid::Iala)"
end

Metanorma::Taste::UrnGenerator.register("pubid-iala") do |attrs|
  series = attrs["series"] || attrs["seriesabbr"]
  number = attrs["docnumber"]
  edition = attrs["edition"].to_s
  edition = nil if edition.empty?

  # No series letter or no number: the document has no URN-able IALA
  # publication identity (letters, standalone annexes); emit nothing.
  next unless series && number

  klass = Pubid::Iala.identifier_klass_for_type_letter(series)
  identifier = klass.new(number: number, edition: edition)
  # Canonicalize through pubid's own parser: the identifier's human form
  # re-parses to the cover-page publication form (zero padding, casing),
  # so the emitted URN always equals the SSOT generator output.
  Pubid::Iala.parse(identifier.to_s).to_urn
rescue KeyError
  # Series letter pubid does not know: not a URN-able publication form.
  nil
end
