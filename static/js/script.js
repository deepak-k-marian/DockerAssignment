document.addEventListener('DOMContentLoaded', () => {
    const btn = document.getElementById('main-btn');
    const emailInput = document.getElementById('email-input');
    const statusMsg = document.getElementById('status-msg');
    
    btn.addEventListener('click', async () => {
        const targetEmail = emailInput.value.trim();
        
        if (!targetEmail) {
            statusMsg.style.color = "#f87171";
            statusMsg.innerText = "Please provide an email address first.";
            return;
        }
        
        statusMsg.style.color = "#38bdf8";
        statusMsg.innerText = "Processing request, please wait...";
        
        try {
            const response = await fetch('/send-email', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ email: targetEmail })
            });
            
            if (response.ok) {
                statusMsg.style.color = "#4ade80";
                statusMsg.innerText = "Success! The request was queued. Check your inbox soon.";
                emailInput.value = "";
            } else {
                statusMsg.style.color = "#f87171";
                statusMsg.innerText = "Error: Validation parameters rejected by API server.";
            }
        } catch (err) {
            statusMsg.style.color = "#f87171";
            statusMsg.innerText = "Network failure: Unable to interface with local server instances.";
        }
    });
});
