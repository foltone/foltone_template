window.addEventListener("message", (event) => {
    if (event.data.type == "open") {
        window.invokeNative("openUrl", event.data.url);
    }
});
