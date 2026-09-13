document.addEventListener("DOMContentLoaded", function () {
    const riskFilterButtons = document.querySelectorAll("[data-risk-filter]");
    const clearFilterButtons = document.querySelectorAll("[data-clear-filter]");
    const reportCards = document.querySelectorAll("[data-risk-card]");
    const emptyMessage = document.getElementById("riskFilterEmpty");
    let selectedRisk = "ALL";
    let selectedClear = "ALL";

    riskFilterButtons.forEach(function (button) {
        button.addEventListener("click", function () {
            selectedRisk = button.dataset.riskFilter;
            updateFilterButtons(riskFilterButtons, button, updateRiskFilterButtonStyle);
            applyFilters();
        });
    });

    clearFilterButtons.forEach(function (button) {
        button.addEventListener("click", function () {
            selectedClear = button.dataset.clearFilter;
            updateFilterButtons(clearFilterButtons, button, updateClearFilterButtonStyle);
            applyFilters();
        });
    });

    function applyFilters() {
        let visibleCount = 0;

        reportCards.forEach(function (card) {
            const riskMatches = selectedRisk === "ALL" || card.dataset.riskCard === selectedRisk;
            const clearMatches = selectedClear === "ALL"
                || (selectedClear === "ACTIVE" && card.dataset.clearYn !== "Y")
                || (selectedClear === "CLEARED" && card.dataset.clearYn === "Y");
            const shouldShow = riskMatches && clearMatches;
            card.classList.toggle("risk-filter-hidden", !shouldShow);

            if (shouldShow) {
                visibleCount += 1;
            }
        });

        if (emptyMessage && reportCards.length > 0) {
            emptyMessage.classList.toggle("d-none", visibleCount !== 0);
        }
        if (window.refreshBoardPagination) window.refreshBoardPagination();
    }

    function updateFilterButtons(buttons, selectedButton, updateStyle) {
        buttons.forEach(function (button) {
            const isSelected = button === selectedButton;
            updateStyle(button, isSelected);
            button.setAttribute("aria-pressed", String(isSelected));
        });
    }

    function updateRiskFilterButtonStyle(button, isSelected) {
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

    function updateClearFilterButtonStyle(button, isSelected) {
        const state = button.dataset.clearFilter;
        const buttonStyles = {
            ALL: { active: "btn-jp-mustard", inactive: "btn-outline-secondary" },
            ACTIVE: { active: "btn-dark", inactive: "btn-outline-dark" },
            CLEARED: { active: "btn-secondary", inactive: "btn-outline-secondary" }
        };
        const style = buttonStyles[state];

        button.classList.remove(style.active, style.inactive, "active");
        button.classList.add(isSelected ? style.active : style.inactive);
    }

    applyFilters();
});
