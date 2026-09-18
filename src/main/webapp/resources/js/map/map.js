/* =====================================================
   map.js
   - map.jsp 화면 동작 담당
   - Google Maps JavaScript API 연동 (DB/Servlet 연동 없음, 테스트 데이터만 사용)
   - 구조 : 테스트 데이터(bearSightings) → 마커 생성 함수 → 지도 화면
   - 나중에 실제 API가 연결되면 bearSightings 를 채우는 부분만
	 서버 응답(JSON)으로 교체하면 되고, 마커/인포윈도우/필터 로직은
	 그대로 재사용할 수 있도록 데이터와 화면 로직을 분리했다.
   =====================================================
   ※ initMap()은 Google Maps 스크립트의 callback=initMap 으로
	 호출되는 전역 함수이므로, DOMContentLoaded로 감싸지 않는다.
   ===================================================== */

/* -----------------------------------------------------
   1. 테스트용 곰 출몰 데이터 (추후 API 응답 JSON으로 교체될 부분)
   - risk : "高" / "中" / "低"
   - region : 필터의 지역 select 옵션과 매칭되는 대분류
   ----------------------------------------------------- */
let bearSightings = [];

/* 危険度(高/中/低) → CSS 클래스명 매핑 (기존 danger/warning/caution 스타일 재사용) */
const RISK_CLASS_MAP = {
	"高": "danger",
	"中": "warning",
	"低": "caution",
	"解除": "clear"
};


/* 기존 필터 체크박스 id → 危険度(高/中/低) 매핑
   (체크박스 자체의 id/디자인은 그대로 유지) */
const RISK_CHECKBOX_MAP = {
	riskDanger: "高",
	riskWarning: "中",
	riskCaution: "低",
};

/* -----------------------------------------------------
   전역 상태 : 지도 인스턴스 / 마커 목록 / 인포윈도우
   ----------------------------------------------------- */
let map;
let markers = [];
let infoWindow;

const RISK_NAME_MAP = {
	DANGER: "高",
	WARNING: "中",
	CAUTION: "低",
	CLEAR: "解除",
	"高": "高",
	"中": "中",
	"低": "低",
	"解除": "解除"
};
function getRegionFromAddress(address) {
	const value = String(address || "");

	const regionKeywords = {
		"北海道": ["北海道", "Hokkaido"],
		"東北": [
			"青森", "岩手", "宮城", "秋田", "山形", "福島",
			"Aomori", "Iwate", "Miyagi", "Akita", "Yamagata", "Fukushima"
		],
		"関東": [
			"茨城", "栃木", "群馬", "埼玉", "千葉", "東京", "神奈川",
			"Ibaraki", "Tochigi", "Gunma", "Saitama", "Chiba", "Tokyo", "Kanagawa"
		],
		"中部": [
			"新潟", "富山", "石川", "福井", "山梨", "長野", "岐阜", "静岡", "愛知",
			"Niigata", "Toyama", "Ishikawa", "Fukui", "Yamanashi",
			"Nagano", "Gifu", "Shizuoka", "Aichi"
		],
		"近畿": [
			"三重", "滋賀", "京都", "大阪", "兵庫", "奈良", "和歌山",
			"Mie", "Shiga", "Kyoto", "Osaka", "Hyogo", "Nara", "Wakayama"
		],
		"中国": [
			"鳥取", "島根", "岡山", "広島", "山口",
			"Tottori", "Shimane", "Okayama", "Hiroshima", "Yamaguchi"
		],
		"四国": [
			"徳島", "香川", "愛媛", "高知",
			"Tokushima", "Kagawa", "Ehime", "Kochi"
		],
		"九州・沖縄": [
			"福岡", "佐賀", "長崎", "熊本", "大分", "宮崎", "鹿児島", "沖縄",
			"Fukuoka", "Saga", "Nagasaki", "Kumamoto", "Oita",
			"Miyazaki", "Kagoshima", "Okinawa"
		]
	};

	for (const region in regionKeywords) {
		if (regionKeywords[region].some(function(keyword) {
			return value.includes(keyword);
		})) {
			return region;
		}
	}

	return "全国";
}
function normalizeEventDate(eventDate) {
	if (!eventDate || !eventDate.date) {
		return "";
	}

	const date = eventDate.date;

	return String(date.year)
		+ "-"
		+ String(date.month).padStart(2, "0")
		+ "-"
		+ String(date.day).padStart(2, "0");
}

async function fetchMarkers() {
	const contextPath = document.body.dataset.contextPath || "";

	try {
		const response = await fetch(contextPath + "/api/map/markers", {
			headers: {
				"Accept": "application/json"
			}
		});

		if (!response.ok) {
			throw new Error("マーカー情報の取得に失敗しました。");
		}

		const markerResponse = await response.json();

		const markersFromServer = Array.isArray(markerResponse.markers)
			? markerResponse.markers
			: [];

		bearSightings = markersFromServer
			.filter(function(item) {
				return Number.isFinite(Number(item.latitude))
					&& Number.isFinite(Number(item.longitude));
			})
			.map(function(item) {
				return {
					id: item.targetId,
					lat: Number(item.latitude),
					lng: Number(item.longitude),
					area: item.address || item.title || "住所情報なし",
					region: getRegionFromAddress(item.address),
					date: normalizeEventDate(item.eventDate),
					risk: RISK_NAME_MAP[item.displayRisk] || "低",
					content: item.title || "目撃情報"
				};
			});

		loadMarkers(bearSightings);

	} catch (error) {
		console.error(error);
		const recentList = document.getElementById("recentList");

		if (recentList) {
			recentList.innerHTML =
				"<li>目撃情報を読み込めませんでした。</li>";
		}
	}
}

/* -----------------------------------------------------
   2. 지도 초기화 (Google Maps 스크립트의 callback으로 호출됨)
   ----------------------------------------------------- */
function initMap() {
	const googleMapEl = document.getElementById("googleMap");

	// 일본 전체가 보이는 초기 위치/줌 레벨
	map = new google.maps.Map(googleMapEl, {
		center: { lat: 36.2048, lng: 138.2529 },
		zoom: 5,
		mapTypeControl: false,
		streetViewControl: false,
		fullscreenControl: false
	});

	infoWindow = new google.maps.InfoWindow();

	renderLegendBearIcons();

	// 지도의 빈 공간을 클릭하면 인포윈도우 닫기
	map.addListener("click", function() {
		infoWindow.close();
	});

	// 초기 화면은 전체 데이터로 마커 표시
	fetchMarkers();
}

/* -----------------------------------------------------
   3. 危険度에 따른 마커 아이콘 생성 함수
   - 지금은 단순 원형 아이콘이지만, 나중에 이미지 아이콘으로
	 바꾸고 싶을 때 이 함수만 수정하면 된다.
   ----------------------------------------------------- */

function createRiskMarkerIcon(displayRisk) {
	const normalizedRisk = String(displayRisk || "").toUpperCase();
	const bearMarkerImages = {
		DANGER: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIIAAABaCAYAAAB0bo6/AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAP3SURBVHhe7dZbkuMqEEXRGtEdQA/7TrA6TFsE3gfxFkgmT8T6SUFWgvmon9/f3x9jpGD2JAWzJymYPUnB7EkKZk9SMHuSgtmTFMyepGD2JAWzJymYPUnB7EkKxmkN+zyGFDZUlf///OdU7OffuyUpbCCZ44ceAeEctyKFmypNyZ4f/mBXi8zD8y0nhRtijlrs2xG3lz/IaifheZeQws34y+KlPlkkPPd0UrgRF17iN0F4/qmkcBMuvLhvEwnvYRop3IALL+2bIbyPKaRwAy68rG+H8E4uJ4UbkEvahT2ET3JBO1n1GKSwmFzMjhDe0SWksJA7NC9lV1s/BF7G7mY+BiksIpdg/pn1GKSwgAsvwPyzw0PwB+ThzadvfAiMPYICx11dSQoX8uFBTVoQ3ukwUriIPYAOX/UQeDhT5xseghzK1LOHYJwgvN8hpHABOZRpc+VjkMJgLjyQafPoh8DDmD5PfAhuYB7E9AnC++4ihUFceAjT73EPgQcwYzzpIcjwZpynPAQXDm/GecxD4OBmLIT330wKHdxgHNyMhfA3aCaFDjK0Ge+KR/AihQ4ytBnv9g+BA5tr2EMwzu0fwmsyDm3Gs4dgHHsIxrGHYJwnPAT7h3GCRzyE13Qc3IxlD8F4VzwGKXSSoc14CH+DJlLoJEM/3XGuMFyzAsLfoZoUOsnAM4UXw28tUuHaFRD+FlWk0EmGnSkMv9UKwjO6c474GyNk5iwmhR4ccrYw/FYriJzzzYd7ZwrC+apIoYMMOVsYfqsRhGckH/aYqXDWJCl0kAFnC9I1D/qUcGGfWSpnjZJCBxkwJxeuz3mneR70CXuVcGGvGRpmFVLoIAOmROL7HOGelCBN82R6lXJhv6s1zvpBCp1kSEK43/d5hXtTYj25plSsVwUX9rxSx6yeFDr5cNhg4CPc+9GHe3PYk99LFc6X4sK+pVr2d87rSGGQXLhe9vGwKUF8L64pFeuVcRr2LhGk+AzH+h5SGCgWriG3hgfNOevPdSXOep3wYZ8Wrf3e4WxVpLCQOwwPmRPkoxfXlTrpF+PC/T3C8FvKO5yvihQWqT58cAG8hKZemZ4xXX+HwvBbShDOV0UKi1RdANLUIybSM0X2twrDbzlBOF8VKSxSfAmI3891LSJ9U2R/C4bfU4JwtmpSWMSHhz05+Ct+L9e1iPTNcWGfGmfhupggnKuJFBYqDfdU/4NJJ71L+LBnSiQ15w/DeZpJ4QZSkbW85FqZ/iV609KLM3STwsPID1vq2H/B5ZaEe5aTwsO48EfOQdhzS1J4IBf+2DEI+2xNCg9VE+41X/QQDrlwvXmTgtmTFMyepGD2JAWzJymYPUnB7EkKZk9/AYTSSlYgomLuAAAAAElFTkSuQmCC",
		WARNING: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIIAAABaCAYAAAB0bo6/AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAP3SURBVHhe7dZbjuQqEEXRmsmdv9SzugOpVtJpRO6DeRvsJI60fsIQFZB81M/v7++PMVIwe5KC2ZMUzJ6kYPYkBbMnKZg9ScHsSQpmT1Iwe5KC2ZMUzJ6kYPYkBeO0hn0eQwobqsr/f/5zKvbz792SFDaQzPFDj4BwjluRwk2VpmTPD3+wq0Xm4fmWk8INMUct9u2I28sfZLWT8LxLSOFm/GXxUp8sEp57OinciAsv8ZsgPP9UUrgJF17ct4mE9zCNFG7AhZf2zRDexxRSuAEXXta3Q3gnl5PCDcgl7cIewie5oJ2segxSWEwuZkcI7+gSUljIHZqXsqutHwIvY3czH4MUFpFLMP/MegxSWMCFF2D+2eEh+APy8ObTNz4Exh5BgeOuriSFC/nwoCYtCO90GClcxB5Ah696CDycqfMND0EOZerZQzBOEN7vEFK4gBzKtLnyMUhhMBceyLR59EPgYUyfJz4ENzAPYvoE4X13kcIgLjyE6fe4h8ADmDGe9BBkeDPOUx6CC4c34zzmIXBwMxbC+28mhQ5uMA5uxkL4GzSTQgcZ2ox3xSN4kUIHGdqMd/uHwIHNNewhGOf2D+E1GYc249lDMI49BOPYQzDOEx6C/cM4wSMewms6Dm7GsodgvCsegxQ6ydBmPIS/QRMpdJKhn+44VxiuWQHh71BNCp1k4JnCi+G3Fqlw7QoIf4sqUugkw84Uht9qBeEZ3TlH/I0RMnMWk0IPDjlbGH6rFUTO+ebDvTMF4XxVpNBBhpwtDL/VCMIzkg97zFQ4a5IUOsiAswXpmgd9SriwzyyVs0ZJoYMMmJML1+e80zwP+oS9Sriw1wwNswopdJABUyLxfY5wT0qQpnkyvUq5sN/VGmf9IIVOMiQh3O/7vMK9KbGeXFMq1quCC3teqWNWTwqdfDhsMPAR7v3ow7057MnvpQrnS3Fh31It+zvndaQwSC5cL/t42JQgvhfXlIr1yjgNe5cIUnyGY30PKQwUC9eQW8OD5pz157oSZ71O+LBPi9Z+73C2KlJYyB2Gh8wJ8tGL60qd9Itx4f4eYfgt5R3OV0UKi1QfPrgAXkJTr0zPmK6/Q2H4LSUI56sihUWqLgBp6hET6Zki+1uF4becIJyvihQWKb4ExO/nuhaRvimyvwXD7ylBOFs1KSziw8OeHPwVv5frWkT65riwT42zcF1MEM7VRAoLlYZ7qv/BpJPeJXzYMyWSmvOH4TzNpHADqchaXnKtTP8SvWnpxRm6SeFh5Ictdey/4HJLwj3LSeFhXPgj5yDsuSUpPJALf+wYhH22JoWHqgn3mi96CIdcuN68ScHsSQpmT1Iwe5KC2ZMUzJ6kYPYkBbOnv6McYNQLMsIBAAAAAElFTkSuQmCC",
		CAUTION: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIIAAABaCAYAAAB0bo6/AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAP3SURBVHhe7dZNkuMqEIXR2v8S3vZ6DW9cHaYtAn8X8S+QTN6IM0lBVoIZ1M/v7++PMVIwe5KC2ZMUzJ6kYPYkBbMnKZg9ScHsSQpmT1Iwe5KC2ZMUzJ6kYPYkBeO0hn0eQwobqsr/f/5zKvbz792SFDaQzPFDj4BwjluRwk2VpmTPD3+wq0Xm4fmWk8INMUct9u2I28sfZLWT8LxLSOFm/GXxUp8sEp57OinciAsv8ZsgPP9UUrgJF17ct4mE9zCNFG7AhZf2zRDexxRSuAEXXta3Q3gnl5PCDcgl7cIewie5oJ2segxSWEwuZkcI7+gSUljIHZqXsqutHwIvY3czH4MUFpFLMP/MegxSWMCFF2D+2eEh+APy8ObTNz4Exh5BgeOuriSFC/nwoCYtCO90GClcxB5Ah696CDycqfMND0EOZerZQzBOEN7vEFK4gBzKtLnyMUhhMBceyLR59EPgYUyfJz4ENzAPYvoE4X13kcIgLjyE6fe4h8ADmDGe9BBkeDPOUx6CC4c34zzmIXBwMxbC+28mhQ5uMA5uxkL4GzSTQgcZ2ox3xSN4kUIHGdqMd/uHwIHNNewhGOf2D+E1GYc249lDMI49BOPYQzDOEx6C/cM4wSMewms6Dm7GsodgvCsegxQ6ydBmPIS/QRMpdJKhn+44VxiuWQHh71BNCp1k4JnCi+G3Fqlw7QoIf4sqUugkw84Uht9qBeEZ3TlH/I0RMnMWk0IPDjlbGH6rFUTO+ebDvTMF4XxVpNBBhpwtDL/VCMIzkg97zFQ4a5IUOsiAswXpmgd9SriwzyyVs0ZJoYMMmJML1+e80zwP+oS9Sriw1wwNswopdJABUyLxfY5wT0qQpnkyvUq5sN/VGmf9IIVOMiQh3O/7vMK9KbGeXFMq1quCC3teqWNWTwqdfDhsMPAR7v3ow7057MnvpQrnS3Fh31It+zvndaQwSC5cL/t42JQgvhfXlIr1yjgNe5cIUnyGY30PKQwUC9eQW8OD5pz157oSZ71O+LBPi9Z+73C2KlJYyB2Gh8wJ8tGL60qd9Itx4f4eYfgt5R3OV0UKi1QfPrgAXkJTr0zPmK6/Q2H4LSUI56sihUWqLgBp6hET6Zki+1uF4becIJyvihQWKb4ExO/nuhaRvimyvwXD7ylBOFs1KSziw8OeHPwVv5frWkT65riwT42zcF1MEM7VRAoLlYZ7qv/BpJPeJXzYMyWSmvOH4TzNpHADqchaXnKtTP8SvWnpxRm6SeFh5Ictdey/4HJLwj3LSeFhXPgj5yDsuSUpPJALf+wYhH22JoWHqgn3mi96CIdcuN68ScHsSQpmT1Iwe5KC2ZMUzJ6kYPYkBbOnvwyTvN/Xsk40AAAAAElFTkSuQmCC",
		CLEAR: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIIAAABaCAYAAAB0bo6/AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAP3SURBVHhe7dZNkuMqEIXR2v8S3qhHb5vVYdoi8HcR/wLJ5I04kxRkJZhB/fz+/v4YIwWzJymYPUnB7EkKZk9SMHuSgtmTFMyepGD2JAWzJymYPUnB7EkKZk9SME5r2OcxpLChqvz353+nYj//3i1JYQPJHD/0CAjnuBUp3FRpSvb88Ae7WmQenm85KdwQc9Ri3464vfxBVjsJz7uEFG7GXxYv9cki4bmnk8KNuPASvwnC808lhZtw4cV9m0h4D9NI4QZceGnfDOF9TCGFG3DhZX07hHdyOSncgFzSLuwhfJIL2smqxyCFxeRidoTwji4hhYXcoXkpu9r6IfAydjfzMUhhEbkE88+sxyCFBVx4AeafHR6CPyAPbz5940Ng7BEUOO7qSlK4kA8PatKC8E6HkcJF7AF0+KqHwMOZOt/wEORQpp49BOME4f0OIYULyKFMmysfgxQGc+GBTJtHPwQexvR54kNwA/Mgpk8Q3ncXKQziwkOYfo97CDyAGeNJD0GGN+M85SG4cHgzzmMeAgc3YyG8/2ZS6OAG4+BmLIS/QTMpdJChzXhXPIIXKXSQoc14t38IHNhcwx6CcW7/EF6TcWgznj0E49hDMI49BOM84SHYP4wTPOIhvKbj4GYsewjGu+IxSKGTDG3GQ/gbNJFCJxn66Y5zheGaFRD+DtWk0EkGnim8GH5rkQrXroDwt6gihU4y7Exh+K1WEJ7RnXPE3xghM2cxKfTgkLOF4bdaQeScbz7cO1MQzldFCh1kyNnC8FuNIDwj+bDHTIWzJkmhgww4W5CuedCnhAv7zFI5a5QUOsiAOblwfc47zfOgT9irhAt7zdAwq5BCBxkwJRLf5wj3pARpmifTq5QL+12tcdYPUugkQxLC/b7PK9ybEuvJNaVivSq4sOeVOmb1pNDJh8MGAx/h3o8+3JvDnvxeqnC+FBf2LdWyv3NeRwqD5ML1so+HTQnie3FNqVivjNOwd4kgxWc41veQwkCxcA25NTxozll/ritx1uuED/u0aO33DmerIoWF3GF4yJwgH724rtRJvxgX7u8Rht9S3uF8VaSwSPXhgwvgJTT1yvSM6fo7FIbfUoJwvipSWKTqApCmHjGRnimyv1UYfssJwvmqSGGR4ktA/H6uaxHpmyL7WzD8nhKEs1WTwiI+POzJwV/xe7muRaRvjgv71DgL18UE4VxNpLBQabin+h9MOuldwoc9UyKpOX8YztNMCjeQiqzlJdfK9C/Rm5ZenKGbFB5GfthSx/4LLrck3LOcFB7GhT9yDsKeW5LCA7nwx45B2GdrUniomnCv+aKHcMiF682bFMyepGD2JAWzJymYPUnB7EkKZk9SMHv6C25nyUVj7iuQAAAAAElFTkSuQmCC"
	};

	return {
		url: bearMarkerImages[normalizedRisk]
			|| bearMarkerImages.DANGER,
		scaledSize: new google.maps.Size(42, 35),
		anchor: new google.maps.Point(21, 29)
	};
}

function getMarkerIcon(risk) {
	const displayRiskMap = {
		"高": "DANGER",
		"中": "WARNING",
		"低": "CAUTION",
		"解除": "CLEAR",
		DANGER: "DANGER",
		WARNING: "WARNING",
		CAUTION: "CAUTION",
		CLEAR: "CLEAR"
	};

	return createRiskMarkerIcon(displayRiskMap[risk] || "CAUTION");
}

function renderLegendBearIcons() {
	document.querySelectorAll(".legend-bear").forEach(function(image) {
		image.src = getMarkerIcon(image.dataset.risk).url;
	});
}

/* -----------------------------------------------------
   4. 마커 1개 생성
   ----------------------------------------------------- */
function createMarker(sighting) {
	const marker = new google.maps.Marker({
		position: { lat: sighting.lat, lng: sighting.lng },
		map: map,
		icon: getMarkerIcon(sighting.risk),
		title: sighting.area
	});

	marker.addListener("click", function() {
		infoWindow.setContent(createInfoWindowContent(sighting));
		infoWindow.open(map, marker);
	});

	markers.push(marker);
	return marker;
}

/* -----------------------------------------------------
   5. 인포윈도우에 표시할 HTML 콘텐츠 생성
   - 出没地域 / 出没日時 / 危険度 를 표시한다.
   ----------------------------------------------------- */
function createInfoWindowContent(sighting) {
	const riskClass = RISK_CLASS_MAP[sighting.risk] || "caution";

	return (
		'<div class="gmap-infowindow">' +
		'<span class="info-badge ' + riskClass + '">' + sighting.risk + '</span>' +
		'<p class="info-region">出没地域：' + sighting.area + '</p>' +
		'<p class="info-date">出没日時：' + formatDateJP(sighting.date) + '</p>' +
		'<p class="info-content">危険度：' + sighting.risk + '</p>' +
		'</div>'
	);
}

/* "2026-08-20" → "2026年8月20日" 형식으로 변환 */
function formatDateJP(dateStr) {
	const parts = dateStr.split("-");
	const year = parts[0];
	const month = parseInt(parts[1], 10);
	const day = parseInt(parts[2], 10);
	return year + "年" + month + "月" + day + "日";
}

/* -----------------------------------------------------
   6. 마커 로드 / 전체 삭제
   ----------------------------------------------------- */
function loadMarkers(sightingList) {
	clearMarkers();

	sightingList.forEach(function(sighting) {
		createMarker(sighting);
	});

	renderRecentList(sightingList);
}

function clearMarkers() {
	markers.forEach(function(marker) {
		marker.setMap(null);
	});
	markers = [];

	if (infoWindow) {
		infoWindow.close();
	}
}

/* -----------------------------------------------------
   7. 지도 아래 「最新の出没情報」목록 생성
   ----------------------------------------------------- */
function renderRecentList(sightingList) {
	const recentList = document.getElementById("recentList");
	if (!recentList) return;

	recentList.innerHTML = "";

	sightingList.forEach(function(sighting) {
		const riskClass = RISK_CLASS_MAP[sighting.risk] || "caution";

		const li = document.createElement("li");
		li.className = "bear-item";
		li.innerHTML =
			'<span class="bear-item-badge ' + riskClass + '">' + sighting.risk + '</span>' +
			'<div class="bear-item-body">' +
			'<p class="bear-item-region">' + sighting.area + '</p>' +
			'<p class="bear-item-meta">' + formatDateJP(sighting.date) + '</p>' +
			'<p class="bear-item-content">' + sighting.content + '</p>' +
			'</div>' +
			'<button type="button" class="bear-item-btn" data-board-id="' + sighting.id + '">詳細を見る</button>';

		const detailButton = li.querySelector(".bear-item-btn");

		detailButton.addEventListener("click", function() {
			const contextPath = document.body.dataset.contextPath || "";
			const boardId = detailButton.dataset.boardId;

			location.href = contextPath
				+ "/board/detail?boardId="
				+ encodeURIComponent(boardId);
		});

		recentList.appendChild(li);
	});
}

/* -----------------------------------------------------
   8. 필터링 로직
   - 지역 / 기간 / 危険度 를 기준으로 bearSightings 를 걸러낸다.
   - 실제 검색 API 호출이 아니라, 테스트 데이터를 화면에서만
	 걸러서 다시 그리는 화면 동작이다.
   ----------------------------------------------------- */

function toDateInputValue(date) {
	const year = date.getFullYear();
	const month = String(date.getMonth() + 1).padStart(2, "0");
	const day = String(date.getDate()).padStart(2, "0");

	return year + "-" + month + "-" + day;
}

function setDefaultDateRange() {
	const startDateInput = document.getElementById("startDate");
	const endDateInput = document.getElementById("endDate");

	if (!startDateInput || !endDateInput) {
		return;
	}

	const today = new Date();
	const firstDayOfMonth = new Date(
		today.getFullYear(),
		today.getMonth(),
		1
	);

	const todayValue = toDateInputValue(today);
	const firstDayValue = toDateInputValue(firstDayOfMonth);

	// 기본값: 이번 달 1일 ~ 오늘
	startDateInput.value = firstDayValue;
	endDateInput.value = todayValue;

	// 오늘 이후 날짜 선택 금지
	startDateInput.max = todayValue;
	endDateInput.max = todayValue;

	// 종료일은 시작일보다 이전으로 선택 불가
	endDateInput.min = firstDayValue;
}

function filterSightings() {
	const areaSelect = document.getElementById("areaSelect");
	const startDateInput = document.getElementById("startDate");
	const endDateInput = document.getElementById("endDate");

	const selectedArea = areaSelect ? areaSelect.value : "全国";
	const startDate = startDateInput ? startDateInput.value : "";
	const endDate = endDateInput ? endDateInput.value : "";

	// 현재 체크되어 있는 危険度(高/中/低) 목록
	const checkedRisks = Object.keys(RISK_CHECKBOX_MAP)
		.filter(function(checkboxId) {
			const checkbox = document.getElementById(checkboxId);
			return checkbox ? checkbox.checked : false;
		})
		.map(function(checkboxId) {
			return RISK_CHECKBOX_MAP[checkboxId];
		});

	checkedRisks.push("解除");

	return bearSightings.filter(function(sighting) {
		// 지역 필터
		if (selectedArea !== "全国" && sighting.region !== selectedArea) {
			return false;
		}

		// 기간 필터
		if (startDate && sighting.date < startDate) {
			return false;
		}
		if (endDate && sighting.date > endDate) {
			return false;
		}

		// 危険度 필터
		if (checkedRisks.indexOf(sighting.risk) === -1) {
			return false;
		}

		return true;
	});
}

function applyFilters() {
	const filtered = filterSightings();
	loadMarkers(filtered);
}

/* -----------------------------------------------------
   9. 필터 초기화
   - 지역=全国, 기간=전체 테스트 데이터 범위, 危険度=전부 체크
	 상태로 되돌리고 전체 마커를 다시 표시한다.
   ----------------------------------------------------- */
function resetFilters() {
	const areaSelect = document.getElementById("areaSelect");
	const startDateInput = document.getElementById("startDate");
	const endDateInput = document.getElementById("endDate");

	if (areaSelect) areaSelect.value = "全国";
	setDefaultDateRange();

	Object.keys(RISK_CHECKBOX_MAP).forEach(function(checkboxId) {
		const checkbox = document.getElementById(checkboxId);
		if (checkbox) checkbox.checked = true;
	});

	loadMarkers(bearSightings);
}

/* -----------------------------------------------------
   10. 버튼 이벤트 연결
   - 지도/마커와 무관하게 버튼 자체는 페이지 로드 시 이미 존재하므로
	 DOMContentLoaded 시점에 연결해도 안전하다.
   ----------------------------------------------------- */
document.addEventListener("DOMContentLoaded", function() {
	setDefaultDateRange();

	const searchBtn = document.getElementById("searchBtn");
	const resetBtn = document.getElementById("resetFilterBtn");

	if (searchBtn) {
		searchBtn.addEventListener("click", applyFilters);
	}

	if (resetBtn) {
		resetBtn.addEventListener("click", resetFilters);
	}
});