import { LightningElement, track, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getRecordContext from '@salesforce/apex/GeminiContextEngine.getRecordContext';
import generateResponse from '@salesforce/apex/GeminiCalloutService.generateResponse';

export default class GeminiChatUtility extends LightningElement {
    @track messages = [];
    @track userInput = '';
    @track isLoading = false;
    currentRecordId = null;
    cachedContext = null;

    // ── Track the active record and cache its context ──────────────────
    @wire(CurrentPageReference)
    handlePageRef(currentPageReference) {
        if (currentPageReference && currentPageReference.attributes && currentPageReference.attributes.recordId) {
            const newId = currentPageReference.attributes.recordId;
            if (newId !== this.currentRecordId) {
                this.currentRecordId = newId;
                this.cachedContext = null; // invalidate on navigation
            }
        }
    }

    handleInputChange(event) {
        this.userInput = event.target.value;
    }

    handleKeyPress(event) {
        if (event.key === 'Enter' && !this.isLoading) {
            this.handleSend();
        }
    }

    // ── Build chat history, excluding error messages ───────────────────
    get chatHistory() {
        return this.messages
            .filter(m => m.sender !== 'Error')
            .map(m => ({
                role: m.sender === 'Gemini' ? 'model' : 'user',
                text: m.rawText || m.text
            }));
    }

    // ── Main send handler ─────────────────────────────────────────────
    async handleSend() {
        if (!this.userInput || this.isLoading) return;

        const userText = this.userInput;
        const history = this.chatHistory;

        // Push user message
        this.messages = [...this.messages, {
            id: Date.now(),
            sender: 'You',
            text: userText,
            htmlText: this.escapeHtml(userText),
            cssClass: 'message-user'
        }];
        this.userInput = '';
        this.isLoading = true;
        this.scrollToBottom();

        try {
            // Lazy-load and cache record context
            if (!this.cachedContext && this.currentRecordId) {
                this.cachedContext = await getRecordContext({ recordId: this.currentRecordId });
            }
            const context = this.cachedContext || '{}';

            const response = await generateResponse({
                prompt: userText,
                recordContext: context,
                chatHistory: JSON.stringify(history)
            });
            const parsedRes = JSON.parse(response);

            let aiText = 'Error parsing response';
            if (parsedRes.candidates && parsedRes.candidates[0] &&
                parsedRes.candidates[0].content && parsedRes.candidates[0].content.parts) {
                // Concatenate text from ALL parts (not just the first)
                aiText = parsedRes.candidates[0].content.parts
                    .filter(p => p.text)
                    .map(p => p.text)
                    .join('\n');
            }

            this.messages = [...this.messages, {
                id: Date.now() + 1,
                sender: 'Gemini',
                text: aiText,
                rawText: aiText,
                htmlText: this.convertMarkdownToHtml(aiText),
                cssClass: 'message-ai'
            }];

            // Invalidate context cache after updates so next send gets fresh data
            if (aiText.includes('\u2705') && aiText.includes('Action Complete')) {
                this.cachedContext = null;
            }
        } catch (error) {
            console.error(error);
            const errorText = error.body ? error.body.message : error.message;
            this.messages = [...this.messages, {
                id: Date.now() + 1,
                sender: 'Error',
                text: errorText,
                htmlText: '<span style="color:#c23934">' + this.escapeHtml(errorText) + '</span>',
                cssClass: 'message-ai message-error'
            }];
        } finally {
            this.isLoading = false;
            this.scrollToBottom();
        }
    }

    // ── Auto-scroll chat to bottom ────────────────────────────────────
    scrollToBottom() {
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        setTimeout(() => {
            const container = this.template.querySelector('.chat-container');
            if (container) {
                container.scrollTop = container.scrollHeight;
            }
        }, 100);
    }

    // ── Escape HTML for safe rendering ────────────────────────────────
    escapeHtml(text) {
        if (!text) return '';
        return text
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;');
    }

    // ── Convert Markdown → HTML for lightning-formatted-rich-text ─────
    convertMarkdownToHtml(text) {
        if (!text) return '';
        let html = text;

        // 1. Escape HTML entities
        html = html.replace(/&/g, '&amp;')
                    .replace(/</g, '&lt;')
                    .replace(/>/g, '&gt;');

        // 2. Code blocks (``` ... ```)
        html = html.replace(/```[\w]*\n([\s\S]*?)```/g, '<pre><code>$1</code></pre>');

        // 3. Inline code
        html = html.replace(/`([^`]+)`/g, '<code>$1</code>');

        // 4. Bold **text**
        html = html.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>');

        // 5. Italic *text*
        html = html.replace(/(?<!\w)\*(.+?)\*(?!\w)/g, '<em>$1</em>');

        // 6. Headers
        html = html.replace(/^### (.+)$/gm, '<h3>$1</h3>');
        html = html.replace(/^## (.+)$/gm, '<h2>$1</h2>');
        html = html.replace(/^# (.+)$/gm, '<h1>$1</h1>');

        // 7. Unordered list items (- or *)
        html = html.replace(/^[\-\*] (.+)$/gm, '<li>$1</li>');

        // 8. Ordered list items (1. 2. etc.)
        html = html.replace(/^\d+\. (.+)$/gm, '<li>$1</li>');

        // 9. Wrap consecutive <li> in <ul>
        html = html.replace(/((?:<li>[\s\S]*?<\/li>\s*)+)/g, '<ul>$1</ul>');

        // 10. Line breaks
        html = html.replace(/\n/g, '<br>');

        // 11. Clean up extra <br> after block elements
        html = html.replace(/<\/li><br>/g, '</li>');
        html = html.replace(/<\/ul><br>/g, '</ul>');
        html = html.replace(/<\/pre><br>/g, '</pre>');
        html = html.replace(/<\/h([1-6])><br>/g, '</h$1>');
        html = html.replace(/<br><ul>/g, '<ul>');
        html = html.replace(/<br><pre>/g, '<pre>');

        return html;
    }
}
