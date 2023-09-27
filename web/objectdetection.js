let isDetectionRunning = false;
let currentStream = null;
let shutdown = false;

async function startObjectDetection() {
    if (shutdown) return;
    if (isDetectionRunning) {
        console.log("Object detection is already running.");
        return;
    }

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

    try {
        const stream = await navigator.mediaDevices.getUserMedia({
            video: {
                width: { ideal: 1920 },
                height: { ideal: 1080 },
                facingMode: 'environment'
            }
        });

        video.srcObject = currentStream = stream;
        await video.play();

        canvas.width = video.offsetWidth;
        canvas.height = video.offsetHeight;

        console.log("Video Dimensions:", video.width, video.height);
        console.log("Canvas Dimensions:", canvas.width, canvas.height);
        console.log("Video playing. Setting canvas dimensions...");

        const model = await cocoSsd.load();
        console.log("Model loaded. Beginning object detection...");

        isDetectionRunning = true;
        detectFrame(video, model, ctx);
    } catch (err) {
        console.error("Error starting object detection:", err);
    }
}

function detectFrame(video, model, ctx) {
    if (shutdown) return;
    if (!isDetectionRunning) return;

    model.detect(video).then(predictions => {
        console.log(`Detected ${predictions.length} objects.`);
        renderPredictions(predictions, ctx ,video);

        requestAnimationFrame(() => detectFrame(video, model, ctx));
    });
}

function renderPredictions(predictions, ctx,video) {
    if (shutdown) return;

    predictions = predictions.filter(prediction => prediction.score > 0.5);

    ctx.clearRect(0, 0, ctx.canvas.width, ctx.canvas.height);

    predictions.forEach(prediction => {
        // Get the predicted bounding box
        let [x, y, width, height] = prediction.bbox;

        // Calculate the scale factor for video to canvas adjustment
        const scaleX = video.offsetWidth / video.videoWidth;
        const scaleY = video.offsetHeight / video.videoHeight;

        // Adjust the bounding box dimensions based on the video scaling
        x *= scaleX;
        y *= scaleY;
        width *= scaleX;
        height *= scaleY;

        // Further adjust the width and height based on your scaleFactor
        const scaleFactor = 0.8;

        // Calculate the center of the bounding box
        let centerX = x + width / 2;
        let centerY = y + height / 2;

        // Adjust width and height
        width *= scaleFactor;
        height *= scaleFactor;

        // Calculate new top-left coordinates based on the scaled width and height
        x = centerX - width / 2;
        y = centerY - height / 2;

        // Check boundaries
        x = Math.max(x, 0);
        y = Math.max(y, 0);
        width = (x + width > ctx.canvas.width) ? (ctx.canvas.width - x) : width;
        height = (y + height > ctx.canvas.height) ? (ctx.canvas.height - y) : height;

        ctx.beginPath();
        ctx.rect(x, y, width, height);
        ctx.lineWidth = 4;
        ctx.strokeStyle = 'green';
        ctx.stroke();

        const text = `${prediction.class} (${Math.round(prediction.score * 100)}%)`;
        const textWidth = ctx.measureText(text).width;
        const textBackgroundPadding = 4;
        const textX = (x + width - textWidth - textBackgroundPadding > 0) ? (x + width - textWidth - textBackgroundPadding) : x;
        const textY = y > 20 ? y - 10 : y + 20;

        ctx.fillStyle = 'rgba(0, 255, 0, 0.5)';
        ctx.fillRect(textX - textBackgroundPadding, textY - 15, textWidth + 2 * textBackgroundPadding, 20);

        ctx.fillStyle = 'black';
        ctx.fillText(text, textX, textY);
    });


}





function stopObjectDetection() {
    isDetectionRunning = false;

    const canvas = document.querySelector('#canvas');
    const ctx = canvas && canvas.getContext('2d');

    if (ctx) {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
    }

    if (currentStream) {
        const tracks = currentStream.getTracks();
        tracks.forEach(track => track.stop());
        currentStream = null;
    }

    const video = document.querySelector('#videoElement');
    if (video) {
        video.srcObject = null;
    }
}


function stopAllOperations() {
    isDetectionRunning = false;
    shutdown = true;

    console.log("All JS operations halted.");
}