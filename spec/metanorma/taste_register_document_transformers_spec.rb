require "spec_helper"

# The per-taste document-model transformer hook (metanorma-core#12): a taste may
# contribute { format => spec } entries that the taste-aware metanorma-core
# Processor merges into its document_transformers.
RSpec.describe "Metanorma::TasteRegister document-model transformer hook" do
  let(:register) { Metanorma::TasteRegister.instance }

  # The hook mutates the shared singleton; snapshot and restore its state.
  around do |example|
    hooks = register.instance_variable_get(:@transformer_hooks)&.dup
    specs = register.instance_variable_get(:@transformer_specs)&.dup
    example.run
  ensure
    register.instance_variable_set(:@transformer_hooks, hooks)
    register.instance_variable_set(:@transformer_specs, specs)
  end

  it "returns {} for a taste that registers no transformers" do
    expect(register.document_transformers_for(:no_such_taste)).to eq({})
  end

  it "returns what a taste registers, evaluating the block lazily" do
    evaluated = false
    register.register_document_transformers(:widget) do
      evaluated = true
      { widgetsts: { suffix: "widget.sts.xml", presentation: true } }
    end
    expect(evaluated).to be(false)
    expect(register.document_transformers_for(:widget))
      .to eq(widgetsts: { suffix: "widget.sts.xml", presentation: true })
  end

  it "memoises the result so the block runs once" do
    calls = 0
    register.register_document_transformers(:widget) do
      calls += 1
      {}
    end
    2.times { register.document_transformers_for(:widget) }
    expect(calls).to eq(1)
  end
end
