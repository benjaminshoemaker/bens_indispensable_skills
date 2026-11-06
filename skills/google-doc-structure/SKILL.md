---
name: google-doc-structure
description: Establish the tab hierarchy and content coverage of a referenced Google Doc before a whole-document summary, extraction, or edit. Use when the active tab or a truncated connector response could hide material.
---

# Check Google Doc structure

A selected-tab URL identifies a location within a document. It does not establish the document's complete scope.

```text
- [ ] Identify document and selected tab
- [ ] Enumerate accessible tabs and nested child tabs
- [ ] Read the requested scope and check truncation
- [ ] Report coverage before drawing conclusions
```

Use an authenticated connector already authorized for the requested document. Discover its available metadata and content capabilities rather than assume a tool name. When a direct Google Docs API route is configured and authorized, request `documents.get` with `includeTabsContent=true` and traverse `tabs` and `childTabs`. Follow the user's browser and source-access preferences; authenticated browser inspection is an alternative when rendered content is needed.

Record title, document ID, selected tab ID, tab titles/IDs, hierarchy, and read coverage. A connector's successful first response may still contain only the selected tab or legacy body. Check pagination and truncation notices. Missing `tabs`, a mid-section ending, or an incomplete hierarchy calls for another authorized structure read before claiming completeness.

An export can corroborate titles or content, but may flatten hierarchy, omit IDs, or include only part of the document. Label those limits. For a whole-document request, cover all accessible tabs; for a selected-tab task, enumerate the structure briefly and focus on that scope unless the user explicitly limits discovery.

If access fails, report the required connection or sign-in step and pause conclusions dependent on that content. Continue independent work; an inaccessible URL establishes no document facts. Preserve only the content the task needs and the destination permits.

Deliver a short coverage statement: document, tabs found, scope read, and unresolved gaps. Separate structural facts from substantive conclusions. For edits, verify the changed tab and affected anchors/content after saving. This skill grants no sharing or publication authority.
