<%-- 
    Document   : Loading
    Created on : 18 thg 3, 2026, 14:44:07
    Author     : pvbmi
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!--<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analyzing Your Website</title>
    <style>
        /* Giữ nguyên style của bạn */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        }
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-color: #e5e7eb;
        }
        .card {
            width: 320px;
            border-radius: 20px;
            padding: 30px 20px;
        }
        .header {
            text-align: center;
            margin-bottom: 24px;
        }
        .main-icon-wrapper {
            width: 64px;
            height: 64px;
            background: rgba(255, 255, 255, 0.6);
            border-radius: 16px;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0 auto 16px;
            box-shadow: 0 8px 20px rgba(255, 255, 255, 0.6);
            backdrop-filter: blur(10px);
        }
        .main-icon-wrapper svg {
            width: 32px;
            height: 32px;
            fill: none;
            stroke: #2563eb;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
        }
        h2 {
            font-size: 18px;
            font-weight: 500;
            color: #1f2937;
        }
        .task-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .task-item {
            background: rgba(255, 255, 255, 0.65);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.8);
            border-radius: 14px;
            padding: 12px;
            display: flex;
            align-items: center;
            gap: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.03);
        }
        .task-icon {
            width: 36px;
            height: 36px;
            background: linear-gradient(135deg, #81a8f6 0%, #5e8cf0 100%);
            border-radius: 10px;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-shrink: 0;
            box-shadow: 0 4px 10px rgba(94, 140, 240, 0.3);
        }
        .task-icon svg {
            width: 18px;
            height: 18px;
            fill: none;
            stroke: #ffffff;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
        }
        .task-content {
            flex-grow: 1;
        }
        .task-name {
            font-size: 13px;
            color: #1f2937;
            margin-bottom: 6px;
            display: block;
            font-weight: 400;
        }
        .progress-wrapper {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .progress-track {
            flex-grow: 1;
            height: 8px;
            background-color: #ffffff;
            border-radius: 4px;
            overflow: hidden;
        }
        .progress-fill {
            height: 100%;
            background-color: #3b82f6;
            border-radius: 4px;
        }
        .progress-text {
            font-size: 11px;
            color: #4b5563;
            min-width: 28px;
            text-align: right;
            font-weight: 500;
        }
        #errorMessage {
            margin-top:20px; 
            color:#b91c1c; 
            background:rgba(254,202,202,0.8); 
            padding:10px; 
            border-radius:10px; 
            text-align:center; 
            display:none;
        }
    </style>
</head>
<body>
    <div style="width:100%; min-height:100vh; display:flex; background:linear-gradient(180deg, #9bbcf9 0%, #eef3fc 100%); justify-content:center; align-items:center;">
        <div class="card">
            <div class="header">
                <div class="main-icon-wrapper">
                    <svg viewBox="0 0 24 24">
                        <path d="M9.5 2c-1.82 0-3.5 1.1-4.22 2.76C2.96 5.38 1 7.45 1 10c0 2.21 1.34 4.1 3.25 4.84L4 15c0 2.76 2.24 5 5 5h1c.55 0 1-.45 1-1v-2c0-.55-.45-1-1-1h-1c-1.65 0-3-1.35-3-3v-1.12c-.59-.35-1-.98-1-1.7V10c0-1.65 1.35-3 3-3h1.5M14.5 2c1.82 0 3.5 1.1 4.22 2.76C21.04 5.38 23 7.45 23 10c0 2.21-1.34 4.1-3.25 4.84L20 15c0 2.76-2.24 5-5 5h-1c-.55 0-1-.45-1-1v-2c0-.55.45-1 1-1h1c1.65 0 3-1.35 3-3v-1.12c.59-.35 1-.98 1-1.7V10c0-1.65-1.35-3-3-3h-1.5M12 2v20"></path>
                    </svg>
                </div>
                <h2>Analyzing Your Website</h2>
            </div>

            <div class="task-list">
                 Task 1: Crawling 
                <div class="task-item">
                    <div class="task-icon">
                        <svg viewBox="0 0 24 24">
                            <circle cx="12" cy="12" r="10"></circle>
                            <line x1="2" y1="12" x2="22" y2="12"></line>
                            <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"></path>
                        </svg>
                    </div>
                    <div class="task-content">
                        <span class="task-name">Crawling website content...</span>
                        <div class="progress-wrapper">
                            <div class="progress-track">
                                <div class="progress-fill" style="width: 0%;"></div>
                            </div>
                            <span class="progress-text">0%</span>
                        </div>
                    </div>
                </div>
                 Task 2: AI Analysis 
                <div class="task-item">
                    <div class="task-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M9.5 2c-1.82 0-3.5 1.1-4.22 2.76C2.96 5.38 1 7.45 1 10c0 2.21 1.34 4.1 3.25 4.84L4 15c0 2.76 2.24 5 5 5h1c.55 0 1-.45 1-1v-2c0-.55-.45-1-1-1h-1c-1.65 0-3-1.35-3-3v-1.12c-.59-.35-1-.98-1-1.7V10c0-1.65 1.35-3 3-3h1.5M14.5 2c1.82 0 3.5 1.1 4.22 2.76C21.04 5.38 23 7.45 23 10c0 2.21-1.34 4.1-3.25 4.84L20 15c0 2.76-2.24 5-5 5h-1c-.55 0-1-.45-1-1v-2c0-.55.45-1 1-1h1c1.65 0 3-1.35 3-3v-1.12c.59-.35 1-.98 1-1.7V10c0-1.65-1.35-3-3-3h-1.5M12 2v20"></path>
                        </svg>
                    </div>
                    <div class="task-content">
                        <span class="task-name">Analyzing with AI...</span>
                        <div class="progress-wrapper">
                            <div class="progress-track">
                                <div class="progress-fill" style="width: 0%;"></div>
                            </div>
                            <span class="progress-text">0%</span>
                        </div>
                    </div>
                </div>
                 Task 3: Marketing report 
                <div class="task-item">
                    <div class="task-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                            <polyline points="14 2 14 8 20 8"></polyline>
                            <line x1="16" y1="13" x2="8" y2="13"></line>
                            <line x1="16" y1="17" x2="8" y2="17"></line>
                            <polyline points="10 9 9 9 8 9"></polyline>
                        </svg>
                    </div>
                    <div class="task-content">
                        <span class="task-name">Generating marketing report...</span>
                        <div class="progress-wrapper">
                            <div class="progress-track">
                                <div class="progress-fill" style="width: 0%;"></div>
                            </div>
                            <span class="progress-text">0%</span>
                        </div>
                    </div>
                </div>
                 Task 4: Calculating scores 
                <div class="task-item">
                    <div class="task-icon">
                        <svg viewBox="0 0 24 24">
                            <line x1="18" y1="20" x2="18" y2="10"></line>
                            <line x1="12" y1="20" x2="12" y2="4"></line>
                            <line x1="6" y1="20" x2="6" y2="14"></line>
                        </svg>
                    </div>
                    <div class="task-content">
                        <span class="task-name">Calculating scores...</span>
                        <div class="progress-wrapper">
                            <div class="progress-track">
                                <div class="progress-fill" style="width: 0%;"></div>
                            </div>
                            <span class="progress-text">0%</span>
                        </div>
                    </div>
                </div>
            </div>

            <div id="errorMessage"></div>
        </div>
    </div>

    <script>
    window.onload = function() {
        const urlParams = new URLSearchParams(window.location.search);
        const targetUrl = urlParams.get('url');
        if (!targetUrl) {
            showError('Missing URL parameter.');
            return;
        }

        // Dùng context path
        fetch('<%= request.getContextPath() %>/mainServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'url=' + encodeURIComponent(targetUrl)
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            const reader = response.body.getReader();
            const decoder = new TextDecoder();

            function read() {
                reader.read().then(({ done, value }) => {
                    if (done) {
                        console.log('Stream closed without final result');
                        return;
                    }

                    const chunk = decoder.decode(value, { stream: true });
                    const lines = chunk.split('\n');

                    lines.forEach(line => {
                        if (line.startsWith("PROGRESS|")) {
                            const parts = line.split('|');
                            if (parts.length >= 3) {
                                const task = parts[1].trim();
                                const percent = parts[2].trim();
                                updateProgressBar(task, percent);
                            }
                        } else if (line.startsWith("FINAL_RESULT|")) {
                            const jsonStr = line.substring("FINAL_RESULT|".length);
                            sessionStorage.setItem('analysisResult', jsonStr);
                            setTimeout(() => {
                                window.location.href = '<%= request.getContextPath() %>/View/result.jsp';
                            }, 500);
                            return; // dừng đọc
                        } else if (line.startsWith("ERROR|")) {
                            const errorMsg = line.substring("ERROR|".length);
                            showError(errorMsg);
                            return;
                        }
                    });
                    read();
                }).catch(err => {
                    showError('Error reading stream: ' + err.message);
                });
            }
            read();
        })
        .catch(err => {
            showError('Fetch error: ' + err.message);
        });
    };


function updateProgressBar(task, percent) {
    const bars = document.querySelectorAll('.progress-fill');
    const texts = document.querySelectorAll('.progress-text');

    const map = { CRAWL:0, AI:1, REPORT:2, SCORE:3 };

    const i = map[task];
    if (bars[i]) {
        bars[i].style.width = percent + '%';
        texts[i].innerText = percent + '%';
    }
}
    function showError(message) {
        const errorDiv = document.getElementById('errorMessage');
        errorDiv.style.display = 'block';
        errorDiv.innerText = '❌ ' + message;
    }
    </script>
</body>
</html>-->
<%-- 
    Document   : Loading
    Created on : 18 thg 3, 2026, 14:44:07
    Author     : pvbmi
--%>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analyzing Your Website</title>
    <style>
        /* Giữ nguyên style của bạn */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        }
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-color: #e5e7eb;
        }
        .card {
            width: 320px;
            border-radius: 20px;
            padding: 30px 20px;
        }
        .header {
            text-align: center;
            margin-bottom: 24px;
        }
        .main-icon-wrapper {
            width: 64px;
            height: 64px;
            background: rgba(255, 255, 255, 0.6);
            border-radius: 16px;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0 auto 16px;
            box-shadow: 0 8px 20px rgba(255, 255, 255, 0.6);
            backdrop-filter: blur(10px);
        }
        .main-icon-wrapper svg {
            width: 32px;
            height: 32px;
            fill: none;
            stroke: #2563eb;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
        }
        h2 {
            font-size: 18px;
            font-weight: 500;
            color: #1f2937;
        }
        .task-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .task-item {
            background: rgba(255, 255, 255, 0.65);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.8);
            border-radius: 14px;
            padding: 12px;
            display: flex;
            align-items: center;
            gap: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.03);
        }
        .task-icon {
            width: 36px;
            height: 36px;
            background: linear-gradient(135deg, #81a8f6 0%, #5e8cf0 100%);
            border-radius: 10px;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-shrink: 0;
            box-shadow: 0 4px 10px rgba(94, 140, 240, 0.3);
        }
        .task-icon svg {
            width: 18px;
            height: 18px;
            fill: none;
            stroke: #ffffff;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
        }
        .task-content {
            flex-grow: 1;
        }
        .task-name {
            font-size: 13px;
            color: #1f2937;
            margin-bottom: 6px;
            display: block;
            font-weight: 400;
        }
        .progress-wrapper {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .progress-track {
            flex-grow: 1;
            height: 8px;
            background-color: #ffffff;
            border-radius: 4px;
            overflow: hidden;
        }
        .progress-fill {
            height: 100%;
            background-color: #3b82f6;
            border-radius: 4px;
        }
        .progress-text {
            font-size: 11px;
            color: #4b5563;
            min-width: 28px;
            text-align: right;
            font-weight: 500;
        }
        #errorMessage {
            margin-top:20px; 
            color:#b91c1c; 
            background:rgba(254,202,202,0.8); 
            padding:10px; 
            border-radius:10px; 
            text-align:center; 
            display:none;
        }
    </style>
</head>
<body>
    <div style="width:100%; min-height:100vh; display:flex; background:linear-gradient(180deg, #9bbcf9 0%, #eef3fc 100%); justify-content:center; align-items:center;">
        <div class="card">
            <div class="header">
                <div class="main-icon-wrapper">
                    <svg viewBox="0 0 24 24">
                        <path d="M9.5 2c-1.82 0-3.5 1.1-4.22 2.76C2.96 5.38 1 7.45 1 10c0 2.21 1.34 4.1 3.25 4.84L4 15c0 2.76 2.24 5 5 5h1c.55 0 1-.45 1-1v-2c0-.55-.45-1-1-1h-1c-1.65 0-3-1.35-3-3v-1.12c-.59-.35-1-.98-1-1.7V10c0-1.65 1.35-3 3-3h1.5M14.5 2c1.82 0 3.5 1.1 4.22 2.76C21.04 5.38 23 7.45 23 10c0 2.21-1.34 4.1-3.25 4.84L20 15c0 2.76-2.24 5-5 5h-1c-.55 0-1-.45-1-1v-2c0-.55.45-1 1-1h1c1.65 0 3-1.35 3-3v-1.12c.59-.35 1-.98 1-1.7V10c0-1.65-1.35-3-3-3h-1.5M12 2v20"></path>
                    </svg>
                </div>
                <h2>Analyzing Your Website</h2>
            </div>

            <div class="task-list">
                <!-- Task 1: Crawling -->
                <div class="task-item">
                    <div class="task-icon">
                        <svg viewBox="0 0 24 24">
                            <circle cx="12" cy="12" r="10"></circle>
                            <line x1="2" y1="12" x2="22" y2="12"></line>
                            <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"></path>
                        </svg>
                    </div>
                    <div class="task-content">
                        <span class="task-name">Crawling website content...</span>
                        <div class="progress-wrapper">
                            <div class="progress-track">
                                <div class="progress-fill" style="width: 0%;"></div>
                            </div>
                            <span class="progress-text">0%</span>
                        </div>
                    </div>
                </div>
                <!-- Task 2: AI Analysis -->
                <div class="task-item">
                    <div class="task-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M9.5 2c-1.82 0-3.5 1.1-4.22 2.76C2.96 5.38 1 7.45 1 10c0 2.21 1.34 4.1 3.25 4.84L4 15c0 2.76 2.24 5 5 5h1c.55 0 1-.45 1-1v-2c0-.55-.45-1-1-1h-1c-1.65 0-3-1.35-3-3v-1.12c-.59-.35-1-.98-1-1.7V10c0-1.65 1.35-3 3-3h1.5M14.5 2c1.82 0 3.5 1.1 4.22 2.76C21.04 5.38 23 7.45 23 10c0 2.21-1.34 4.1-3.25 4.84L20 15c0 2.76-2.24 5-5 5h-1c-.55 0-1-.45-1-1v-2c0-.55.45-1 1-1h1c1.65 0 3-1.35 3-3v-1.12c.59-.35 1-.98 1-1.7V10c0-1.65-1.35-3-3-3h-1.5M12 2v20"></path>
                        </svg>
                    </div>
                    <div class="task-content">
                        <span class="task-name">Analyzing with AI...</span>
                        <div class="progress-wrapper">
                            <div class="progress-track">
                                <div class="progress-fill" style="width: 0%;"></div>
                            </div>
                            <span class="progress-text">0%</span>
                        </div>
                    </div>
                </div>
                <!-- Task 3: Marketing report -->
                <div class="task-item">
                    <div class="task-icon">
                        <svg viewBox="0 0 24 24">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                            <polyline points="14 2 14 8 20 8"></polyline>
                            <line x1="16" y1="13" x2="8" y2="13"></line>
                            <line x1="16" y1="17" x2="8" y2="17"></line>
                            <polyline points="10 9 9 9 8 9"></polyline>
                        </svg>
                    </div>
                    <div class="task-content">
                        <span class="task-name">Generating marketing report...</span>
                        <div class="progress-wrapper">
                            <div class="progress-track">
                                <div class="progress-fill" style="width: 0%;"></div>
                            </div>
                            <span class="progress-text">0%</span>
                        </div>
                    </div>
                </div>
                <!-- Task 4: Calculating scores -->
                <div class="task-item">
                    <div class="task-icon">
                        <svg viewBox="0 0 24 24">
                            <line x1="18" y1="20" x2="18" y2="10"></line>
                            <line x1="12" y1="20" x2="12" y2="4"></line>
                            <line x1="6" y1="20" x2="6" y2="14"></line>
                        </svg>
                    </div>
                    <div class="task-content">
                        <span class="task-name">Calculating scores...</span>
                        <div class="progress-wrapper">
                            <div class="progress-track">
                                <div class="progress-fill" style="width: 0%;"></div>
                            </div>
                            <span class="progress-text">0%</span>
                        </div>
                    </div>
                </div>
            </div>

            <div id="errorMessage"></div>
        </div>
    </div>

    <script>
    window.onload = function() {
        const urlParams = new URLSearchParams(window.location.search);
        const targetUrl = urlParams.get('url');
        if (!targetUrl) {
            showError('Missing URL parameter.');
            return;
        }

        fetch('<%= request.getContextPath() %>/mainServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'url=' + encodeURIComponent(targetUrl)
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            const reader = response.body.getReader();
            const decoder = new TextDecoder();

            function read() {
                reader.read().then(({ done, value }) => {
                    if (done) {
                        console.log('Stream closed without final result');
                        return;
                    }

                    const chunk = decoder.decode(value, { stream: true });
                    const lines = chunk.split('\n');

                    lines.forEach(line => {
                        if (line.startsWith("PROGRESS|")) {
                            const parts = line.split('|');
                            if (parts.length >= 3) {
                                const task = parts[1].trim();
                                const percent = parts[2].trim();
                                updateProgressBar(task, percent);
                            }
                        } else if (line.startsWith("FINAL_RESULT|")) {
                            const jsonStr = line.substring("FINAL_RESULT|".length);
                            try {
                                const data = JSON.parse(jsonStr);
                                const analysisId = data.id;
                                if (analysisId) {
                                    // Chuyển hướng sang result.jsp kèm id
                                    window.location.href = '<%= request.getContextPath() %>/View/result.jsp?id=' + encodeURIComponent(analysisId);
                                } else {
                                    showError('Invalid FINAL_RESULT: missing id');
                                }
                            } catch (e) {
                                showError('Failed to parse FINAL_RESULT: ' + e.message);
                            }
                            return;
                        } else if (line.startsWith("ERROR|")) {
                            const errorMsg = line.substring("ERROR|".length);
                            showError(errorMsg);
                            return;
                        }
                    });
                    read();
                }).catch(err => {
                    showError('Error reading stream: ' + err.message);
                });
            }
            read();
        })
        .catch(err => {
            showError('Fetch error: ' + err.message);
        });
    };

    function updateProgressBar(task, percent) {
        const bars = document.querySelectorAll('.progress-fill');
        const texts = document.querySelectorAll('.progress-text');
        const map = { CRAWL:0, AI:1, REPORT:2, SCORE:3 };
        const i = map[task];
        if (bars[i]) {
            bars[i].style.width = percent + '%';
            texts[i].innerText = percent + '%';
        }
    }

    function showError(message) {
        const errorDiv = document.getElementById('errorMessage');
        errorDiv.style.display = 'block';
        errorDiv.innerText = '❌ ' + message;
    }
    </script>
</body>
</html>