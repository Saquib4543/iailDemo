async function startObjectDetection() {
    console.log("Starting object detection...");

    const video = document.querySelector('#videoElement');
    if (!video) {
        console.error("Video element not found.");
        return;
    }
    console.log("Video element selected.");

    const canvas = document.querySelector('#canvas');
    if (!canvas) {
        console.error("Canvas element not found.");
        return;
    }
    console.log("Canvas element selected.");

    const ctx = canvas.getContext('2d');
    if (!ctx) {
        console.error("Failed to get 2D context for canvas.");
        return;
    }
    console.log("Canvas 2D context acquired.");

    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        console.error("Browser does not support WebRTC.");
        return;
    }
    console.log("Browser supports WebRTC.");

    // Catching the stream and attaching it to the video source
    navigator.mediaDevices.getUserMedia({
        video: {
            facingMode: 'environment' // Use the back camera
        }
    })
    .then(stream => {
        video.srcObject = stream;
        return video.play();  // Play the video.
    })
    .then(() => {
        canvas.width = video.offsetWidth;
        canvas.height = video.offsetHeight;
        console.log("Video playing. Setting canvas dimensions...");

        return cocoSsd.load();
    })
    .then(model => {
        console.log("Model loaded. Beginning object detection...");
        detectFrame(video, model);
    })
    .catch(err => {
        console.error("Error:", err);
    });

    function detectFrame(video, model) {
        model.detect(video).then(predictions => {
            console.log(`Detected ${predictions.length} objects.`);
            renderPredictions(predictions);
            requestAnimationFrame(() => {
                detectFrame(video, model);
            });
        });
    }

    function renderPredictions(predictions) {
        predictions = predictions.filter(prediction => prediction.score > 0.5);

            ctx.clearRect(0, 0, ctx.canvas.width, ctx.canvas.height);

            predictions.forEach(prediction => {
                console.log(`Detected object: ${prediction.class} with confidence ${prediction.score}`);

                let [x, y, width, height] = prediction.bbox;
                const scaleFactor = 0.7;
                let scaledWidth = width * scaleFactor;
                let scaledHeight = height * scaleFactor;

                // Adjust bounding box if it goes outside of the video frame
                x = Math.max(x + (width - scaledWidth) / 2, 0);
                y = Math.max(y + (height - scaledHeight) / 2, 0);
                scaledWidth = x + scaledWidth > ctx.canvas.width ? ctx.canvas.width - x : scaledWidth;
                scaledHeight = y + scaledHeight > ctx.canvas.height ? ctx.canvas.height - y : scaledHeight;

                ctx.beginPath();
                ctx.rect(x, y, scaledWidth, scaledHeight);
                ctx.lineWidth = 4;
                ctx.strokeStyle = 'green';
                ctx.fillStyle = 'green';
                ctx.stroke();

                // Improved text placement
                const text = `${prediction.class} (${Math.round(prediction.score * 100)}%)`;
                const textWidth = ctx.measureText(text).width;
                const textBackgroundPadding = 4;
                const textX = x + scaledWidth - textWidth - textBackgroundPadding > 0 ? x + scaledWidth - textWidth - textBackgroundPadding : x;
                const textY = y > 20 ? y - 10 : y + 20;

                // Draw a background for the text to make it more readable
                ctx.fillStyle = 'rgba(0, 255, 0, 0.5)';
                ctx.fillRect(textX - textBackgroundPadding, textY - 15, textWidth + 2 * textBackgroundPadding, 20);

                // Draw the text itself
                ctx.fillStyle = 'black';
                ctx.fillText(text, textX, textY);
            );
        });
    }
}
