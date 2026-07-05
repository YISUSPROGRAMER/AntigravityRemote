export async function inspectUI(cdp) {
    const INSPECT_SCRIPT = `(() => {
        try {
            const conversation = document.getElementById('conversation');
            if (!conversation) return 'No conversation container found';
            
            const children = Array.from(conversation.children).map((c, idx) => {
                return {
                    index: idx,
                    tag: c.tagName.toLowerCase(),
                    id: c.id || '',
                    class: c.className || '',
                    text: c.innerText.substring(0, 100),
                    children: Array.from(c.children).map(cc => ({
                        tag: cc.tagName.toLowerCase(),
                        id: cc.id || '',
                        class: cc.className || '',
                        text: cc.innerText.substring(0, 100)
                    }))
                };
            });
            
            return JSON.stringify({ conversationChildren: children }, null, 2);
        } catch (e) {
            return 'Error: ' + e.message;
        }
    })()`;
    
    for (const ctx of cdp.contexts) {
        try {
            const result = await cdp.call("Runtime.evaluate", {
                expression: INSPECT_SCRIPT,
                returnByValue: true,
                contextId: ctx.id
            });

            if (result.result && result.result.value) {
                return result.result.value;
            }
        } catch (e) { }
    }
    return 'Failed to inspect';
}
