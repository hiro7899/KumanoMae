(function () {
    function removePlusCode(address) {
        return String(address || "")
            .replace(/^[A-Z0-9]{4,}\+[A-Z0-9]{2,}\s*/i, "")
            .trim();
    }

    document.addEventListener("DOMContentLoaded", function () {
        document.querySelectorAll(".sighting-address").forEach(function (element) {
            element.textContent = removePlusCode(element.textContent);
        });
    });
}());
