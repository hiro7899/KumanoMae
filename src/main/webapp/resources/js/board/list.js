document.addEventListener("DOMContentLoaded", function () {
    const filterButtons = document.querySelectorAll("[data-risk-filter]");
    const reportCards = document.querySelectorAll("[data-risk-card]");
    const emptyMessage = document.getElementById("riskFilterEmpty");

    filterButtons.forEach(function (button) {
        button.addEventListener("click", function () {
            const selectedRisk = button.dataset.riskFilter;
            let visibleCount = 0;

            reportCards.forEach(function (card) {
                const shouldShow = selectedRisk === "ALL" || card.dataset.riskCard === selectedRisk;
                card.classList.toggle("d-none", !shouldShow);

                if (shouldShow) {
                    visibleCount += 1;
                }
            });

            filterButtons.forEach(function (filterButton) {
                const isSelected = filterButton === button;
                updateFilterButtonStyle(filterButton, isSelected);
                filterButton.setAttribute("aria-pressed", String(isSelected));
            });

            if (emptyMessage && reportCards.length > 0) {
                emptyMessage.classList.toggle("d-none", visibleCount !== 0);
            }
        });
    });

    function updateFilterButtonStyle(button, isSelected) {
        const risk = button.dataset.riskFilter;
        const buttonStyles = {
            ALL: { active: "btn-jp-mustard", inactive: "btn-outline-secondary" },
            DANGER: { active: "btn-danger", inactive: "btn-outline-danger" },
            WARNING: { active: "btn-warning", inactive: "btn-outline-warning" },
            CAUTION: { active: "btn-secondary", inactive: "btn-outline-secondary" }
        };
        const style = buttonStyles[risk];

        button.classList.remove(style.active, style.inactive, "active");
        button.classList.add(isSelected ? style.active : style.inactive);
    }
});
