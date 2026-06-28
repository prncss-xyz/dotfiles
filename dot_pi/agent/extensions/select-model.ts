import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { DynamicBorder } from "@earendil-works/pi-coding-agent";
import {
  Container,
  fuzzyFilter,
  getKeybindings,
  Input,
  Spacer,
  Text,
  type Focusable,
} from "@earendil-works/pi-tui";

const CURATED_MODELS = [
  { provider: "openai-codex", id: "gpt-5.5" },
  { provider: "openai-codex", id: "gpt-5.4-mini" },
  { provider: "openai-codex", id: "gpt-5.4-nano" },
  { provider: "opencode-go", id: "glm-5.2" },
  { provider: "opencode-go", id: "qwen3.7-max" },
  { provider: "opencode-go", id: "kimi-k2.7-code" },
  { provider: "opencode-go", id: "mimo-v2.5-pro" },
  { provider: "opencode-go", id: "deepseek-v4-pro" },
  { provider: "opencode-go", id: "qwen3.7-plus" },
  { provider: "opencode-go", id: "minimax-m3" },
  { provider: "opencode-go", id: "mimo-v2.5" },
  { provider: "opencode-go", id: "deepseek-v4-flash" },
];

export default function (pi: ExtensionAPI) {
  // Quick-access shortcuts: ctrl+1 through ctrl+6
  for (const [i, model] of CURATED_MODELS.entries()) {
    pi.registerShortcut(`ctrl+${i + 1}`, {
      description: `Select ${model.id}`,
      handler: selectModelHandler(pi, model.provider, model.id),
    });
  }

  // ctrl+l: curated model picker dialog (overrides app.model.select)
  pi.registerShortcut("ctrl+l", {
    description: "Select model from curated list",
    handler: curatedModelPicker(pi),
  });
}

function selectModelHandler(
  pi: ExtensionAPI,
  provider: string,
  modelId: string,
): (ctx: ExtensionContext) => Promise<void> {
  return async (ctx) => {
    const model = ctx.modelRegistry.find(provider, modelId);
    if (!model) {
      ctx.ui.notify(`Model not found: ${provider}/${modelId}`, "error");
      return;
    }
    const ok = await pi.setModel(model);
    if (!ok) {
      ctx.ui.notify(`No API key for ${provider}/${modelId}`, "error");
      return;
    }
    ctx.ui.notify(`Model: ${provider}/${modelId}`, "info");
  };
}

function curatedModelPicker(pi: ExtensionAPI): (ctx: ExtensionContext) => Promise<void> {
  return async (ctx) => {
    const model = await ctx.ui.custom<ModelRef | null>(
      (tui, theme, _kb, done) => new ModelPicker(tui, theme, done),
      { overlay: true },
    );

    if (model) {
      await selectModelHandler(pi, model.provider, model.id)(ctx);
    }
  };
}

interface ModelRef {
  provider: string;
  id: string;
}

class ModelPicker extends Container implements Focusable {
  private searchInput: Input;
  private listContainer: Container;
  private filteredModels: ModelRef[];
  private selectedIndex = 0;
  private _focused = false;
  get focused(): boolean {
    return this._focused;
  }
  set focused(value: boolean) {
    this._focused = value;
    this.searchInput.focused = value;
  }

  constructor(
    private tui: { requestRender(): void },
    private theme: {
      fg(name: string, text: string): string;
      bold(text: string): string;
    },
    private done: (model: ModelRef | null) => void,
  ) {
    super();
    this.filteredModels = [...CURATED_MODELS];

    this.addChild(new DynamicBorder((s: string) => this.theme.fg("accent", s)));
    this.addChild(new Spacer(1));
    this.addChild(new Text(this.theme.fg("accent", this.theme.bold(" Select Model")), 0, 0));
    this.addChild(new Spacer(1));

    this.searchInput = new Input();
    this.searchInput.onSubmit = () => {
      const selected = this.filteredModels[this.selectedIndex];
      if (selected) this.done(selected);
    };
    this.addChild(this.searchInput);

    this.addChild(new Spacer(1));

    this.listContainer = new Container();
    this.addChild(this.listContainer);

    this.addChild(new Spacer(1));
    this.addChild(
      new Text(
        this.theme.fg("dim", " type to filter  ↑↓ navigate  enter select  esc cancel "),
        0,
        0,
      ),
    );
    this.addChild(new DynamicBorder((s: string) => this.theme.fg("accent", s)));

    this.updateList();
  }

  private filterModels(query: string) {
    this.filteredModels = query
      ? fuzzyFilter(CURATED_MODELS, query, (m) => `${m.id} ${m.provider} ${m.provider}/${m.id}`)
      : [...CURATED_MODELS];
    this.selectedIndex = 0;
    this.updateList();
    this.tui.requestRender();
  }

  private updateList() {
    this.listContainer.clear();
    const maxVisible = 10;
    const startIndex = Math.max(
      0,
      Math.min(
        this.selectedIndex - Math.floor(maxVisible / 2),
        this.filteredModels.length - maxVisible,
      ),
    );
    const endIndex = Math.min(startIndex + maxVisible, this.filteredModels.length);

    for (let i = startIndex; i < endIndex; i++) {
      const item = this.filteredModels[i]!;
      const isSelected = i === this.selectedIndex;
      const prefix = isSelected ? this.theme.fg("accent", "→ ") : "  ";
      const idText = isSelected ? this.theme.fg("accent", item.id) : item.id;
      const providerBadge = this.theme.fg("muted", `[${item.provider}]`);
      this.listContainer.addChild(new Text(`${prefix}${idText} ${providerBadge}`, 0, 0));
    }

    if (startIndex > 0 || endIndex < this.filteredModels.length) {
      const scrollInfo = this.theme.fg(
        "dim",
        `  (${this.selectedIndex + 1}/${this.filteredModels.length})`,
      );
      this.listContainer.addChild(new Text(scrollInfo, 0, 0));
    }

    if (this.filteredModels.length === 0) {
      this.listContainer.addChild(new Text(this.theme.fg("muted", "  No matching models"), 0, 0));
    }
  }

  handleInput(data: string): void {
    const kb = getKeybindings();

    if (kb.matches(data, "tui.select.up")) {
      if (this.filteredModels.length === 0) return;
      this.selectedIndex =
        this.selectedIndex === 0 ? this.filteredModels.length - 1 : this.selectedIndex - 1;
      this.updateList();
      this.tui.requestRender();
    } else if (kb.matches(data, "tui.select.down")) {
      if (this.filteredModels.length === 0) return;
      this.selectedIndex =
        this.selectedIndex === this.filteredModels.length - 1 ? 0 : this.selectedIndex + 1;
      this.updateList();
      this.tui.requestRender();
    } else if (kb.matches(data, "tui.select.confirm")) {
      const selected = this.filteredModels[this.selectedIndex];
      if (selected) this.done(selected);
    } else if (kb.matches(data, "tui.select.cancel")) {
      this.done(null);
    } else {
      this.searchInput.handleInput(data);
      this.filterModels(this.searchInput.getValue());
    }
  }
}
