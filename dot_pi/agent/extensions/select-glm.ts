// Bind ctrl+1 to select the GLM model (opencode-go/glm-5.2) from models.json.
//
// keybindings.json only remaps built-in action IDs to keys; it cannot target a
// specific named model. registerShortcut + pi.setModel is the supported path.

import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.registerShortcut("ctrl+1", {
    description: "Select GLM model",
    handler: selectModelHandler(pi, "opencode-go", "glm-5.2"),
  });
  pi.registerShortcut("ctrl+2", {
    description: "Select Deepseek Pro model",
    handler: selectModelHandler(pi, "opencode-go", "deepseek-v4-pro"),
  });
  pi.registerShortcut("ctrl+3", {
    description: "Select Deepseek Flash model",
    handler: selectModelHandler(pi, "opencode-go", "deepseek-v4-flash"),
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
