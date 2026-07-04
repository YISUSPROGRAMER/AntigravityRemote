export async function inspectUI(cdp) {
    const INSPECT_SCRIPT = `(() => {
        try {
            // Find all divs in the document
            const elements = Array.from(document.querySelectorAll('*'));
            const results = [];
            
            // 1. Check for contenteditable editor
            const editors = Array.from(document.querySelectorAll('[contenteditable="true"]'));
            results.push({
                editorsCount: editors.length,
                editorsInfo: editors.map(el => {
                    let path = [];
                    let curr = el;
                    while (curr && curr !== document.body) {
                        path.push({
                            tag: curr.tagName.toLowerCase(),
                            id: curr.id || '',
                            class: curr.className || ''
                        });
                        curr = curr.parentElement;
                    }
                    return path;
                })
            });

            // 2. Find any elements with id/class containing conversation, chat, cascade, message, or panel
            const interesting = elements.filter(el => {
                const id = (el.id || '').toLowerCase();
                const cls = (el.className || '').toString().toLowerCase();
                return id.includes('chat') || id.includes('conversation') || id.includes('cascade') || id.includes('message') ||
                       cls.includes('chat') || cls.includes('conversation') || cls.includes('cascade') || cls.includes('message');
            }).map(el => ({
                tag: el.tagName.toLowerCase(),
                id: el.id || '',
                class: (el.className || '').toString().substring(0, 100),
                childCount: el.children.length,
                textSnippet: (el.innerText || '').substring(0, 40).trim()
            }));
            
            results.push({ interestingCount: interesting.length, interesting: interesting.slice(0, 50) });

            return JSON.stringify(results, null, 2);
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
