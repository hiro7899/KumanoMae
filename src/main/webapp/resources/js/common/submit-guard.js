document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll('form[method="post"]').forEach(function (form) {
        form.addEventListener("submit", function (event) {
            if (form.dataset.submitting === "true") {
                event.preventDefault();
                return;
            }

            form.dataset.submitting = "true";

            var submitButton = event.submitter || form.querySelector('button[type="submit"]');
            if (submitButton) {
                submitButton.disabled = true;
                submitButton.innerHTML = '<i class="bi bi-hourglass-split me-1" aria-hidden="true"></i>処理中...';
            }
        });
    });
});
