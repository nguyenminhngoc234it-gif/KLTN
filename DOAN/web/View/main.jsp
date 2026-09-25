<%-- 
    Document   : main
    Created on : 17 thg 3, 2026, 22:35:20
    Author     : pvbmi
--%>
<%@page import="Model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
//    // Kiểm tra session user đã tồn tại chưa (giả sử tên session là "userSession")
    String userEmail = (String) session.getAttribute("userSession");
    boolean isLoggedIn = (userEmail != null);



    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect("Login.jsp");
        return;
    }



%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>AI Marketing Strategist - SME Growth AI</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">

    <style>
        /* ================= CSS VARIABLES & RESET ================= */
        :root {
            --primary: #6366f1;
            --primary-dark: #4f46e5;
            --accent: #8b5cf6;
            --secondary: #ec4899;
            --text-main: #0f172a;
            --text-muted: #475569;
            --bg-light: #f8fafc;
            --white: #ffffff;
            --glass-bg: rgba(255, 255, 255, 0.7);
            --glass-border: rgba(255, 255, 255, 0.2);
            --shadow-sm: 0 10px 25px -5px rgba(0, 0, 0, 0.05);
            --shadow-md: 0 20px 40px -12px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 30px 60px -15px rgba(99, 102, 241, 0.3);
            --transition: all 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            --transition-slow: all 0.8s cubic-bezier(0.215, 0.610, 0.355, 1);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg-light);
            color: var(--text-main);
            line-height: 1.6;
            overflow-x: hidden;
            scroll-behavior: smooth;
        }

        /* ================= BACKGROUND ANIMATIONS ================= */
        .bg-blob {
            position: fixed;
            width: 100vw;
            height: 100vh;
            top: 0;
            left: 0;
            z-index: -1;
            overflow: hidden;
            pointer-events: none;
        }

        .blob {
            position: absolute;
            background: linear-gradient(135deg, var(--primary) 0%, var(--accent) 100%);
            filter: blur(80px);
            border-radius: 50%;
            opacity: 0.15;
            animation: blobMove 20s infinite alternate ease-in-out;
        }

        .blob1 { width: 500px; height: 500px; top: -200px; right: -100px; animation-duration: 25s; }
        .blob2 { width: 400px; height: 400px; bottom: -150px; left: -100px; animation-duration: 30s; background: linear-gradient(135deg, var(--secondary) 0%, var(--primary) 100%); }
        .blob3 { width: 300px; height: 300px; top: 40%; left: 30%; animation-duration: 22s; opacity: 0.1; }

        @keyframes blobMove {
            0% { transform: translate(0, 0) scale(1); }
            100% { transform: translate(100px, 100px) scale(1.2); }
        }

        /* ================= ANIMATIONS ================= */
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(40px) scale(0.95); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }

        @keyframes fadeInScale {
            from { opacity: 0; transform: scale(0.9); }
            to { opacity: 1; transform: scale(1); }
        }

        @keyframes float {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-15px); }
            100% { transform: translateY(0px); }
        }

        @keyframes pulse-glow {
            0% { box-shadow: 0 0 0 0 rgba(99, 102, 241, 0.5); }
            70% { box-shadow: 0 0 0 20px rgba(99, 102, 241, 0); }
            100% { box-shadow: 0 0 0 0 rgba(99, 102, 241, 0); }
        }

        @keyframes shimmer {
            0% { background-position: -200% 0; }
            100% { background-position: 200% 0; }
        }

        @keyframes rotateGlow {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* ================= HERO SECTION ================= */
        .hero {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 100px 20px;
            position: relative;
            background: radial-gradient(circle at 80% 30%, rgba(99, 102, 241, 0.08) 0%, transparent 40%),
                        radial-gradient(circle at 20% 70%, rgba(236, 72, 153, 0.08) 0%, transparent 40%);
        }

        .hero-container {
            max-width: 1000px;
            margin: auto;
            text-align: center;
            animation: fadeInScale 1.2s ease-out;
        }

        .badge {
            display: inline-flex;
            gap: 10px;
            align-items: center;
            background: var(--glass-bg);
            backdrop-filter: blur(12px);
            border: 1px solid var(--glass-border);
            padding: 10px 24px;
            border-radius: 60px;
            font-size: 15px;
            font-weight: 600;
            color: var(--primary);
            margin-bottom: 30px;
            box-shadow: var(--shadow-sm);
            animation: float 4s ease-in-out infinite;
            transition: var(--transition);
        }

        .badge:hover {
            transform: scale(1.05);
            background: white;
            border-color: var(--primary);
        }

        .hero-title {
            font-size: clamp(44px, 10vw, 80px);
            margin: 20px 0;
            font-weight: 800;
            letter-spacing: -0.03em;
            line-height: 1.1;
            text-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        .gradient-text {
            background: linear-gradient(135deg, var(--primary) 0%, var(--accent) 50%, var(--secondary) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-size: 200% auto;
            animation: shimmer 6s linear infinite;
        }

        .hero-desc {
            font-size: 22px;
            color: var(--text-muted);
            max-width: 650px;
            margin: 0 auto 45px;
            font-weight: 300;
            backdrop-filter: blur(4px);
        }

        .main-btn {
            display: inline-flex;
            gap: 15px;
            align-items: center;
            padding: 18px 42px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--accent) 100%);
            color: var(--white);
            border-radius: 60px;
            text-decoration: none;
            font-weight: 700;
            font-size: 20px;
            border: none;
            cursor: pointer;
            transition: var(--transition);
            box-shadow: 0 15px 30px -8px rgba(99, 102, 241, 0.4);
            position: relative;
            overflow: hidden;
            z-index: 1;
        }

        .main-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.6s ease;
            z-index: -1;
        }

        .main-btn:hover {
            transform: translateY(-5px) scale(1.05);
            box-shadow: var(--shadow-lg);
        }

        .main-btn:hover::before {
            left: 100%;
        }

        .main-btn i {
            transition: transform 0.3s ease;
        }

        .main-btn:hover i {
            transform: translateX(8px);
        }

        /* ================= FEATURES SECTION ================= */
        .features {
            padding: 120px 20px;
            position: relative;
        }

        .container {
            max-width: 1200px;
            margin: auto;
        }

        .title-area {
            text-align: center;
            margin-bottom: 80px;
            opacity: 0;
            transform: translateY(40px);
            transition: var(--transition-slow);
        }

        .title-area.active {
            opacity: 1;
            transform: translateY(0);
        }

        .title-area h2 {
            font-size: 48px;
            font-weight: 800;
            letter-spacing: -0.02em;
            margin-bottom: 20px;
            background: linear-gradient(135deg, #0f172a 0%, #334155 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .title-area p {
            font-size: 18px;
            color: var(--text-muted);
            max-width: 600px;
            margin: 0 auto;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(340px, 1fr));
            gap: 35px;
        }

        .card {
            background: var(--white);
            backdrop-filter: blur(10px);
            padding: 45px 35px;
            border-radius: 32px;
            box-shadow: var(--shadow-sm);
            transition: var(--transition);
            position: relative;
            overflow: hidden;
            opacity: 0;
            transform: translateY(50px);
            border: 1px solid rgba(99, 102, 241, 0.1);
            will-change: transform, opacity;
        }

        .card.active {
            opacity: 1;
            transform: translateY(0);
        }

        .card::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle at 50% 0%, rgba(99, 102, 241, 0.1) 0%, transparent 70%);
            opacity: 0;
            transition: opacity 0.4s ease;
            pointer-events: none;
        }

        .card:hover {
            transform: translateY(-15px) scale(1.02);
            border-color: var(--primary);
            box-shadow: var(--shadow-md);
        }

        .card:hover::after {
            opacity: 1;
        }

        .icon {
            width: 70px;
            height: 70px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #f0f2ff 0%, #ffffff 100%);
            border-radius: 20px;
            margin-bottom: 30px;
            color: var(--primary);
            font-size: 30px;
            transition: all 0.5s ease;
            box-shadow: 0 10px 20px -10px rgba(99, 102, 241, 0.2);
        }

        .card:hover .icon {
            transform: rotateY(180deg) scale(1.1);
            background: var(--primary);
            color: white;
            box-shadow: 0 15px 30px -8px var(--primary);
        }

        .card h3 {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 15px;
            transition: color 0.3s;
        }

        .card:hover h3 {
            color: var(--primary);
        }

        .card p {
            color: var(--text-muted);
            font-size: 16px;
            line-height: 1.7;
        }

        /* ================= CTA SECTION ================= */
        .cta-wrapper {
            padding: 100px 20px 150px;
            background: transparent;
            position: relative;
        }

        .cta-inner {
            background: linear-gradient(145deg, #1e293b 0%, #0f172a 100%);
            padding: 80px 50px;
            border-radius: 48px;
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
            box-shadow: var(--shadow-lg);
            opacity: 0;
            transform: scale(0.9) translateY(40px);
            transition: var(--transition-slow);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .cta-inner.active {
            opacity: 1;
            transform: scale(1) translateY(0);
        }

        .cta-inner::before {
            content: '';
            position: absolute;
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(99, 102, 241, 0.3) 0%, transparent 70%);
            top: -200px;
            right: -200px;
            border-radius: 50%;
            filter: blur(80px);
            animation: rotateGlow 30s linear infinite;
        }

        .cta-inner::after {
            content: '';
            position: absolute;
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(236, 72, 153, 0.3) 0%, transparent 70%);
            bottom: -150px;
            left: -150px;
            border-radius: 50%;
            filter: blur(80px);
            animation: rotateGlow 25s linear infinite reverse;
        }

        .cta-inner h2 {
            font-size: clamp(40px, 6vw, 56px);
            font-weight: 800;
            margin-bottom: 20px;
            position: relative;
            z-index: 2;
            text-shadow: 0 4px 12px rgba(0,0,0,0.3);
        }

        .cta-inner p {
            color: rgba(255, 255, 255, 0.9);
            font-size: 22px;
            margin-bottom: 45px;
            position: relative;
            z-index: 2;
            font-weight: 300;
        }

        .cta-btn {
            display: inline-flex;
            align-items: center;
            gap: 12px;
            padding: 18px 50px;
            background: white;
            color: #0f172a;
            text-decoration: none;
            border-radius: 60px;
            font-weight: 700;
            font-size: 20px;
            transition: var(--transition);
            position: relative;
            z-index: 2;
            border: none;
            box-shadow: 0 15px 30px -8px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }

        .cta-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(99, 102, 241, 0.3), transparent);
            transition: left 0.6s ease;
        }

        .cta-btn:hover {
            transform: translateY(-5px) scale(1.05);
            background: #f8fafc;
            gap: 20px;
            box-shadow: 0 25px 40px -10px black;
        }

        .cta-btn:hover::before {
            left: 100%;
        }

        .cta-btn i {
            transition: transform 0.3s;
        }

        .cta-btn:hover i {
            transform: translateX(8px);
        }

        /* ================= RESPONSIVE ================= */
        @media (max-width: 768px) {
            .hero { padding: 80px 20px; }
            .hero-title { font-size: 44px; }
            .hero-desc { font-size: 18px; }
            .main-btn { padding: 16px 32px; font-size: 18px; }
            .title-area h2 { font-size: 36px; }
            .card { padding: 35px 25px; }
            .cta-inner { padding: 60px 20px; }
            .cta-inner h2 { font-size: 36px; }
            .cta-inner p { font-size: 18px; }
        }

        @media (max-width: 480px) {
            .grid { grid-template-columns: 1fr; }
            .badge { font-size: 13px; padding: 8px 16px; }
        }
    </style>
</head>
<body>
    <!-- Background blobs -->
    <div class="bg-blob">
        <div class="blob blob1"></div>
        <div class="blob blob2"></div>
        <div class="blob blob3"></div>
    </div>

    <section class="hero">
        <div class="hero-container">
            <div class="badge">
                <i class="fa-solid fa-bolt" style="color: var(--primary);"></i>
                <span>AI-Powered Marketing for SMEs</span>
            </div>

            <h1 class="hero-title">
                AI Marketing Strategist 
                <span class="gradient-text">for Your Business</span>
            </h1>

            <p class="hero-desc">
                Paste your website URL and get an AI-generated marketing strategy in seconds.
                No marketing team needed.
            </p>

            <a href="<%= request.getContextPath()%>/View/PT.jsp" class="main-btn">
                <span>Analyze My Website</span>
                <i class="fa-solid fa-arrow-right"></i>
            </a>
        </div>
    </section>

    <section class="features">
        <div class="container">
            <div class="title-area">
                <h2>Everything You Need to Grow</h2>
                <p>From website analysis to a complete marketing plan — all powered by AI.</p>
            </div>

            <div class="grid">
                <div class="card">
                    <div class="icon"><i class="fa-solid fa-brain"></i></div>
                    <h3>AI Website Analysis</h3>
                    <p>Our AI crawls and analyzes your website content to understand your business.</p>
                </div>
                <div class="card">
                    <div class="icon"><i class="fa-solid fa-bullseye"></i></div>
                    <h3>Marketing Strategy</h3>
                    <p>Get actionable marketing strategies tailored to your business and industry.</p>
                </div>
                <div class="card">
                    <div class="icon"><i class="fa-solid fa-chart-line"></i></div>
                    <h3>SEO Insights</h3>
                    <p>Discover keywords and SEO opportunities to boost your search rankings.</p>
                </div>
                <div class="card">
                    <div class="icon"><i class="fa-solid fa-users"></i></div>
                    <h3>Customer Personas</h3>
                    <p>AI identifies your ideal customer profile based on your business content.</p>
                </div>
                <div class="card">
                    <div class="icon"><i class="fa-solid fa-chart-column"></i></div>
                    <h3>Performance Scores</h3>
                    <p>Get marketing, SEO, content, and conversion scores with improvement tips.</p>
                </div>
                <div class="card">
                    <div class="icon"><i class="fa-solid fa-bolt"></i></div>
                    <h3>30-Day Plan</h3>
                    <p>Receive a step-by-step 30-day marketing action plan to get started.</p>
                </div>
            </div>
        </div>
    </section>

    <section class="cta-wrapper">
        <div class="container">
            <div class="cta-inner">
                <h2>Ready to Grow Your Business?</h2>
                <p>Get your personalized AI marketing strategy in under a minute.</p>
                <a href="<%= request.getContextPath()%>/View/PT.jsp" class="cta-btn">
                    Get Started Free
                    <i class="fa-solid fa-arrow-right"></i>
                </a>
            </div>
        </div>
    </section>

    <script>
        // Nâng cấp IntersectionObserver với hiệu ứng mượt hơn
        const observerOptions = {
            threshold: 0.1,
            rootMargin: "0px 0px -50px 0px"
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('active');
                    // Thêm hiệu ứng nhẹ khi rời khỏi (có thể giữ nguyên)
                } else {
                    // Nếu muốn ẩn lại khi scroll ra ngoài, bỏ comment dòng dưới
                    // entry.target.classList.remove('active');
                }
            });
        }, observerOptions);

        // Quan sát các phần tử cần hiệu ứng
        document.querySelectorAll('.card, .title-area, .cta-inner').forEach(el => {
            observer.observe(el);
        });

        // Stagger cho card với độ trễ tăng dần
        document.querySelectorAll('.card').forEach((card, index) => {
            card.style.transitionDelay = `${index * 0.1}s`;
        });

        // Hiệu ứng ripple cho nút (tùy chọn)
        document.querySelectorAll('.main-btn, .cta-btn').forEach(btn => {
            btn.addEventListener('click', function(e) {
                let x = e.clientX - e.target.getBoundingClientRect().left;
                let y = e.clientY - e.target.getBoundingClientRect().top;
                let ripple = document.createElement('span');
                ripple.style.position = 'absolute';
                ripple.style.width = '0';
                ripple.style.height = '0';
                ripple.style.borderRadius = '50%';
                ripple.style.background = 'rgba(255,255,255,0.5)';
                ripple.style.transform = 'translate(-50%, -50%)';
                ripple.style.left = x + 'px';
                ripple.style.top = y + 'px';
                ripple.style.transition = 'width 0.5s, height 0.5s, opacity 0.5s';
                ripple.style.pointerEvents = 'none';
                ripple.style.zIndex = '0';
                btn.style.position = 'relative';
                btn.appendChild(ripple);
                setTimeout(() => {
                    ripple.style.width = '300px';
                    ripple.style.height = '300px';
                    ripple.style.opacity = '0';
                }, 10);
                setTimeout(() => {
                    ripple.remove();
                }, 600);
            });
        });

        // Thêm hiệu ứng parallax nhẹ cho blob (tùy chọn)
        document.addEventListener('mousemove', (e) => {
            const blobs = document.querySelectorAll('.blob');
            const mouseX = e.clientX / window.innerWidth;
            const mouseY = e.clientY / window.innerHeight;
            blobs.forEach((blob, i) => {
                const speed = 20 + i * 5;
                const x = (mouseX - 0.5) * speed;
                const y = (mouseY - 0.5) * speed;
                blob.style.transform = `translate(${x}px, ${y}px)`;
            });
        });
    </script>
</body>
</html>