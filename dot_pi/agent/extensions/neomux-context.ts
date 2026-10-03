import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.on("before_agent_start", (event) => {
    const context = process.env.NEOMUX_CTX;
    if (context !== undefined) {
      event.systemPromptOptions.sections.neomux_ctx = context;
    } else {
      delete event.systemPromptOptions.sections.neomux_ctx;
    }
  });
}
