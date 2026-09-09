document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll("[data-pagination]").forEach(function (grid) {
        renderPagination(grid.id);
    });
});

function renderPagination(gridId, page) {
    const grid = document.getElementById(gridId);
    if (!grid) return;

    const items = Array.from(grid.querySelectorAll("[data-page-item]"));
    const controls = document.querySelector('[data-pagination-controls="' + gridId + '"]');
    const pageSize = Number(grid.dataset.pageSize) || 9;
    const visibleItems = items.filter(function (item) {
        return !item.classList.contains("risk-filter-hidden") && item.style.display !== "none";
    });
    const totalPages = Math.max(1, Math.ceil(visibleItems.length / pageSize));
    const currentPage = Math.min(Math.max(Number(page) || 1, 1), totalPages);

    items.forEach(function (item) {
        item.classList.add("pagination-hidden");
    });
    visibleItems.slice((currentPage - 1) * pageSize, currentPage * pageSize).forEach(function (item) {
        item.classList.remove("pagination-hidden");
    });

    if (!controls) return;
    controls.innerHTML = "";
    if (totalPages <= 1) return;
    for (let i = 1; i <= totalPages; i += 1) {
        const button = document.createElement("button");
        button.type = "button";
        button.className = "client-page-button" + (i === currentPage ? " active" : "");
        button.textContent = i;
        button.setAttribute("aria-label", i + "ページ");
        button.setAttribute("aria-current", i === currentPage ? "page" : "false");
        button.addEventListener("click", function () { renderPagination(gridId, i); });
        controls.appendChild(button);
    }
}

window.refreshPagination = function (gridId) {
    renderPagination(gridId, 1);
};
