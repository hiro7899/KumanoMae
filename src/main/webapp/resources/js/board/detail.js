(function () {
    function formatDateTime(element) {
        const value = element.textContent.trim();

        if (!value) {
            return;
        }

        const normalizedValue = value.replace("T", " ");
        element.textContent = normalizedValue.replace(
            /^(\d{4}-\d{2}-\d{2} \d{2}:\d{2}):\d{2}$/,
            "$1"
        );
    }

    function showMapMessage(message) {
        const mapElement = document.getElementById("boardDetailMap");

        if (!mapElement) {
            return;
        }

        mapElement.innerHTML = "";
        const messageElement = document.createElement("p");
        messageElement.className = "board-detail-map-message";
        messageElement.textContent = message;
        mapElement.appendChild(messageElement);
    }

    window.initBoardDetailMap = function () {
        const mapElement = document.getElementById("boardDetailMap");

        if (!mapElement || !window.google || !google.maps) {
            showMapMessage("地図を表示できません。");
            return;
        }

        const latitude = Number(mapElement.dataset.latitude);
        const longitude = Number(mapElement.dataset.longitude);

        if (!Number.isFinite(latitude) || !Number.isFinite(longitude)) {
            showMapMessage("位置情報がありません。");
            return;
        }

        const position = { lat: latitude, lng: longitude };
        const detailMap = new google.maps.Map(mapElement, {
            center: position,
            zoom: 15,
            mapTypeControl: false,
            streetViewControl: false,
            fullscreenControl: false
        });

        new google.maps.Marker({
            position: position,
            map: detailMap,
            title: "目撃地点"
        });
    };

    document.addEventListener("DOMContentLoaded", function () {
        document.querySelectorAll(".js-format-datetime").forEach(formatDateTime);
    });
}());
