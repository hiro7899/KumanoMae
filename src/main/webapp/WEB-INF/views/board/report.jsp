<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>目撃情報を報告する - クマ出没マップ</title>

<!-- Bootstrap 5 CDN & Fonts & Bootstrap Icons -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700;900&display=swap"
	rel="stylesheet">

<!-- 프로젝트 CSS (공통 메인 index.css & 제보페이지 전용 report.css) -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/index.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/report.css">

<!-- Google Maps API 스크립트 (callback=initMap 적용) -->
<script src="https://maps.googleapis.com/maps/api/js?key=${googleMapsApiKey}&callback=initMap&libraries=places" async defer></script>
</head>
<body>

	<!-- 공통 상단 헤더 include -->
	<%@ include file="/WEB-INF/views/includes/header.jsp"%>

	<main class="report-container">
		<!-- 타이틀 영역 -->
		<div class="mb-4">
			<p class="hero-eyebrow mb-1">
				<span class="dash">―</span>目撃情報提供
			</p>
			<h2 class="section-title-jp m-0">クマ出没・目撃情報を報告する</h2>
			<p class="text-muted small mt-2">地域の安全のために目撃情報を共有してください。管理者承認後にマップに反映されます。</p>
		</div>

		<!-- 제보 Form 카드 -->
		<div class="card-jp-form">
			<form action="${pageContext.request.contextPath}/board/report"
				method="post" id="reportForm" enctype="multipart/form-data" novalidate>

				<!-- 1. 제보 제목 (TITLE) -->
				<div class="mb-4">
					<label for="title" class="form-label form-label-jp">通報タイトル
						<span class="text-danger">*</span>
					</label> <input type="text"
						class="form-control form-control-lg border-secondary-subtle"
						id="title" name="title" placeholder="例：札幌近郊の登山道でクマを発見">
				</div>

				<!-- 2. 목격 유형 및 위험도 구분 -->
				<div class="mb-4">
					<label class="form-label form-label-jp">目撃・遭遇の状況区分 <span
						class="text-danger">*</span></label>
					<div class="risk-selector">
						<label class="risk-option d-flex align-items-center justify-content-between" for="riskDanger">
							<div>
								<input type="radio" name="riskLevel" id="riskDanger" value="DANGER" checked>
								<span class="fw-bold text-danger"><i class="bi bi-eye-fill me-1"></i> 姿を目撃・撮影 (危険)</span>
							</div>
							<span class="small text-muted">クマの本体を直接目視または撮影した場合</span>
						</label>

						<label class="risk-option d-flex align-items-center justify-content-between" for="riskWarning">
							<div>
								<input type="radio" name="riskLevel" id="riskWarning" value="WARNING">
								<span class="fw-bold text-warning-emphasis"><i class="bi bi-geo-fill me-1"></i> 足跡・痕跡を発見 (警戒)</span>
							</div>
							<span class="small text-muted">足跡、糞、爪痕、食害痕などを発見した場合</span>
						</label>

						<label class="risk-option d-flex align-items-center justify-content-between" for="riskCaution">
							<div>
								<input type="radio" name="riskLevel" id="riskCaution" value="CAUTION">
								<span class="fw-bold text-primary"><i class="bi bi-volume-up-fill me-1"></i> 鳴き声・気配を感知 (注意)</span>
							</div>
							<span class="small text-muted">威嚇音、鳴き声、藪の揺れなど不確実だが気配がある場合</span>
						</label>
					</div>
				</div>

				<!-- 3. 목격 일시 (SIGHTING_DATE) -->
				<div class="mb-4">
					<label for="sightingDate" class="form-label form-label-jp">目撃日時
						<span class="text-danger">*</span>
					</label> <input type="datetime-local"
						class="form-control border-secondary-subtle" id="sightingDate"
						name="sightingDate">
				</div>

				<!-- 4. 위치 선택 및 지도 (LATITUDE, LONGITUDE, ADDRESS) -->
				<div class="mb-4">
					<label class="form-label form-label-jp">目撃位置の指定 <span
						class="text-danger">*</span></label>
					<p class="small text-muted mb-2">マップをクリックして正確な目撃場所を指定してください。</p>

					<!-- Google Maps 영역 (style 높이 지정 필수) -->
					<div id="map" class="map-preview-box mb-2" style="height: 350px; width: 100%;"></div>

					<div class="row g-2">
						<div class="col-md-6">
							<input type="text"
								class="form-control form-control-sm border-secondary-subtle bg-light"
								id="address" name="address" placeholder="自動変換住所" readonly>
						</div>
						<div class="col-md-3">
							<input type="text"
								class="form-control form-control-sm border-secondary-subtle bg-light"
								id="latitude" name="latitude" placeholder="緯度 (Latitude)"
								readonly>
						</div>
						<div class="col-md-3">
							<input type="text"
								class="form-control form-control-sm border-secondary-subtle bg-light"
								id="longitude" name="longitude" placeholder="経度 (Longitude)"
								readonly>
						</div>
					</div>
				</div>

				<!-- 5. 현장 사진 첨부 -->
				<div class="mb-4">
					<label for="imageFile" class="form-label form-label-jp">現場写真の添付</label>
					<input class="form-control border-secondary-subtle" type="file" id="imageFile" name="imageFile" accept="image/*" onchange="previewImage(this)">
					<div class="form-text">クマの姿、足跡、現場の状況が分かる写真があれば添付してください。(JPG, PNG)</div>
					
					<div id="imagePreviewBox" class="image-preview-container">
						<img id="imagePreview" src="#" alt="添付写真プレビュー">
					</div>
				</div>

				<!-- 6. 상황 태그 (SITUATION_TAG) -->
				<div class="mb-4">
					<label class="form-label form-label-jp">状況タグ (複数選択可)</label>
					<div class="d-flex flex-wrap gap-2">
						<input type="checkbox" class="btn-check" id="tag1" value="足跡" onchange="updateTags()">
						<label class="btn btn-outline-dark tag-check-label" for="tag1"># 足跡</label>

						<input type="checkbox" class="btn-check" id="tag2" value="糞" onchange="updateTags()">
						<label class="btn btn-outline-dark tag-check-label" for="tag2"># 糞</label>

						<input type="checkbox" class="btn-check" id="tag3" value="威嚇音" onchange="updateTags()">
						<label class="btn btn-outline-dark tag-check-label" for="tag3"># 威嚇音</label>

						<input type="checkbox" class="btn-check" id="tag4" value="成獣" onchange="updateTags()">
						<label class="btn btn-outline-dark tag-check-label" for="tag4"># 成獣</label>

						<input type="checkbox" class="btn-check" id="tag5" value="親仔" onchange="updateTags()">
						<label class="btn btn-outline-dark tag-check-label" for="tag5"># 親仔</label>
					</div>
					<input type="hidden" id="situationTag" name="situationTag">
				</div>

				<!-- 7. 상세 내용 (CONTENT) -->
				<div class="mb-5">
					<label for="content" class="form-label form-label-jp">詳細内容
						<span class="text-danger">*</span>
					</label>
					<textarea class="form-control border-secondary-subtle" id="content"
						name="content" rows="5"
						placeholder="クマの移動方向、大きさ、当時の状況などを詳細に入力してください。"></textarea>
				</div>

				<!-- 하단 버튼 영역 -->
				<div class="d-flex justify-content-between align-items-center pt-3 border-top">
					<a href="${pageContext.request.contextPath}/"
						class="btn btn-jp-outline px-4">キャンセル</a>
					<button type="submit" class="btn btn-jp-mustard btn-lg px-5">報告を送信する →</button>
				</div>
			</form>
		</div>
	</main>

	<!-- Footer Include -->
	<%@ include file="/WEB-INF/views/includes/footer.jsp" %>

	<!-- Bootstrap 5 JS -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

	<script>
		let map;
		let marker;
		let geocoder;

		// 1. Google Map 초기화 함수 (콜백으로 자동 호출됨)
		function initMap() {
			// 기본 중심점: 삿포로시 중심부 (위도, 경도)
			const defaultCenter = { lat: 43.0621, lng: 141.3544 };

			map = new google.maps.Map(document.getElementById("map"), {
				zoom: 12,
				center: defaultCenter,
			});

			geocoder = new google.maps.Geocoder();

			// 지도 클릭 이벤트 핸들러
			map.addListener("click", function (e) {
				const lat = e.latLng.lat();
				const lng = e.latLng.lng();

				// 기존 마커가 있다면 위치 이동, 없으면 생성
				if (marker) {
					marker.setPosition(e.latLng);
				} else {
					marker = new google.maps.Marker({
						position: e.latLng,
						map: map,
					});
				}

				// input 필드에 위도, 경도 입력
				document.getElementById("latitude").value = lat.toFixed(6);
				document.getElementById("longitude").value = lng.toFixed(6);

				// 좌표를 일본 주소로 변환 (Reverse Geocoding)
				geocodeLatLng(lat, lng);
			});
		}

		// 2. 위도/경도를 주소 문자열로 변환하는 함수
		function geocodeLatLng(lat, lng) {
			const latlng = { lat: lat, lng: lng };
			geocoder.geocode({ location: latlng }, function (results, status) {
				if (status === "OK") {
					if (results[0]) {
						// 주소 입력 칸에 변환된 주소 자동 삽입
						document.getElementById("address").value = results[0].formatted_address;
					} else {
						document.getElementById("address").value = "住所が見つかりません。";
					}
				} else {
					console.error("Geocoder failed due to: " + status);
				}
			});
		}

		document.addEventListener('DOMContentLoaded', function() {
			
			// 현재 시간을 datetime-local 기본값으로 설정
			const sightingDateInput = document.getElementById('sightingDate');
			if (sightingDateInput && !sightingDateInput.value) {
				sightingDateInput.value = new Date().toISOString().slice(0, 16);
			}

			// 폼 제출 유효성 검사 (Validation)
			const reportForm = document.getElementById('reportForm');
			if (reportForm) {
				reportForm.addEventListener('submit', function(e) {
					let isValid = true;
					
					const requiredFields = [
						{ id: 'title', name: '通報タイトル' },
						{ id: 'sightingDate', name: '目撃日時' },
						{ id: 'address', name: '目撃位置（住所）' },
						{ id: 'content', name: '詳細内容' }
					];

					document.querySelectorAll('.is-invalid').forEach(el => el.classList.remove('is-invalid'));
					document.querySelectorAll('.invalid-feedback').forEach(el => el.remove());

					for (let field of requiredFields) {
						const inputEl = document.getElementById(field.id);
						
						if (inputEl && !inputEl.value.trim()) {
							isValid = false;
							inputEl.classList.add('is-invalid');
							
							const errorDiv = document.createElement('div');
							errorDiv.className = 'invalid-feedback fw-bold mt-1 d-block';
							errorDiv.innerText = '⚠️ ' + field.name + 'を入力してください。';
							
							if (field.id === 'address') {
								inputEl.closest('.row').after(errorDiv);
							} else {
								inputEl.after(errorDiv);
							}

							inputEl.focus();
							inputEl.scrollIntoView({ behavior: 'smooth', block: 'center' });
							break;
						}
					}

					if (!isValid) {
						e.preventDefault();
					}
				});
			}
		});

		// 상황 태그 콤마(,) 구분 함수
		function updateTags() {
			const checkboxes = document.querySelectorAll('.btn-check:checked');
			const selectedTags = Array.from(checkboxes).map(cb => cb.value);
			document.getElementById('situationTag').value = selectedTags.join(',');
		}

		// 이미지 파일 미리보기 함수
		function previewImage(input) {
			const previewBox = document.getElementById('imagePreviewBox');
			const previewImage = document.getElementById('imagePreview');

			if (input.files && input.files[0]) {
				const reader = new FileReader();
				reader.onload = function(e) {
					previewImage.src = e.target.result;
					previewBox.style.display = 'block';
				}
				reader.readAsDataURL(input.files[0]);
			} else {
				previewImage.src = '#';
				previewBox.style.display = 'none';
			}
		}
	</script>
</body>
</html>