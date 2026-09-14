<script>
    (function () {
        "use strict";

        function textOf(source, selector) {
            if (!source) {
                return "";
            }
            var element = source.querySelector(selector);
            return element ? element.textContent.trim() : "";
        }

        function rowCellText(row, index) {
            var cell = row.cells[index];
            if (!cell) {
                return "";
            }
            var link = cell.querySelector("a");
            return (link || cell).textContent.trim();
        }

        function createPreview() {
            var preview = document.createElement("aside");
            preview.className = "admin-list-preview";
            preview.setAttribute("aria-hidden", "true");
            document.body.appendChild(preview);
            return preview;
        }

        function positionPreview(preview, event) {
            var offset = 16;
            var left = event.clientX + offset;
            var top = event.clientY + offset;
            var rect = preview.getBoundingClientRect();

            if (left + rect.width > window.innerWidth - 12) {
                left = Math.max(12, event.clientX - rect.width - offset);
            }
            if (top + rect.height > window.innerHeight - 12) {
                top = Math.max(12, window.innerHeight - rect.height - 12);
            }

            preview.style.left = left + "px";
            preview.style.top = top + "px";
        }

        function renderPreview(preview, row) {
            var source = row.querySelector(".admin-preview-source");
            var title = textOf(source, ".admin-preview-source-title") || rowCellText(row, 2) || "\u30bf\u30a4\u30c8\u30eb\u306a\u3057";
            var writer = textOf(source, ".admin-preview-source-writer") || rowCellText(row, 3) || "\u6295\u7a3f\u8005\u60c5\u5831\u306a\u3057";
            var content = textOf(source, ".admin-preview-source-content") || "\u672c\u6587\u306f\u3042\u308a\u307e\u305b\u3093\u3002";
            var image = source ? source.querySelector(".admin-preview-source-image") : null;
            var icon = row.dataset.previewKind === "board" ? "bi-exclamation-triangle-fill" : "bi-chat-square-text-fill";

            preview.replaceChildren();

            var media = document.createElement("div");
            media.className = "admin-list-preview-media";
            if (image && image.src) {
                var thumbnail = document.createElement("img");
                thumbnail.src = image.src;
                thumbnail.alt = "\u6295\u7a3f\u753b\u50cf";
                thumbnail.onerror = function () {
                    media.replaceChildren();
                    var fallbackIcon = document.createElement("i");
                    fallbackIcon.className = "bi " + icon;
                    media.appendChild(fallbackIcon);
                };
                media.appendChild(thumbnail);
            } else {
                var fallback = document.createElement("i");
                fallback.className = "bi " + icon;
                media.appendChild(fallback);
            }

            var titleElement = document.createElement("div");
            titleElement.className = "admin-list-preview-title";
            titleElement.textContent = title;

            var writerElement = document.createElement("div");
            writerElement.className = "admin-list-preview-writer";
            writerElement.textContent = "\u6295\u7a3f\u8005: " + writer;

            var contentElement = document.createElement("div");
            contentElement.className = "admin-list-preview-content";
            contentElement.textContent = content;

            preview.append(media, titleElement, writerElement, contentElement);
        }

        document.addEventListener("DOMContentLoaded", function () {
            var triggers = document.querySelectorAll(
                ".admin-table tbody a[href*='/admin/board/detail'], " +
                ".admin-table tbody a[href*='/admin/community/detail']"
            );
            if (!triggers.length) {
                return;
            }

            var preview = createPreview();
            triggers.forEach(function (trigger) {
                var row = trigger.closest("tr");
                if (!row) {
                    return;
                }
                trigger.addEventListener("mouseenter", function (event) {
                    renderPreview(preview, row);
                    preview.classList.add("is-visible");
                    positionPreview(preview, event);
                });
                trigger.addEventListener("mousemove", function (event) {
                    if (preview.classList.contains("is-visible")) {
                        positionPreview(preview, event);
                    }
                });
                trigger.addEventListener("mouseleave", function () {
                    preview.classList.remove("is-visible");
                });
            });
        });
    }());
</script>
