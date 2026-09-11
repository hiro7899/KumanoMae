document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll(".clickable-card[data-card-href]").forEach(function (card) {
        card.setAttribute("tabindex", "0");
        card.setAttribute("role", "link");
        card.addEventListener("click", function (event) {
            if (event.target.closest("a, button, input, select, textarea")) return;
            window.location.href = card.dataset.cardHref;
        });
        card.addEventListener("keydown", function (event) {
            if (event.key === "Enter" || event.key === " ") {
                event.preventDefault();
                window.location.href = card.dataset.cardHref;
            }
        });
    });
});
