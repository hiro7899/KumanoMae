/* =====================================================
   index.js
   - index.jsp 화면 동작만 담당 (DB/API/실제 검색 기능 없음)
   - 뉴스 데이터는 resources/js/board/news-data.js에서 관리한다.
   - "報告する" 버튼 클릭 시 로그인 여부 확인 로직은
   index.jsp의 checkLoginAndReport() 함수(인라인 스크립트)가
   담당하므로, 여기서는 더 이상 별도 처리하지 않는다.
   ===================================================== */

document.addEventListener("DOMContentLoaded", function() {

	/* -----------------------------------------------
	   0. 시작 화면 이미지 : 3초 표시 후 메인페이지 노출
	   ----------------------------------------------- */
	const splashScreen = document.getElementById("splashScreen");
	const splashStorageKey = "kumanoMaeSplashShownAt";
	const splashInterval = 10 * 60 * 1000;

	if (splashScreen) {
		let shouldShowSplash = true;

		try {
			const lastShownAt = Number(localStorage.getItem(splashStorageKey) || 0);
			shouldShowSplash = !lastShownAt || Date.now() - lastShownAt >= splashInterval;

			if (shouldShowSplash) {
				localStorage.setItem(splashStorageKey, String(Date.now()));
				splashScreen.classList.add("is-visible");
			}
		} catch (error) {
			console.warn("시작 화면 표시 시간 저장에 실패했습니다.", error);
		}

		if (!shouldShowSplash) {
			splashScreen.remove();
		} else {
			window.setTimeout(function() {
				splashScreen.classList.add("is-hiding");
			}, 3000);

			splashScreen.addEventListener("transitionend", function(event) {
				if (event.propertyName === "opacity") {
					splashScreen.remove();
				}
			});
		}
	}

	/* -----------------------------------------------
	   1. 상단 경보 배너 닫기 (X 클릭 시 배너 숨김)
	   ----------------------------------------------- */
	const alertBanner = document.querySelector(".top-alert");
	const alertClose = document.getElementById("alertClose");

		if (alertClose) {
		alertClose.addEventListener("click", function() {
			alertBanner.style.display = "none";
		});
	}



	/* -----------------------------------------------
	   ※ 4. "目撃情報を報告する" / "クマ出没を報告する" 버튼 처리는
		  index.jsp의 checkLoginAndReport() 함수가 onclick으로
		  직접 담당하므로 여기서는 제거함 (중복 실행 방지)
	   ----------------------------------------------- */

	   document.querySelectorAll(".clickable-card[data-card-href]")
	       .forEach(function (card) {
	           card.setAttribute("tabindex", "0");
	           card.setAttribute("role", "link");

	           function moveToDetail() {
	               window.location.href = card.dataset.cardHref;
	           }

	           card.addEventListener("click", moveToDetail);

	           card.addEventListener("keydown", function (event) {
	               if (event.key === "Enter" || event.key === " ") {
	                   event.preventDefault();
	                   moveToDetail();
	               }
	           });
	       });

	   document.querySelectorAll(
	       ".home-community-section .preview-card-thumb"
	   ).forEach(function (image) {
	       image.addEventListener("error", function () {
	           const imageBox = image.closest(".preview-card-image");

	           if (!imageBox || imageBox.dataset.fallbackApplied === "true") {
	               return;
	           }

	           imageBox.dataset.fallbackApplied = "true";
	           image.remove();
	           imageBox.classList.add("preview-card-image-talk");

	           const fallbackIcon = document.createElement("i");
	           fallbackIcon.className = "bi bi-people-fill";
	           fallbackIcon.setAttribute("aria-hidden", "true");
	           imageBox.appendChild(fallbackIcon);
	       });
	   });
	   (function() {
	   			const month = new Date().getMonth() + 1;
	   			const seasonalAlerts = [
	   					{
	   						months : [ 3, 4, 5 ],
	   						icon : "🌸",
	   						message : "春の出没注意期間（3月〜5月）— 冬眠明けのクマが活動を始めます。早朝・夕方の単独行動に注意してください。",
	   						guideMessage : "冬眠明けのクマは食べ物を探して行動範囲を広げます。山菜採りや散策の前に、出没マップと周辺情報を確認しましょう。"
	   					},
	   					{
	   						months : [ 6, 7, 8 ],
	   						icon : "🌿",
	   						message : "夏の出没注意期間（6月〜8月）— 山や河川敷では周囲に注意し、食べ物を放置しないでください。",
	   						guideMessage : "夏は親子グマが行動する時期です。子グマを見かけても近づかず、すぐにその場から離れてください。"
	   					},
	   					{
	   						months : [ 9, 10, 11 ],
	   						icon : "🍂",
	   						message : "秋の入山特別警戒期間（9月〜11月）— 冬眠前のクマの活動が活発化しています。入山前に出没情報を確認してください。",
	   						guideMessage : "冬眠前のクマは餌を求めて活動範囲を広げます。早朝・夕方の入山は特に注意し、食べ物やゴミを屋外に放置しないでください。"
	   					},
	   					{
	   						months : [ 12, 1, 2 ],
	   						icon : "❄️",
	   						message : "冬季安全確認期間（12月〜2月）— 冬でも出没情報を確認し、山間部では十分注意してください。",
	   						guideMessage : "冬眠しない個体や、冬眠前後に活動するクマがいる場合があります。雪山や山間部へ出かける前にも、最新の出没情報を確認しましょう。"
	   					} ];
	   			const currentAlert = seasonalAlerts.find(function(alert) {
	   				return alert.months.includes(month);
	   			});

	   			document.getElementById("seasonAlertIcon").textContent = currentAlert.icon;
	   			document.getElementById("seasonAlertText").textContent = currentAlert.message;
	   			document.getElementById("seasonGuideIcon").textContent = currentAlert.icon;
	   			document.getElementById("seasonGuideText").textContent = currentAlert.guideMessage;
			    }());

			    document.getElementById("areaSearchBtn")
			        ?.addEventListener("click", searchArea);

			    document.getElementById("reportSightingButton")
			        ?.addEventListener("click", checkLoginAndReport);
			});
let map;
		let geocoder;
		let markerInfoWindow;
		let allSightings = [];
		let sightingMarkers = [];
		const defaultMapCenter = {
			lat : 36.2,
			lng : 138.25
		};
		const defaultMapZoom = 5.5;

		// 1. Google Map 초기화 함수 (콜백 함수)
		window.initMap = function initMap() {
			// 기본 위치: 홋카이도/일본 중심부 부근
			map = new google.maps.Map(document.getElementById("mapContainer"),
					{
						zoom : defaultMapZoom,
						center : defaultMapCenter,
					});

			geocoder = new google.maps.Geocoder();
			markerInfoWindow = new google.maps.InfoWindow();

			renderLegendBearIcons();
			loadSightingMarkers();
			};

		// 2. 등록된 목격 정보 조회
		async function loadSightingMarkers() {
			const contextPath = document.body.dataset.contextPath || "";
			const mapStatus = document.getElementById("mapStatus");

			if (mapStatus) {
				mapStatus.hidden = false;
				mapStatus.className = "map-status is-loading";
				mapStatus.innerHTML = '<i class="bi bi-arrow-repeat map-status-icon" aria-hidden="true"></i>'
						+ '<span>目撃情報を読み込んでいます...</span>';
			}

			try {
				const response = await fetch(contextPath + "/api/map/markers", {
					headers : {
						"Accept" : "application/json"
					}
				});

				if (!response.ok) {
					throw new Error("マーカー情報の取得に失敗しました。");
				}

				const markerResponse = await response.json();
				allSightings = Array.isArray(markerResponse.markers) ? markerResponse.markers
						: [];
				applyMapFilters();
			} catch (error) {
				console.error(error);
				if (mapStatus) {
					mapStatus.hidden = false;
					mapStatus.className = "map-status is-error";
					mapStatus.innerHTML = '<i class="bi bi-exclamation-triangle" aria-hidden="true"></i>'
							+ '<span>目撃情報を読み込めませんでした。</span>'
							+ '<button type="button" class="btn btn-sm btn-jp-outline" onclick="loadSightingMarkers()">再試行</button>';
				}
			}
		}

		// 3. 선택한 위험도·기간 조건으로 지도 마커를 다시 표시
		function applyMapFilters() {
			if (!map)
				return;

			const selectedRisk = document
					.querySelector("input[name='riskFilter']:checked").id;
			const checkedRisks = selectedRisk === "riskAll" ? [ "DANGER",
					"WARNING", "CAUTION", "CLEAR" ] : [ {
				riskDanger : "DANGER",
				riskWarning : "WARNING",
				riskCaution : "CAUTION",
				riskClear : "CLEAR"
			}[selectedRisk] ];
			const periodDays = Number(document.getElementById("periodSelect").value);
			const cutoff = Number.isFinite(periodDays) && periodDays > 0 ? new Date(
					Date.now() - periodDays * 24 * 60 * 60 * 1000)
					: null;

			const filteredSightings = allSightings
					.filter(function(sighting) {
						if (checkedRisks.indexOf(normalizeRisk(
								sighting.displayRisk, sighting.clearYn)) === -1) {
							return false;
						}

						if (!cutoff)
							return true;
						const eventDate = new Date(sighting.eventDate
								|| sighting.regDate);
						return Number.isNaN(eventDate.getTime())
								|| eventDate >= cutoff;
					});

			renderSightingMarkers(filteredSightings);
		}

		function renderSightingMarkers(sightings) {
			sightingMarkers.forEach(function(marker) {
				marker.setMap(null);
			});
			sightingMarkers = [];

			const riskCounts = {
				DANGER : 0,
				WARNING : 0,
				CAUTION : 0,
				CLEAR : 0
			};

			sightings.forEach(function(sighting) {
				const latitude = Number(sighting.latitude);
				const longitude = Number(sighting.longitude);

				if (!Number.isFinite(latitude) || !Number.isFinite(longitude)) {
					return;
				}

				const risk = normalizeRisk(sighting.displayRisk,
						sighting.clearYn);
				riskCounts[risk]++;

				const position = {
					lat : latitude,
					lng : longitude
				};
				const marker = new google.maps.Marker({
					map : map,
					position : position,
					title : sighting.title || "クマ目撃情報",
					icon : createRiskMarkerIcon(risk)
				});

				marker.addListener("click", function() {
					markerInfoWindow
							.setContent(createMarkerInfoContent(sighting));
					markerInfoWindow.open({
						map : map,
						anchor : marker
					});
				});

				sightingMarkers.push(marker);
			});

			updateRiskCounts(riskCounts);

			const mapStatus = document.getElementById("mapStatus");
			if (mapStatus) {
				if (sightingMarkers.length === 0) {
					mapStatus.hidden = false;
					mapStatus.className = "map-status is-empty";
					mapStatus.innerHTML = '<i class="bi bi-geo-alt" aria-hidden="true"></i>'
							+ '<span>条件に一致する目撃情報はありません。</span>';
				} else {
					mapStatus.hidden = true;
				}
			}
		}

		function createRiskMarkerIcon(displayRisk) {
			const riskColors = {
				DANGER : "#b23a2e",
				WARNING : "#e3ac1f",
				CAUTION : "#f5e39a",
				CLEAR : "#9aa0a6"
			};
			const normalizedRisk = String(displayRisk || "").toUpperCase();
			const fillColor = riskColors[normalizedRisk] || "#b23a2e";
			const bearMarkerImages = {
				DANGER : "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIIAAABaCAYAAAB0bo6/AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAP3SURBVHhe7dZbkuMqEEXRGtEdQA/7TrA6TFsE3gfxFkgmT8T6SUFWgvmon9/f3x9jpGD2JAWzJymYPUnB7EkKZk9SMHuSgtmTFMyepGD2JAWzJymYPUnB7EkKxmkN+zyGFDZUlf///OdU7OffuyUpbCCZ44ceAeEctyKFmypNyZ4f/mBXi8zD8y0nhRtijlrs2xG3lz/IaifheZeQws34y+KlPlkkPPd0UrgRF17iN0F4/qmkcBMuvLhvEwnvYRop3IALL+2bIbyPKaRwAy68rG+H8E4uJ4UbkEvahT2ET3JBO1n1GKSwmFzMjhDe0SWksJA7NC9lV1s/BF7G7mY+BiksIpdg/pn1GKSwgAsvwPyzw0PwB+ThzadvfAiMPYICx11dSQoX8uFBTVoQ3ukwUriIPYAOX/UQeDhT5xseghzK1LOHYJwgvN8hpHABOZRpc+VjkMJgLjyQafPoh8DDmD5PfAhuYB7E9AnC++4ihUFceAjT73EPgQcwYzzpIcjwZpynPAQXDm/GecxD4OBmLIT330wKHdxgHNyMhfA3aCaFDjK0Ge+KR/AihQ4ytBnv9g+BA5tr2EMwzu0fwmsyDm3Gs4dgHHsIxrGHYJwnPAT7h3GCRzyE13Qc3IxlD8F4VzwGKXSSoc14CH+DJlLoJEM/3XGuMFyzAsLfoZoUOsnAM4UXw28tUuHaFRD+FlWk0EmGnSkMv9UKwjO6c474GyNk5iwmhR4ccrYw/FYriJzzzYd7ZwrC+apIoYMMOVsYfqsRhGckH/aYqXDWJCl0kAFnC9I1D/qUcGGfWSpnjZJCBxkwJxeuz3mneR70CXuVcGGvGRpmFVLoIAOmROL7HOGelCBN82R6lXJhv6s1zvpBCp1kSEK43/d5hXtTYj25plSsVwUX9rxSx6yeFDr5cNhg4CPc+9GHe3PYk99LFc6X4sK+pVr2d87rSGGQXLhe9vGwKUF8L64pFeuVcRr2LhGk+AzH+h5SGCgWriG3hgfNOevPdSXOep3wYZ8Wrf3e4WxVpLCQOwwPmRPkoxfXlTrpF+PC/T3C8FvKO5yvihQWqT58cAG8hKZemZ4xXX+HwvBbShDOV0UKi1RdANLUIybSM0X2twrDbzlBOF8VKSxSfAmI3891LSJ9U2R/C4bfU4JwtmpSWMSHhz05+Ct+L9e1iPTNcWGfGmfhupggnKuJFBYqDfdU/4NJJ71L+LBnSiQ15w/DeZpJ4QZSkbW85FqZ/iV609KLM3STwsPID1vq2H/B5ZaEe5aTwsO48EfOQdhzS1J4IBf+2DEI+2xNCg9VE+41X/QQDrlwvXmTgtmTFMyepGD2JAWzJymYPUnB7EkKZk9/AYTSSlYgomLuAAAAAElFTkSuQmCC",
				WARNING : "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIIAAABaCAYAAAB0bo6/AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAP3SURBVHhe7dZbjuQqEEXRmsmdv9SzugOpVtJpRO6DeRvsJI60fsIQFZB81M/v7++PMVIwe5KC2ZMUzJ6kYPYkBbMnKZg9ScHsSQpmT1Iwe5KC2ZMUzJ6kYPYkBeO0hn0eQwobqsr/f/5zKvbz792SFDaQzPFDj4BwjluRwk2VpmTPD3+wq0Xm4fmWk8INMUct9u2I28sfZLWT8LxLSOFm/GXxUp8sEp57OinciAsv8ZsgPP9UUrgJF17ct4mE9zCNFG7AhZf2zRDexxRSuAEXXta3Q3gnl5PCDcgl7cIewie5oJ2segxSWEwuZkcI7+gSUljIHZqXsqutHwIvY3czH4MUFpFLMP/MegxSWMCFF2D+2eEh+APy8ObTNz4Exh5BgeOuriSFC/nwoCYtCO90GClcxB5Ah696CDycqfMND0EOZerZQzBOEN7vEFK4gBzKtLnyMUhhMBceyLR59EPgYUyfJz4ENzAPYvoE4X13kcIgLjyE6fe4h8ADmDGe9BBkeDPOUx6CC4c34zzmIXBwMxbC+28mhQ5uMA5uxkL4GzSTQgcZ2ox3xSN4kUIHGdqMd/uHwIHNNewhGOf2D+E1GYc249lDMI49BOPYQzDOEx6C/cM4wSMewms6Dm7GsodgvCsegxQ6ydBmPIS/QRMpdJKhn+44VxiuWQHh71BNCp1k4JnCi+G3Fqlw7QoIf4sqUugkw84Uht9qBeEZ3TlH/I0RMnMWk0IPDjlbGH6rFUTO+ebDvTMF4XxVpNBBhpwtDL/VCMIzkg97zFQ4a5IUOsiAswXpmgd9SriwzyyVs0ZJoYMMmJML1+e80zwP+oS9Sriw1wwNswopdJABUyLxfY5wT0qQpnkyvUq5sN/VGmf9IIVOMiQh3O/7vMK9KbGeXFMq1quCC3teqWNWTwqdfDhsMPAR7v3ow7057MnvpQrnS3Fh31It+zvndaQwSC5cL/t42JQgvhfXlIr1yjgNe5cIUnyGY30PKQwUC9eQW8OD5pz157oSZ71O+LBPi9Z+73C2KlJYyB2Gh8wJ8tGL60qd9Itx4f4eYfgt5R3OV0UKi1QfPrgAXkJTr0zPmK6/Q2H4LSUI56sihUWqLgBp6hET6Zki+1uF4becIJyvihQWKb4ExO/nuhaRvimyvwXD7ylBOFs1KSziw8OeHPwVv5frWkT65riwT42zcF1MEM7VRAoLlYZ7qv/BpJPeJXzYMyWSmvOH4TzNpHADqchaXnKtTP8SvWnpxRm6SeFh5Ictdey/4HJLwj3LSeFhXPgj5yDsuSUpPJALf+wYhH22JoWHqgn3mi96CIdcuN68ScHsSQpmT1Iwe5KC2ZMUzJ6kYPYkBbOnv6McYNQLMsIBAAAAAElFTkSuQmCC",
				CAUTION : "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIIAAABaCAYAAAB0bo6/AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAP3SURBVHhe7dZNkuMqEIXR2v8S3vZ6DW9cHaYtAn8X8S+QTN6IM0lBVoIZ1M/v7++PMVIwe5KC2ZMUzJ6kYPYkBbMnKZg9ScHsSQpmT1Iwe5KC2ZMUzJ6kYPYkBeO0hn0eQwobqsr/f/5zKvbz792SFDaQzPFDj4BwjluRwk2VpmTPD3+wq0Xm4fmWk8INMUct9u2I28sfZLWT8LxLSOFm/GXxUp8sEp57OinciAsv8ZsgPP9UUrgJF17ct4mE9zCNFG7AhZf2zRDexxRSuAEXXta3Q3gnl5PCDcgl7cIewie5oJ2segxSWEwuZkcI7+gSUljIHZqXsqutHwIvY3czH4MUFpFLMP/MegxSWMCFF2D+2eEh+APy8ObTNz4Exh5BgeOuriSFC/nwoCYtCO90GClcxB5Ah696CDycqfMND0EOZerZQzBOEN7vEFK4gBzKtLnyMUhhMBceyLR59EPgYUyfJz4ENzAPYvoE4X13kcIgLjyE6fe4h8ADmDGe9BBkeDPOUx6CC4c34zzmIXBwMxbC+28mhQ5uMA5uxkL4GzSTQgcZ2ox3xSN4kUIHGdqMd/uHwIHNNewhGOf2D+E1GYc249lDMI49BOPYQzDOEx6C/cM4wSMewms6Dm7GsodgvCsegxQ6ydBmPIS/QRMpdJKhn+44VxiuWQHh71BNCp1k4JnCi+G3Fqlw7QoIf4sqUugkw84Uht9qBeEZ3TlH/I0RMnMWk0IPDjlbGH6rFUTO+ebDvTMF4XxVpNBBhpwtDL/VCMIzkg97zFQ4a5IUOsiAswXpmgd9SriwzyyVs0ZJoYMMmJML1+e80zwP+oS9Sriw1wwNswopdJABUyLxfY5wT0qQpnkyvUq5sN/VGmf9IIVOMiQh3O/7vMK9KbGeXFMq1quCC3teqWNWTwqdfDhsMPAR7v3ow7057MnvpQrnS3Fh31It+zvndaQwSC5cL/t42JQgvhfXlIr1yjgNe5cIUnyGY30PKQwUC9eQW8OD5pz157oSZ71O+LBPi9Z+73C2KlJYyB2Gh8wJ8tGL60qd9Itx4f4eYfgt5R3OV0UKi1QfPrgAXkJTr0zPmK6/Q2H4LSUI56sihUWqLgBp6hET6Zki+1uF4becIJyvihQWKb4ExO/nuhaRvimyvwXD7ylBOFs1KSziw8OeHPwVv5frWkT65riwT42zcF1MEM7VRAoLlYZ7qv/BpJPeJXzYMyWSmvOH4TzNpHADqchaXnKtTP8SvWnpxRm6SeFh5Ictdey/4HJLwj3LSeFhXPgj5yDsuSUpPJALf+wYhH22JoWHqgn3mi96CIdcuN68ScHsSQpmT1Iwe5KC2ZMUzJ6kYPYkBbOnvwyTvN/Xsk40AAAAAElFTkSuQmCC",
				CLEAR : "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIIAAABaCAYAAAB0bo6/AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAP3SURBVHhe7dZNkuMqEIXR2v8S3qhHb5vVYdoi8HcR/wLJ5I04kxRkJZhB/fz+/v4YIwWzJymYPUnB7EkKZk9SMHuSgtmTFMyepGD2JAWzJymYPUnB7EkKZk9SME5r2OcxpLChqvz353+nYj//3i1JYQPJHD/0CAjnuBUp3FRpSvb88Ae7WmQenm85KdwQc9Ri3464vfxBVjsJz7uEFG7GXxYv9cki4bmnk8KNuPASvwnC808lhZtw4cV9m0h4D9NI4QZceGnfDOF9TCGFG3DhZX07hHdyOSncgFzSLuwhfJIL2smqxyCFxeRidoTwji4hhYXcoXkpu9r6IfAydjfzMUhhEbkE88+sxyCFBVx4AeafHR6CPyAPbz5940Ng7BEUOO7qSlK4kA8PatKC8E6HkcJF7AF0+KqHwMOZOt/wEORQpp49BOME4f0OIYULyKFMmysfgxQGc+GBTJtHPwQexvR54kNwA/Mgpk8Q3ncXKQziwkOYfo97CDyAGeNJD0GGN+M85SG4cHgzzmMeAgc3YyG8/2ZS6OAG4+BmLIS/QTMpdJChzXhXPIIXKXSQoc14t38IHNhcwx6CcW7/EF6TcWgznj0E49hDMI49BOM84SHYP4wTPOIhvKbj4GYsewjGu+IxSKGTDG3GQ/gbNJFCJxn66Y5zheGaFRD+DtWk0EkGnim8GH5rkQrXroDwt6gihU4y7Exh+K1WEJ7RnXPE3xghM2cxKfTgkLOF4bdaQeScbz7cO1MQzldFCh1kyNnC8FuNIDwj+bDHTIWzJkmhgww4W5CuedCnhAv7zFI5a5QUOsiAOblwfc47zfOgT9irhAt7zdAwq5BCBxkwJRLf5wj3pARpmifTq5QL+12tcdYPUugkQxLC/b7PK9ybEuvJNaVivSq4sOeVOmb1pNDJh8MGAx/h3o8+3JvDnvxeqnC+FBf2LdWyv3NeRwqD5ML1so+HTQnie3FNqVivjNOwd4kgxWc41veQwkCxcA25NTxozll/ritx1uuED/u0aO33DmerIoWF3GF4yJwgH724rtRJvxgX7u8Rht9S3uF8VaSwSPXhgwvgJTT1yvSM6fo7FIbfUoJwvipSWKTqApCmHjGRnimyv1UYfssJwvmqSGGR4ktA/H6uaxHpmyL7WzD8nhKEs1WTwiI+POzJwV/xe7muRaRvjgv71DgL18UE4VxNpLBQabin+h9MOuldwoc9UyKpOX8YztNMCjeQiqzlJdfK9C/Rm5ZenKGbFB5GfthSx/4LLrck3LOcFB7GhT9yDsKeW5LCA7nwx45B2GdrUniomnCv+aKHcMiF682bFMyepGD2JAWzJymYPUnB7EkKZk9SMHv6C25nyUVj7iuQAAAAAElFTkSuQmCC"
			};

			return {
				url : bearMarkerImages[normalizedRisk]
						|| bearMarkerImages.DANGER,
				scaledSize : new google.maps.Size(42, 35),
				anchor : new google.maps.Point(21, 29)
			};
		}

		function createMarkerInfoContent(sighting) {
			const contextPath = document.body.dataset.contextPath || "";
			const targetId = Number(sighting.targetId);
			const riskLabel = normalizeRisk(sighting.displayRisk,
					sighting.clearYn);
			const detailLink = Number.isInteger(targetId) ? '<a href="'
					+ contextPath
					+ '/board/detail?boardId='
					+ encodeURIComponent(targetId)
					+ '" '
					+ 'style="display:inline-block; margin-top:9px; color:#1f1f1f; font-size:12px; font-weight:700;">'
					+ '詳細を見る <i class="bi bi-arrow-right"></i></a>'
					: '';

			return '<div style="max-width:240px; padding:4px;">'
					+ '<strong style="display:block; margin-bottom:6px;">'
					+ escapeHtml(sighting.title || "クマ目撃情報")
					+ '</strong>'
					+ '<div style="font-size:12px; color:#6b6355;">危険度: '
					+ escapeHtml(riskLabel)
					+ '</div>'
					+ '<div style="font-size:12px; color:#6b6355; margin-top:3px;">'
					+ escapeHtml(sighting.address || "住所情報なし") + '</div>'
					+ detailLink + '</div>';
		}

		function renderLegendBearIcons() {
			document.querySelectorAll(".legend-bear").forEach(function(image) {
				image.src = createRiskMarkerIcon(image.dataset.risk).url;
			});
		}

		function normalizeRisk(displayRisk, clearYn) {
			if (String(clearYn || "").toUpperCase() === "Y")
				return "CLEAR";
			const risk = String(displayRisk || "").toUpperCase();
			if (risk === "DANGER")
				return "DANGER";
			if (risk === "WARNING")
				return "WARNING";
			if (risk === "CLEAR")
				return "CLEAR";
			return "CAUTION";
		}

		function updateRiskCounts(riskCounts) {
			document.getElementById("dangerCount").textContent = riskCounts.DANGER
					+ "件";
			document.getElementById("warningCount").textContent = riskCounts.WARNING
					+ "件";
			document.getElementById("cautionCount").textContent = riskCounts.CAUTION
					+ "件";
			document.getElementById("clearCount").textContent = riskCounts.CLEAR
					+ "件";
		}

		function escapeHtml(value) {
			const element = document.createElement("div");
			element.textContent = String(value);
			return element.innerHTML;
		}

		// 3. 지역 검색 버튼 기능 (Geocoding)
		function searchArea() {
			const address = document.getElementById("areaSearchInput").value
					.trim();
			applyMapFilters();
			if (!address) {
				return;
			}

			geocoder.geocode({
				address : address
			}, function(results, status) {
				if (status === "OK") {
					map.setCenter(results[0].geometry.location);
					map.setZoom(11);
				} else {
					alert("該当する地域が見つかりませんでした。");
				}
			});
		}

		// 엔터키 입력 시 지역 검색 실행
		document.getElementById("areaSearchInput").addEventListener("keypress",
				function(e) {
					if (e.key === 'Enter') {
						searchArea();
					}
				});

		document
				.querySelectorAll(
						"#riskAll, #riskDanger, #riskWarning, #riskCaution, #riskClear, #periodSelect")
				.forEach(function(filterInput) {
					filterInput.addEventListener("change", applyMapFilters);
				});

		// 4. 로그인 판별 후 제보 페이지 이동
		function checkLoginAndReport() {
			const isLogin = document.body.dataset.isLogin === "true";
			const contextPath = document.body.dataset.contextPath;

			if (!isLogin) {
				alert("目撃情報の報告機能は、ログイン後に利用できます。");
				location.href = contextPath + "/login";
			} else {
				location.href = contextPath + "/board/report";
			}
		}
