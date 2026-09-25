 <%-- 
    Document   : PT
    Created on : 17 thg 3, 2026, 22:35:32
    Author     : pvbmi
--%>

<%@page import="Model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Kiểm tra session user đã tồn tại chưa (giả sử tên session là "userSession")
    User user = (User) session.getAttribute("user");
     if (user == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
    boolean isLoggedIn = (user.getEmail() != null);

   
%>
<%-- 
    Document   : PT
    Created on : 17 thg 3, 2026, 22:35:32
    Author     : pvbmi
--%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>AI Website Analyzer - SME Growth AI</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #f8fafc;
            }
            .glass-card {
                background: rgba(255, 255, 255, 0.8);
                backdrop-filter: blur(12px);
                border: 1px solid rgba(255, 255, 255, 0.3);
            }
            .sidebar-item-active {
                background-color: #002060 !important;
                color: white !important;
            }
            .gradient-bg {
                background: radial-gradient(circle at top right, #eef2ff, #f8fafc);
            }
            @keyframes pulse-soft {
                0%, 100% {
                    transform: scale(1);
                    opacity: 1;
                }
                50% {
                    transform: scale(1.05);
                    opacity: 0.8;
                }
            }
            .animate-pulse-soft {
                animation: pulse-soft 3s infinite;
            }

            /* Thêm animation mới */
            @keyframes float {
                0% {
                    transform: translateY(0px);
                }
                50% {
                    transform: translateY(-5px);
                }
                100% {
                    transform: translateY(0px);
                }
            }
            .animate-float {
                animation: float 4s ease-in-out infinite;
            }

            @keyframes shimmer {
                0% {
                    background-position: -200% 0;
                }
                100% {
                    background-position: 200% 0;
                }
            }
            .shimmer {
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.4), transparent);
                background-size: 200% 100%;
                animation: shimmer 2s infinite;
            }

            @keyframes borderGlow {
                0% {
                    border-color: rgba(0,32,96,0.2);
                    box-shadow: 0 0 0 0 rgba(0,32,96,0.1);
                }
                50% {
                    border-color: rgba(0,32,96,0.5);
                    box-shadow: 0 0 12px 0 rgba(0,32,96,0.2);
                }
                100% {
                    border-color: rgba(0,32,96,0.2);
                    box-shadow: 0 0 0 0 rgba(0,32,96,0.1);
                }
            }
            .animate-border-glow {
                animation: borderGlow 3s infinite;
            }

            .progress-bar-animate {
                transition: width 1.5s ease-in-out;
            }

            .card-hover {
                transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            }
            .card-hover:hover {
                transform: translateY(-6px) scale(1.02);
                box-shadow: 0 20px 30px -10px rgba(0,32,96,0.2);
            }

            .btn-gradient {
                background: linear-gradient(145deg, #002060, #1e3a8a);
                background-size: 200% 200%;
                transition: all 0.3s ease;
            }
            .btn-gradient:hover {
                background-position: 100% 0;
                transform: scale(1.02);
                box-shadow: 0 10px 25px -5px rgba(0,32,96,0.4);
            }

            .fade-in {
                opacity: 0;
                animation: fadeIn 1s ease-out forwards;
            }
            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(15px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .delay-1 {
                animation-delay: 0.1s;
            }
            .delay-2 {
                animation-delay: 0.2s;
            }
            .delay-3 {
                animation-delay: 0.3s;
            }
            .delay-4 {
                animation-delay: 0.4s;
            }


            /* Container chứa lịch sử */
            #historyList {
                max-height: 300px; /* Giới hạn chiều cao để hiện scrollbar */
                overflow-y: auto;
                overflow-x: hidden; /* Chặn cuộn ngang */
                padding-right: 5px;
            }

            /* Từng item lịch sử */
            .history-item {
                display: flex;
                align-items: center;
                width: 100%;
                min-height: 40px; /* Đảm bảo đủ chỗ cho chữ */
                padding: 8px 12px;
                margin-bottom: 8px;
                background: #ffffff;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                font-size: 12px;
                color: #475569;
                white-space: nowrap; /* Giữ thời gian trên 1 dòng */
            }

            /* Tùy chỉnh thanh cuộn mảnh hơn */
            #historyList::-webkit-scrollbar {
                width: 4px;
            }
            #historyList::-webkit-scrollbar-thumb {
                background: #cbd5e1;
                border-radius: 10px;
            }
        </style>
    </head>
    <body class="flex min-h-screen">

        <!-- Sidebar với hiệu ứng hover -->
        <aside class="w-64 bg-white border-r border-gray-200 hidden md:flex flex-col sticky top-0 h-screen">
            <div class="p-6 flex items-center gap-3">
                <div class="w-8 h-8 bg-blue-900 rounded flex items-center justify-center text-white animate-float">
                    <i class="fa-solid fa-chart-simple"></i>
                </div>
                <span class="font-bold text-blue-900 text-lg">AI Website Analyzer</span>
            </div>

            <nav class="flex-1 px-4 space-y-2">
                <div class="p-3 text-xs font-semibold text-gray-400 uppercase tracking-wider">Menu chính</div>
                <a href="#" class="flex items-center gap-3 p-3 rounded-xl text-gray-500 hover:bg-gray-100 transition-all hover:scale-105 hover:shadow-sm">
                    <i class="fa-solid fa-wand-magic-sparkles"></i>
                    <span class="font-medium">AI Analyzer</span>
                </a>
                <a href="#" onclick="checkAuth(event, 'PT.jsp')" 
                   class="flex items-center gap-3 p-3 rounded-xl sidebar-item-active shadow-lg shadow-blue-900/20 transition-all hover:scale-105">
                    <i class="fa-solid fa-magnifying-glass-chart"></i>
                    <span class="font-medium">Analyze</span>
                </a>            
                <a href="#" id="btnHistory" onclick="checkAuth(event, 'history')"
                   class="flex items-center gap-3 p-3 rounded-xl text-gray-500 hover:bg-gray-100 transition-all hover:scale-105 hover:shadow-sm">
                    <i class="fa-solid fa-clock-rotate-left"></i>
                    <span class="font-medium text-gray-600">Lịch sử</span>
                </a>

                <div id="historyList" class="hidden ml-4 mr-2 mt-2 space-y-2 max-h-80 overflow-y-auto pr-1 scrollbar-thin">
                </div>
                <a href="#" onclick="checkAuth(event, '${pageContext.request.contextPath}/View/Dashboard.jsp')"
                   class="flex items-center gap-3 p-3 rounded-xl text-gray-500 hover:bg-gray-100 transition-all hover:scale-105 hover:shadow-sm">
                    <i class="fa-solid fa-table-columns"></i>
                    <span class="font-medium text-gray-600">Dashboard</span>
                </a> 
                <div class="mt-8 p-4 bg-gray-50 rounded-2xl border border-gray-100 relative overflow-hidden">
                    <div class="absolute inset-0 shimmer"></div>
                    <div class="relative z-10">
                        <div class="text-[10px] font-bold text-gray-400 uppercase mb-1">Pro Plan</div>
                        <div class="text-xs text-gray-600 mb-2">Sử dụng không giới hạn các công cụ phân tích AI.</div>
                        <div class="w-full bg-gray-200 h-1.5 rounded-full overflow-hidden">
                            <div class="bg-blue-600 h-full w-2/3 progress-bar-animate"></div>
                        </div>
                    </div>
                </div>
                <a href="Login.jsp" class="flex items-center gap-3 p-3 rounded-xl text-gray-500 hover:bg-gray-100 transition-all hover:scale-105 hover:shadow-sm">
                    <i class="fa-solid fa-table-columns"></i>
                    <span class="font-medium text-gray-600">Đăng Xuất</span>
                </a> 
            </nav>
        </aside>
        <main class="flex-1 gradient-bg overflow-x-hidden">

            <!-- Header với animation nhẹ -->
            <header class="flex justify-end items-center p-4 gap-4 fade-in">
                <button class="text-gray-400 hover:text-gray-600 transition-all hover:rotate-12">
                    <i class="fa-solid fa-clock-rotate-left text-lg"></i>
                </button>
                <div class="flex items-center gap-2 bg-white p-1 pr-3 rounded-full border border-gray-100 shadow-sm hover:shadow-md transition-all">
                    <div class="w-8 h-8 rounded-full bg-blue-100 flex items-center justify-center overflow-hidden">
                        <img src="https://ui-avatars.com/api/?name=Admin+AI&background=002060&color=fff" alt="Avatar">
                    </div>
                    <span class="text-sm font-semibold text-gray-700">Admin</span>
                </div>
            </header>

            <!-- Hero section -->
            <section class="max-w-4xl mx-auto px-6 py-12 text-center fade-in delay-1">
                <div class="inline-flex items-center gap-2 bg-blue-50 text-blue-700 px-4 py-1.5 rounded-full text-xs font-bold mb-6 animate-pulse-soft">
                    <i class="fa-solid fa-sparkles"></i>
                    AI ĐÃ SẴN SÀNG PHÂN TÍCH
                </div>
                <h1 class="text-5xl font-extrabold text-gray-900 mb-6 tracking-tight">Phân Tích Website</h1>
                <p class="text-gray-500 text-lg max-w-2xl mx-auto mb-10 leading-relaxed">
                    Khai phá tiềm năng tối đa của website bạn bằng trí tuệ nhân tạo. Nhận báo cáo chi tiết về hiệu suất, SEO và trải nghiệm người dùng ngay lập tức.
                </p>

                <div class="max-w-2xl mx-auto bg-white p-2 rounded-2xl shadow-2xl shadow-blue-900/10 flex items-center border border-gray-100 hover:shadow-blue-900/20 transition-all">
                    <div class="pl-4 text-gray-400">
                        <i class="fa-solid fa-globe"></i>
                    </div>

                    <form id="analyzeForm" action="${pageContext.request.contextPath}/View/Loading.jsp" method="get" class="flex flex-1">
                        <input type="text" name="url" id="urlInput" required 
                               placeholder="Nhập URL website của bạn (ví dụ: https://...)" 
                               class="flex-1 p-4 outline-none text-gray-700 bg-transparent">

                        <button type="button" onclick="handleAnalyze()" class="btn-gradient text-white px-8 py-4 rounded-xl font-bold flex items-center gap-2 transition-all">
                            <i class="fa-solid fa-bolt"></i>
                            Phân Tích Ngay
                        </button>
                    </form>
                </div>

                <div class="flex justify-center gap-8 mt-6 text-sm font-medium text-gray-500">
                    <div class="flex items-center gap-2"><i class="fa-solid fa-circle-check text-blue-600"></i> Miễn phí cho lần đầu</div>
                    <div class="flex items-center gap-2"><i class="fa-solid fa-circle-check text-blue-600"></i> Báo cáo PDF chuyên sâu</div>
                </div>
            </section>

            <!-- Cards section với hiệu ứng hover và animation -->
            <section class="max-w-6xl mx-auto px-6 py-12 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">

                <div class="glass-card p-8 rounded-[32px] md:col-span-2 relative overflow-hidden group card-hover fade-in delay-2">
                    <div class="w-10 h-10 bg-white shadow-sm rounded-xl flex items-center justify-center text-blue-900 mb-6 group-hover:rotate-12 transition-all">
                        <i class="fa-solid fa-gauge-high"></i>
                    </div>
                    <h3 class="text-2xl font-bold text-gray-900 mb-3">Hiệu Suất Tối Ưu</h3>
                    <p class="text-gray-500 leading-relaxed mb-6">Đánh giá tốc độ tải trang, Core Web Vitals và đề xuất các giải pháp kỹ thuật để website vận hành mượt mà nhất trên mọi thiết bị.</p>
                    <div class="h-24 bg-blue-50/50 rounded-xl border border-blue-100/50 flex items-end p-2 gap-1">
                        <div class="flex-1 bg-blue-200 rounded-t h-1/2 animate-pulse" style="animation-delay: 0s;"></div>
                        <div class="flex-1 bg-blue-300 rounded-t h-2/3 animate-pulse" style="animation-delay: 0.2s;"></div>
                        <div class="flex-1 bg-blue-400 rounded-t h-3/4 animate-pulse" style="animation-delay: 0.4s;"></div>
                        <div class="flex-1 bg-blue-300 rounded-t h-1/2 animate-pulse" style="animation-delay: 0.6s;"></div>
                        <div class="flex-1 bg-blue-500 rounded-t h-full animate-pulse" style="animation-delay: 0.8s;"></div>
                    </div>
                </div>

                <div class="bg-blue-900 p-8 rounded-[32px] text-white flex flex-col justify-between card-hover fade-in delay-2 relative overflow-hidden">
                    <div class="absolute inset-0 bg-gradient-to-br from-white/5 to-transparent"></div>
                    <div>
                        <div class="w-10 h-10 bg-white/10 rounded-xl flex items-center justify-center mb-6 group-hover:scale-110 transition-all">
                            <i class="fa-solid fa-magnifying-glass"></i>
                        </div>
                        <h3 class="text-2xl font-bold mb-3">Chiến Lược SEO</h3>
                        <p class="text-blue-100/80 leading-relaxed">Phân tích từ khóa, cấu trúc thẻ và khả năng hiển thị trên các công cụ tìm kiếm hàng đầu hiện nay.</p>
                    </div>
                    <div class="text-4xl font-black text-white/10 self-end mt-4 animate-pulse">SEO+</div>
                </div>

                <div class="bg-blue-100/50 p-8 rounded-[32px] border border-blue-200 card-hover fade-in delay-3">
                    <div class="w-10 h-10 bg-white rounded-xl flex items-center justify-center text-blue-900 mb-6 group-hover:rotate-12 transition-all">
                        <i class="fa-solid fa-compass-drafting"></i>
                    </div>
                    <h3 class="text-xl font-bold text-gray-900 mb-3">Trải Nghiệm UX</h3>
                    <p class="text-gray-500 text-sm leading-relaxed mb-4">Xác định các điểm gây khó khăn cho người dùng và tối ưu hóa luồng chuyển đổi trên trang web của bạn.</p>
                </div>

                <div class="bg-white p-8 rounded-[32px] border border-gray-100 shadow-sm md:col-span-2 flex flex-col md:flex-row gap-8 items-center card-hover fade-in delay-3">
                    <div class="flex-1">
                        <h3 class="text-xl font-bold text-gray-900 mb-3">Bảo Mật & Xu Hướng</h3>
                        <p class="text-gray-500 text-sm leading-relaxed mb-6">Kiểm tra các lỗ hổng bảo mật tiềm ẩn và so sánh phong cách thiết kế của bạn với các xu hướng hiện đại nhất năm 2024.</p>
                        <a href="#" class="text-blue-900 font-bold flex items-center gap-2 hover:gap-4 transition-all">
                            Tìm hiểu thêm <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>
                    <div class="w-full md:w-48 bg-gray-50 p-4 rounded-2xl border border-gray-100 animate-float">
                        <div class="h-2 w-2/3 bg-gray-200 rounded-full mb-3"></div>
                        <div class="h-2 w-full bg-gray-200 rounded-full mb-3"></div>
                        <div class="flex items-center gap-2">
                            <div class="w-6 h-6 rounded-full bg-gray-300 animate-pulse"></div>
                            <div class="h-2 flex-1 bg-gray-200 rounded-full"></div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Phần tin dùng và loading -->
            <section class="max-w-6xl mx-auto px-6 py-20 flex flex-col lg:flex-row gap-12 items-center">
                <div class="flex-1 fade-in delay-4">
                    <h2 class="text-4xl font-bold text-gray-900 mb-8 leading-tight">Tin dùng bởi hơn 20,000 chuyên gia Marketing</h2>
                    <div class="space-y-6">
                        <div class="flex gap-4 group">
                            <div class="w-10 h-10 bg-blue-50 text-blue-600 rounded-xl flex items-center justify-center shrink-0 group-hover:scale-110 transition-all">
                                <i class="fa-solid fa-shield-check"></i>
                            </div>
                            <div>
                                <h4 class="font-bold text-gray-900">Độ Chính Xác 99%</h4>
                                <p class="text-gray-500 text-sm">Thuật toán AI thế hệ mới đảm bảo dữ liệu luôn được cập nhật và chính xác tuyệt đối.</p>
                            </div>
                        </div>
                        <div class="flex gap-4 group">
                            <div class="w-10 h-10 bg-blue-50 text-blue-600 rounded-xl flex items-center justify-center shrink-0 group-hover:scale-110 transition-all">
                                <i class="fa-solid fa-code-merge"></i>
                            </div>
                            <div>
                                <h4 class="font-bold text-gray-900">Tích Hợp API Chuyên Sâu</h4>
                                <p class="text-gray-500 text-sm">Kết nối dễ dàng với các công cụ quản lý dữ liệu hiện có của doanh nghiệp.</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="flex-1 w-full max-w-md fade-in delay-4">
                    <div class="bg-gray-100 p-12 rounded-[40px] flex flex-col items-center justify-center border border-white text-center shadow-inner animate-border-glow">
                        <div class="relative w-24 h-24 mb-6">
                            <svg class="w-full h-full transform -rotate-90">
                            <circle cx="48" cy="48" r="40" stroke="currentColor" stroke-width="8" fill="transparent" class="text-gray-200" />
                            <circle cx="48" cy="48" r="40" stroke="currentColor" stroke-width="8" fill="transparent" stroke-dasharray="251.2" stroke-dashoffset="60" class="text-blue-900" />
                            </svg>
                            <div class="absolute inset-0 flex items-center justify-center text-blue-900">
                                <i class="fa-solid fa-gear-complex animate-spin text-xl"></i>
                            </div>
                        </div>
                        <h4 class="font-bold text-gray-900 mb-2 italic">Đang kết nối hệ thống...</h4>
                        <p class="text-gray-400 text-xs">Hệ thống AI đang chờ đợi yêu cầu phân tích đầu tiên của bạn.</p>
                    </div>
                </div>
            </section>

            <!-- Footer với hiệu ứng -->
            <footer class="border-t border-gray-200 bg-white/50 py-10">
                <div class="max-w-6xl mx-auto px-6 flex flex-col md:flex-row justify-between items-center gap-6">
                    <div class="flex items-center gap-3">
                        <div class="bg-blue-900 text-white p-2 rounded hover:rotate-12 transition-all">
                            <i class="fa-solid fa-chart-simple text-xs"></i>
                        </div>
                        <span class="font-bold text-gray-700">AI Website Analyzer</span>
                    </div>
                    <div class="flex gap-8 text-sm font-medium text-gray-500">
                        <a href="#" class="hover:text-blue-900 transition-colors hover:scale-105">Documentation</a>
                        <a href="#" class="hover:text-blue-900 transition-colors hover:scale-105">API Reference</a>
                        <a href="#" class="hover:text-blue-900 transition-colors hover:scale-105">Privacy Policy</a>
                    </div>
                </div>
                <div class="max-w-6xl mx-auto px-6 mt-8 flex flex-col md:flex-row justify-between items-center text-xs text-gray-400 gap-4">
                    <p>© 2026 AI Website Analyzer. All rights reserved.</p>
                    <div class="flex gap-4 items-center">
                        <button class="hover:text-gray-600 hover:rotate-12 transition-all"><i class="fa-solid fa-globe text-sm"></i></button>
                        <button class="hover:text-gray-600 hover:rotate-12 transition-all"><i class="fa-solid fa-share-nodes text-sm"></i></button>
                    </div>
                </div>
            </footer>
        </main>
    </body>

    <script>


        const isLoggedIn = <%= isLoggedIn%>;
        let historyLoaded = false;

        async function checkAuth(event, target) {
            if (event)
                event.preventDefault();

            // 1. Kiểm tra đăng nhập trước tiên
            if (!isLoggedIn) {
                Swal.fire({
                    title: 'Yêu cầu đăng nhập',
                    text: "Bạn cần đăng nhập để xem lịch sử!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#002060',
                    confirmButtonText: 'Đăng nhập ngay',
                    cancelButtonText: 'Để sau'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = "${pageContext.request.contextPath}/View/Login.jsp";
                    }
                });
                return false;
            }

            // 2. Nếu đã đăng nhập, xử lý UI
            if (target === 'history') {
                const container = document.getElementById("historyList");
                container.classList.toggle('hidden');

                // Chỉ load dữ liệu nếu đang mở và chưa load lần nào
                if (!container.classList.contains('hidden') && !historyLoaded) {
                    await loadHistory();
                }
            } else if (target && target !== '#') {
                window.location.href = target;
            }
        }

//        async function loadHistory() {
//            const container = document.getElementById("historyList");
//            container.innerHTML = "<div class='text-[10px] text-gray-400 p-2 italic'>Đang tải...</div>";
//
//            try {
//                const res = await fetch('<%=request.getContextPath()%>/HistoryServlet');
//                const data = await res.json();
//
//                container.innerHTML = "";
//                if (data.length === 0) {
//                    container.innerHTML = "<div class='text-xs text-gray-400 p-2'>Chưa có lịch sử</div>";
//                    return;
//                }
//
//                data.forEach(item => {
//                    const div = document.createElement("div");
//                    // Sử dụng history-item đã định nghĩa ở CSS trên
//                    div.className = "history-item p-2.5 rounded-lg text-[11px] bg-gray-50 border border-gray-100 hover:border-blue-300 hover:text-blue-900 cursor-pointer transition-all mb-2 shadow-sm";
//
//                    // Cấu trúc lại để icon và text không bị đè nhau
//                    div.innerHTML = `
//                <div class="flex items-start gap-2">
//                    <i class="fa-regular fa-clock mt-0.5 flex-shrink-0 text-blue-700"></i>
//                    <span class="font-medium">${item.time}</span>
//                </div>
//            `;
//
//                    div.onclick = () => {
//                        window.location.href = "result.jsp?id=" + item.id;
//                    };
//                    container.appendChild(div);
//                });
//                historyLoaded = true;
//            } catch (err) {
//                container.innerHTML = "<div class='text-xs text-red-400 p-2'>Lỗi tải dữ liệu</div>";
//            }
//        }

async function loadHistory() {
            const container = document.getElementById("historyList");
            container.innerHTML = "<div class='text-[11px] text-gray-500 p-3 italic text-center'>Đang tải dữ liệu...</div>";

            try {
                const res = await fetch('<%=request.getContextPath()%>/HistoryServlet');
                
                if (!res.ok) throw new Error("Lỗi kết nối Server");

                const data = await res.json();

                container.innerHTML = "";

                if (data.error) {
                    container.innerHTML = "<div class='text-xs text-red-500 p-2 text-center'>" + data.error + "</div>";
                    return;
                }

                if (!Array.isArray(data) || data.length === 0) {
                    container.innerHTML = "<div class='text-xs text-gray-400 p-2 text-center'>Chưa có lịch sử phân tích</div>";
                    return;
                }

                data.forEach(item => {
                    const div = document.createElement("div");
                    
                    // Style hiển thị cho từng mục lịch sử
                    div.className = "flex flex-col items-start w-full p-3 mb-2.5 bg-white border border-gray-200 rounded-xl hover:border-blue-400 hover:bg-blue-50 hover:shadow-md cursor-pointer transition-all overflow-hidden";

                    // 1. Lấy thời gian (Nếu cũ quá không có thì lấy ID băm ra)
                    let displayTime = item.time;
                    if (!displayTime && item.id && item.id.toString().length >= 12) {
                        const idStr = item.id.toString();
                        displayTime = idStr.substring(6,8) + '/' + idStr.substring(4,6) + '/' + idStr.substring(0,4) + ' ' + idStr.substring(8,10) + ':' + idStr.substring(10,12);
                    } else if (!displayTime) {
                        displayTime = "Đang cập nhật...";
                    }

                    // 2. Lấy URL
                    let displayUrl = item.url || "Báo cáo Website";

                     div.innerHTML = 
                        '<span class="block w-full font-bold text-blue-900 text-[11px] truncate mb-1.5" title="' + displayUrl + '">' +
                            displayUrl +
                        '</span>' +
                        '<div class="flex items-center gap-1.5 text-gray-500 w-full text-[10px]">' +
                            '<i class="fa-regular fa-clock text-blue-500"></i>' +
                            '<span class="font-medium">' + displayTime + '</span>' +
                        '</div>';

                    // Sự kiện click để chuyển trang
                    div.onclick = () => {
                        window.location.href = "result.jsp?id=" + item.id;
                    };
                    
                    container.appendChild(div);
                });
                historyLoaded = true;
            } catch (err) {
                console.error("Lỗi khi tải lịch sử:", err);
                container.innerHTML = "<div class='text-xs text-red-500 p-2 text-center font-medium'>❌ Lỗi kết nối dữ liệu</div>";
            }
        }
// 3. Hàm xử lý phân tích
        function handleAnalyze() {
            const urlInput = document.getElementById("urlInput").value;
            if (!isLoggedIn) {
                checkAuth();
                return;
            }
            if (urlInput.trim() === "") {
                Swal.fire('Thông báo', 'Vui lòng nhập URL website!', 'info');
                return;
            }
            document.getElementById("analyzeForm").submit();
        }

// Giữ lại DOMContentLoaded nhưng chỉ để log hoặc init nhẹ, không gán thêm sự kiện click nữa
        document.addEventListener("DOMContentLoaded", function () {
            console.log("Hệ thống đã sẵn sàng.");
        });
    </script>   
</html>
