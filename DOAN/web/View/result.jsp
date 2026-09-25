<%-- 
    Document   : result
    Created on : 17 thg 3, 2026, 22:57:27
    Author     : pvbmi
--%>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- 
    Document   : result
    Created on : 17 thg 3, 2026, 22:57:27
    Author     : pvbmi
--%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>AI Marketing Report | Giao diện động</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" />
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <style>
            body {
                background: linear-gradient(135deg, #f0f4fc 0%, #e9eef5 100%);
                font-family: 'Inter', system-ui, -apple-system, sans-serif;
            }
            @keyframes fadeSlideUp {
                0% {
                    opacity: 0;
                    transform: translateY(20px);
                }
                100% {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            .animate-fade-slide {
                animation: fadeSlideUp 0.5s cubic-bezier(0.2, 0.9, 0.4, 1) forwards;
            }
            .card-hover {
                transition: all 0.25s ease-in-out;
                cursor: pointer;
                overflow: hidden;
            }
            .card-hover:hover {
                transform: translateY(-6px);
                box-shadow: 0 20px 25px -12px rgba(0, 0, 0, 0.2);
            }
            .score-card {
                transition: all 0.3s ease;
                border-bottom: 3px solid transparent;
            }
            .score-card:hover {
                transform: translateY(-5px);
                border-bottom-color: currentColor;
            }
            .plan-btn-active {
                background-color: #2563eb !important;
                color: white !important;
            }
            .plan-day, .plan-week {
                transition: all 0.2s;
                background: white;
                border-radius: 0.75rem;
                padding: 0.5rem 0.25rem;
                text-align: center;
                cursor: pointer;
            }
            .plan-day:hover, .plan-week:hover {
                background: #dbeafe;
                transform: translateY(-2px);
            }
            #plan-detail {
                border-left: 4px solid #3b82f6;
            }
            .loading-spinner {
                display: inline-block;
                width: 20px;
                height: 20px;
                border: 2px solid #f3f3f3;
                border-top: 2px solid #3b82f6;
                border-radius: 50%;
                animation: spin 1s linear infinite;
                margin-right: 8px;
            }
            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }
        </style>
    </head>
    <body class="p-6">

        <div id="mainApp" class="hidden max-w-7xl mx-auto space-y-6">
            <div class="bg-white/90 backdrop-blur-sm p-6 rounded-2xl shadow-xl border border-white/50 animate-fade-slide">
                <div class="flex flex-wrap justify-between items-center">
                    <div>
                        <h1 class="text-3xl font-extrabold bg-gradient-to-r from-blue-700 to-indigo-600 bg-clip-text text-transparent">
                            ✨ AI Marketing Report
                        </h1>
                        <p id="res-url" class="text-blue-600 text-sm mt-1 font-mono break-all"></p>
                        <p id="res-summary" class="text-gray-600 mt-2 italic border-l-3 border-blue-300 pl-3"></p>
                    </div>
                    <div class="bg-blue-100 rounded-full px-4 py-1 text-xs text-blue-700 font-semibold">
                        Phân tích thông minh
                    </div>
                </div>
            </div>

            <div class="grid grid-cols-2 md:grid-cols-4 gap-5 animate-fade-slide" style="animation-delay: 0.05s;">
                <div class="score-card bg-white p-5 rounded-2xl text-center shadow-md border-b-4 border-blue-500">
                    <p class="text-gray-500 text-sm uppercase">Marketing</p>
                    <h2 id="score-mkt" class="text-4xl font-extrabold text-blue-600">0</h2>
                </div>
                <div class="score-card bg-white p-5 rounded-2xl text-center shadow-md border-b-4 border-green-500">
                    <p class="text-gray-500 text-sm uppercase">SEO</p>
                    <h2 id="score-seo" class="text-4xl font-extrabold text-green-600">0</h2>
                </div>
                <div class="score-card bg-white p-5 rounded-2xl text-center shadow-md border-b-4 border-purple-500">
                    <p class="text-gray-500 text-sm uppercase">Content</p>
                    <h2 id="score-cnt" class="text-4xl font-extrabold text-purple-600">0</h2>
                </div>
                <div class="score-card bg-white p-5 rounded-2xl text-center shadow-md border-b-4 border-orange-500">
                    <p class="text-gray-500 text-sm uppercase">Conversion</p>
                    <h2 id="score-cvs" class="text-4xl font-extrabold text-orange-600">0</h2>
                </div>
            </div>

            <div class="grid md:grid-cols-3 gap-6 animate-fade-slide" style="animation-delay: 0.1s;">
                <div class="bg-white/90 backdrop-blur-sm p-6 rounded-2xl shadow-lg">
                    <h3 class="font-bold mb-4 text-red-600 text-xl flex items-center gap-2">
                        <span>🔥</span> 5 Việc Cần Làm Ngay
                    </h3>
                    <ul id="res-recommendations" class="space-y-3"></ul>
                </div>

                <div class="md:col-span-2">
                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
                        <div onclick="viewReport('business_analysis', 'Business Analysis')" class="card-hover bg-gradient-to-br from-blue-50 to-blue-100 p-5 rounded-xl shadow-md flex flex-col items-center text-center">
                            <span class="text-4xl mb-2">📊</span>
                            <span class="font-semibold text-blue-800">Business Analysis</span>
                        </div>
                        <div onclick="viewReport('marketing_strategy', 'Marketing Strategy')" class="card-hover bg-gradient-to-br from-green-50 to-green-100 p-5 rounded-xl shadow-md flex flex-col items-center text-center">
                            <span class="text-4xl mb-2">🎯</span>
                            <span class="font-semibold text-green-800">Marketing Strategy</span>
                        </div>
                        <div onclick="viewReport('content_generation', 'Content')" class="card-hover bg-gradient-to-br from-purple-50 to-purple-100 p-5 rounded-xl shadow-md flex flex-col items-center text-center">
                            <span class="text-4xl mb-2">✍️</span>
                            <span class="font-semibold text-purple-800">Content AI</span>
                        </div>
                        <div onclick="viewReport('competitor_analysis', 'Competitor')" class="card-hover bg-gradient-to-br from-pink-50 to-pink-100 p-5 rounded-xl shadow-md flex flex-col items-center text-center">
                            <span class="text-4xl mb-2">🔍</span>
                            <span class="font-semibold text-pink-800">Competitor</span>
                        </div>
                        <div onclick="viewReport('seo_analysis', 'SEO')" class="card-hover bg-gradient-to-br from-teal-50 to-teal-100 p-5 rounded-xl shadow-md flex flex-col items-center text-center">
                            <span class="text-4xl mb-2">📈</span>
                            <span class="font-semibold text-teal-800">SEO</span>
                        </div>
                        <!--                        <div onclick="viewHTML('landing_page', 'Landing Page')" class="card-hover bg-gradient-to-br from-indigo-50 to-indigo-100 p-5 rounded-xl shadow-md flex flex-col items-center text-center">
                                                    <span class="text-4xl mb-2">🌐</span>
                                                    <span class="font-semibold text-indigo-800">Landing Page</span>
                                                </div>-->

                        <div onclick="openPopup()" class="card-hover bg-gradient-to-br from-indigo-50 to-indigo-100 p-5 rounded-xl shadow-md flex flex-col items-center text-center">
                            <span class="text-4xl mb-2">🌐</span>
                            <span class="font-semibold text-indigo-800">Landing Page</span>
                        </div>



                        <div onclick="viewReport('customer_insights', 'Customer')" class="card-hover bg-gradient-to-br from-yellow-50 to-yellow-100 p-5 rounded-xl shadow-md flex flex-col items-center text-center">
                            <span class="text-4xl mb-2">👥</span>
                            <span class="font-semibold text-yellow-800">Customer Insight</span>
                        </div>
                        <div onclick="viewReport('marketing_plan', 'Marketing Plan')" class="card-hover bg-gradient-to-br from-cyan-50 to-cyan-100 p-5 rounded-xl shadow-md flex flex-col items-center text-center">
                            <span class="text-4xl mb-2">📅</span>
                            <span class="font-semibold text-cyan-800">Marketing Plan</span>
                        </div>

                        <div id="btn-container" class="relative group max-w-sm">
                            <div id="main-button" onclick="triggerAutomation()" class="cursor-pointer bg-white p-6 rounded-2xl shadow-lg border border-blue-100 flex flex-col items-center text-center transition-all hover:shadow-2xl hover:-translate-y-1 active:scale-95">
                                <div class="w-16 h-16 bg-blue-50 rounded-full flex items-center justify-center mb-4">
                                    <span class="text-4xl">📊</span>
                                </div>
                                <span class="block font-bold text-blue-900 text-xl">Free Ads 30day</span>
                                <span class="block text-sm text-blue-500 font-medium">Automation Engine</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="bg-white/90 backdrop-blur-sm p-6 rounded-2xl shadow-lg animate-fade-slide" style="animation-delay: 0.15s;">
                <h3 class="font-bold mb-4 text-2xl flex items-center gap-2">
                    📅 Kế hoạch Marketing
                    <span class="text-sm bg-blue-100 text-blue-700 px-3 py-0.5 rounded-full">Chiến lược tuần / tháng</span>
                </h3>
                <div class="flex gap-3 mb-6">
                    <button id="btnWeek" onclick="showPlan('week')" class="px-5 py-2 rounded-full font-medium shadow-sm bg-blue-500 text-white">🗓️ 7 ngày</button>
                    <button id="btnMonth" onclick="showPlan('month')" class="px-5 py-2 rounded-full font-medium shadow-sm bg-gray-200 text-gray-700">📆 30 ngày</button>
                </div>
                <div id="plan-navigation" class="mb-4 hidden">
                    <button onclick="showPlan(currentPlanType)" class="text-sm text-blue-600 hover:text-blue-800">← Quay lại danh sách</button>
                </div>
                <div id="plan-days" class="grid grid-cols-4 sm:grid-cols-7 gap-2 mb-6"></div>
                <div id="plan-detail" class="p-5 bg-gradient-to-r from-gray-50 to-white rounded-xl shadow-inner text-gray-700">
                    ✨ Chọn ngày để xem nội dung chi tiết kế hoạch
                </div>
            </div>
        </div>

        <div id="custom-modal" class="hidden fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-md">
            <div id="modal-box" class="bg-white rounded-3xl shadow-2xl max-w-sm w-full p-8 transform transition-all scale-95 opacity-0 duration-300">
                <div id="step-1" class="flex flex-col items-center text-center">
                    <div class="w-20 h-20 bg-blue-50 rounded-full flex items-center justify-center mb-4 animate-pulse">
                        <span class="text-4xl">🚀</span>
                    </div>
                    <h3 class="text-2xl font-bold text-gray-800 mb-2">Bắt đầu chiến dịch?</h3>
                    <p class="text-gray-500 mb-8">Hệ thống sẽ chuẩn bị nội dung cho 30 ngày tới.</p>
                    <div class="flex gap-3 w-full">
                        <button onclick="closeModal()" class="flex-1 py-3 px-4 bg-gray-100 text-gray-600 font-semibold rounded-xl hover:bg-gray-200">Hủy</button>
                        <button onclick="goToStep2()" class="flex-1 py-3 px-4 bg-blue-600 text-white font-semibold rounded-xl shadow-lg">Tiếp tục</button>
                    </div>
                </div>
                <div id="step-2" class="hidden flex flex-col items-center text-center">
                    <h3 class="text-xl font-bold text-gray-800 mb-6">Chọn nơi đăng bài</h3>
                    <div class="grid grid-cols-1 gap-3 w-full mb-8">
                        <button onclick="finalConfirm('facebook')" class="group flex items-center gap-4 p-4 rounded-2xl border-2 border-blue-50 hover:border-blue-500 hover:bg-blue-50 transition-all">
                            <span class="text-3xl"><i class="fa-brands fa-facebook"></i></span>
                            <span class="font-bold text-gray-700 group-hover:text-blue-700">Facebook Ads</span>
                        </button>
                        <button onclick="finalConfirm('tiktok')" class="group flex items-center gap-4 p-4 rounded-2xl border-2 border-pink-50 hover:border-pink-500 hover:bg-pink-50 transition-all">
                            <span class="text-3xl"><i class="fa-brands fa-tiktok"></i></span>
                            <span class="font-bold text-gray-700 group-hover:text-pink-700">TikTok Ads</span>
                        </button>
                        <button onclick="finalConfirm('both')" class="group flex items-center gap-4 p-4 rounded-2xl border-2 border-purple-50 hover:border-purple-500 hover:bg-purple-50 transition-all">
                            <span class="text-3xl">🔥</span>
                            <span class="font-bold text-gray-700 group-hover:text-purple-700">Đăng cả hai</span>
                        </button>
                    </div>
                    <button onclick="backToStep1()" class="text-sm text-gray-400 hover:text-gray-600 underline">Quay lại</button>
                </div>
            </div>
        </div>

        <script>
            // Khai báo biến toàn cục duy nhất
            let reportData = null;
            let planData = {week: [], month: []};
            let currentPlanType = 'week';
            let selectedWeekIndex = null;
            let currentId = null;
            let dt=null;

            // ==========================================
            // 1. TẢI DỮ LIỆU TỪ SERVER KHI MỞ TRANG
            // ==========================================
            window.onload = async function () {
                const urlParams = new URLSearchParams(window.location.search);
                currentId = urlParams.get('id');

                if (!currentId) {
                    showError('Lỗi', 'Không tìm thấy ID báo cáo.');
                    return;
                }

                try {
                    // Lấy dữ liệu từ Backend
                    const response = await fetch('<%= request.getContextPath()%>/HistoryServlet?id=' + currentId);
                    const data = await response.json();

                    if (data.error) {
                        showError("Lỗi dữ liệu", data.error);
                        return;
                    }

                    reportData = data.result || data;
dt = data;
                    // Đổ dữ liệu cơ bản
                    document.getElementById('res-url').innerText = "URL: " + (data.url || "");
                    document.getElementById('res-summary').innerText = reportData.summary || reportData.business_analysis?.summary || "Đã tải xong dữ liệu phân tích.";

                    // Đổ Điểm số
                    const scores = reportData.scores || {};
                    document.getElementById('score-mkt').innerText = scores.marketing || scores.Marketing || 0;
                    document.getElementById('score-seo').innerText = scores.seo || scores.SEO || 0;
                    document.getElementById('score-cnt').innerText = scores.content || scores.Content || 0;
                    document.getElementById('score-cvs').innerText = scores.conversion || scores.Conversion || 0;

                    // Đổ dữ liệu vào danh sách "5 Việc Cần Làm Ngay"
                    let recommendations = reportData.recommendations || reportData.quick_wins || [];
                    if (recommendations.length === 0 && reportData.marketing_plan?.plan_7_days) {
                        recommendations = Object.values(reportData.marketing_plan.plan_7_days).slice(0, 5);
                    }

                    const recContainer = document.getElementById('res-recommendations');
                    recContainer.innerHTML = '';
                    if (recommendations.length > 0) {
                        let i=1;
                        recommendations.slice(0, 5).forEach(task => {
                            // Dùng cộng chuỗi để tránh lỗi JSP EL
                            recContainer.innerHTML +=
                                    '<li class="flex items-start gap-3 bg-red-50 p-3 rounded-lg border border-red-100">' +
                                    '<span class="text-red-500 mt-0.5">'+(i++)+ '. </span>' +
                                    '<span class="text-gray-700 text-sm leading-relaxed">' + task + '</span>' +
                                    '</li>';
                        });
                    } else {
                        recContainer.innerHTML = '<li class="text-gray-500 italic p-3">Đang cập nhật danh sách...</li>';
                    }

                    // Mở khóa ẩn giao diện chính
                    document.getElementById('mainApp').classList.remove('hidden');

                    // Chạy logic phân loại Tuần/Ngày
                    initPlan();

                } catch (err) {
                    console.error("Fetch Error:", err);
                    showError('Lỗi kết nối', 'Không thể đọc dữ liệu phân tích từ máy chủ.');
                }
            };

            // ==========================================
            // CÁC HÀM XỬ LÝ KẾ HOẠCH & GIAO DIỆN
            // ==========================================
            function showError(title, message) {
                Swal.fire({
                    icon: 'error',
                    title: title,
                    text: message,
                    confirmButtonColor: '#3b82f6'
                });
            }


            function openPopup() {
                const url = reportData?.url;
                const urlbackup = dt.url;
                console.log(url);
                if (!url && !urlbackup) {
                    Swal.fire("Lỗi", "Không tìm thấy URL.", "error");
                    return;
                }
                if(!url){
                const features = "width=1000,height=700,resizable=yes,scrollbars=yes,toolbar=yes,location=yes";
                const popup = window.open(urlbackup, "_blank", features);
                if (!popup) {
                    Swal.fire({
                        icon: "warning",
                        title: "Popup bị chặn",
                        text: "Vui lòng cho phép pop-up cho trang web này.",
                        confirmButtonColor: "#3b82f6"
                    });
                }
            }
            else if(!urlbackup){
                const features = "width=1000,height=700,resizable=yes,scrollbars=yes,toolbar=yes,location=yes";
                const popup = window.open(url, "_blank", features);
                if (!popup) {
                    Swal.fire({
                        icon: "warning",
                        title: "Popup bị chặn",
                        text: "Vui lòng cho phép pop-up cho trang web này.",
                        confirmButtonColor: "#3b82f6"
                    });
                } 
            }
            
            if(!(!url && !urlbackup)){
                const features = "width=1000,height=700,resizable=yes,scrollbars=yes,toolbar=yes,location=yes";
                const popup = window.open(url, "_blank", features);
                if (!popup) {
                    Swal.fire({
                        icon: "warning",
                        title: "Popup bị chặn",
                        text: "Vui lòng cho phép pop-up cho trang web này.",
                        confirmButtonColor: "#3b82f6"
                    });
                } 
                }            
                
            }
            function initPlan() {
                const details = reportData.details || {};
                const rawPlan = details.marketing_plan || reportData.marketing_plan || {};
                planData.week = [];
                planData.month = [];

                if (rawPlan.plan_7_days) {
                    planData.week = Object.values(rawPlan.plan_7_days);
                } else if (rawPlan.plan7) {
                    planData.week = Object.values(rawPlan.plan7);
                }

                if (rawPlan.plan_30_days) {
                    planData.month = Object.values(rawPlan.plan_30_days);
                } else if (rawPlan.plan30) {
                    planData.month = Object.values(rawPlan.plan30);
                }

                if (planData.month.length === 0 && planData.week.length > 0) {
                    planData.month = [...planData.week];
                } else if (planData.week.length === 0 && typeof rawPlan === "string") {
                    let text = rawPlan;
                    let days = text.split(/(?=Ngày\s*\d+)/i).map(s => s.trim()).filter(s => s.length > 5);
                    planData.week = days.slice(0, 7);
                    planData.month = days.slice(0, 30);
                }
                showPlan('week');
            }

            function showPlan(type) {
                currentPlanType = type;
                selectedWeekIndex = null;
                const weekBtn = document.getElementById('btnWeek');
                const monthBtn = document.getElementById('btnMonth');

                if (type === 'week') {
                    weekBtn.classList.add('plan-btn-active', 'bg-blue-500', 'text-white');
                    weekBtn.classList.remove('bg-gray-200', 'text-gray-700');
                    monthBtn.classList.remove('plan-btn-active', 'bg-blue-500', 'text-white');
                    monthBtn.classList.add('bg-gray-200', 'text-gray-700');
                    document.getElementById('plan-navigation').classList.add('hidden');
                } else {
                    monthBtn.classList.add('plan-btn-active', 'bg-blue-500', 'text-white');
                    monthBtn.classList.remove('bg-gray-200', 'text-gray-700');
                    weekBtn.classList.remove('plan-btn-active', 'bg-blue-500', 'text-white');
                    weekBtn.classList.add('bg-gray-200', 'text-gray-700');
                    document.getElementById('plan-navigation').classList.remove('hidden');
                }
                renderPlanView();
            }

            function renderPlanView() {
                const container = document.getElementById('plan-days');
                container.innerHTML = "";

                if (currentPlanType === 'week') {
                    planData.week.forEach((d, i) => {
                        const dayDiv = document.createElement("div");
                        dayDiv.className = "plan-day cursor-pointer text-center p-2 border rounded-lg hover:bg-blue-50";
                        dayDiv.innerHTML = '<span class="block text-sm font-bold text-blue-600">Ngày ' + (i + 1) + '</span>';
                        dayDiv.onclick = () => showDetail('week', i);
                        container.appendChild(dayDiv);
                    });
                } else {
                    if (selectedWeekIndex === null) {
                        const totalWeeks = Math.ceil(planData.month.length / 7);
                        for (let idx = 0; idx < totalWeeks; idx++) {
                            const weekDiv = document.createElement("div");
                            weekDiv.className = "plan-week cursor-pointer text-center p-2 border rounded-lg bg-indigo-50 hover:bg-indigo-100";
                            weekDiv.innerHTML = '<span class="block text-sm font-bold text-indigo-700">Tuần ' + (idx + 1) + '</span>';
                            weekDiv.onclick = () => {
                                selectedWeekIndex = idx;
                                renderPlanView();
                            };
                            container.appendChild(weekDiv);
                        }
                    } else {
                        const weeks = chunkArray(planData.month, 7);
                        const weekDays = weeks[selectedWeekIndex] || [];
                        weekDays.forEach((day, i) => {
                            const dayDiv = document.createElement("div");
                            dayDiv.className = "plan-day cursor-pointer text-center p-2 border rounded-lg hover:bg-green-50";
                            const realDayNumber = (selectedWeekIndex * 7) + i + 1;
                            dayDiv.innerHTML = '<span class="block text-sm font-bold text-green-600">Ngày ' + realDayNumber + '</span>';
                            dayDiv.onclick = () => showDetail('month', (selectedWeekIndex * 7) + i);
                            container.appendChild(dayDiv);
                        });
                    }
                }
            }

            function chunkArray(arr, size) {
                const result = [];
                for (let i = 0; i < arr.length; i += size)
                    result.push(arr.slice(i, i + size));
                return result;
            }

            function showDetail(type, i) {
                const detailBox = document.getElementById('plan-detail');
                let content = (type === 'week') ? planData.week[i] : planData.month[i];
                if (!content) {
                    detailBox.innerText = "❌ Không có dữ liệu cho ngày này";
                    return;
                }
                detailBox.innerText = content;
            }

            function renderObject(obj, level = 0) {
                let html = '<div class="space-y-5 text-left w-full">';
                for (const key in obj) {
                    const value = obj[key];
                    const formattedKey = key.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase());
                    html += '<div class="bg-white border border-gray-100 rounded-2xl p-5 shadow-sm hover:shadow-md transition-shadow duration-300">';
                    html += '<div class="flex items-center gap-3 mb-4 border-b border-gray-50 pb-3">' +
                            '<div class="w-10 h-10 rounded-full bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center text-blue-600 shadow-inner">' +
                            '<i class="fa-solid fa-cube text-lg"></i>' +
                            '</div>' +
                            '<h4 class="font-bold text-gray-800 text-lg uppercase tracking-wide">' + formattedKey + '</h4>' +
                            '</div>';
                    if (Array.isArray(value)) {
                        html += '<ul class="space-y-3 ml-2">';
                        for (let i = 0; i < value.length; i++) {
                            html += '<li class="flex items-start gap-3 p-3 bg-gray-50/50 hover:bg-blue-50/50 rounded-xl transition-colors border border-transparent hover:border-blue-100">' +
                                    '<span class="text-blue-500 mt-0.5"><i class="fa-solid fa-circle-check"></i></span>' +
                                    '<span class="text-gray-700 leading-relaxed">' + value[i] + '</span>' +
                                    '</li>';
                        }
                        html += '</ul>';
                    } else if (typeof value === "object" && value !== null) {
                        html += '<div class="pl-4 border-l-2 border-indigo-200 mt-2 bg-slate-50 rounded-r-xl p-3">';
                        html += renderObject(value, level + 1);
                        html += '</div>';
                    } else {
                        html += '<div class="text-gray-700 leading-relaxed bg-gray-50 p-4 rounded-xl border border-gray-100 shadow-inner">' + value + '</div>';
                    }
                    html += '</div>';
                }
                html += '</div>';
                return html;
            }

            function viewReport(key, title) {
                let content = reportData.details?.[key] || reportData[key];
                if (!content) {
                    Swal.fire({icon: 'warning', title: 'Opps...', text: 'Không có dữ liệu cho phần này!', confirmButtonColor: '#3b82f6'});
                    return;
                }
                let html = "";
                if (typeof content === "object") {
                    html = renderObject(content);
                } else {
                    html = '<div class="text-left bg-gray-50 p-6 rounded-2xl text-gray-700 leading-relaxed border border-gray-200 shadow-inner text-base">' +
                            String(content).replace(/\n/g, "<br>") +
                            '</div>';
                }
                Swal.fire({
                    title: '<h2 class="text-3xl font-extrabold bg-gradient-to-r from-blue-700 to-indigo-600 bg-clip-text text-transparent mb-2">' + title + '</h2>',
                    html: html,
                    width: "900px",
                    padding: "1.5em",
                    background: "#f8fafc",
                    showCloseButton: true,
                    confirmButtonText: '<i class="fa-solid fa-check mr-2"></i> Đã hiểu',
                    buttonsStyling: false,
                    customClass: {
                        popup: 'rounded-[2rem] shadow-2xl border border-white',
                        title: 'border-b border-gray-200 pb-4',
                        htmlContainer: 'mt-6 p-1',
                        confirmButton: 'mt-4 px-8 py-3 bg-blue-600 text-white font-bold rounded-xl shadow-lg hover:bg-blue-700 hover:-translate-y-1 transition-all duration-200',
                        closeButton: 'text-gray-400 hover:text-red-500 focus:outline-none text-2xl mt-2 mr-2'
                    }
                });
            }

            function viewHTML(key, title) {
                const html = reportData?.details?.[key] || reportData?.[key];
                if (!html) {
                    Swal.fire("Lỗi", "Không có HTML!", "error");
                    return;
                }
                const blob = new Blob([html], {type: "text/html"});
                const url = URL.createObjectURL(blob);
                Swal.fire({
                    title: title,
                    width: "1100px",
                    html: '<iframe style="width:65%;height:200px;border:none" src="' + url + '"></iframe>',
                    showCloseButton: true
                });
            }

            // ==========================================
            // XỬ LÝ MODAL & TẠO BÀI VIẾT (API)
            // ==========================================
            async function triggerAutomation() {
                if (!currentId) {
                    Swal.fire("Lỗi", "Không tìm thấy ID dự án. Vui lòng phân tích lại website.", "error");
                    return;
                }

                try {
                    const checkRes = await fetch('<%= request.getContextPath()%>/api/check-plan?PT_id=' + currentId);
                    if (checkRes.ok) {
                        const checkData = await checkRes.json();
                        if (checkData.exists) {
                            Swal.fire({
                                title: 'Kế hoạch đã tồn tại!',
                                text: 'Hệ thống đã có bài viết cho dự án này.',
                                icon: 'info',
                                showCancelButton: true,
                                confirmButtonText: 'Xem danh sách bài đã có',
                                cancelButtonText: 'Đóng',
                                confirmButtonColor: '#3b82f6'
                            }).then((result) => {
                                if (result.isConfirmed) {
                                    window.location.href = "<%= request.getContextPath()%>/View/created-posts.jsp?PT_id=" + currentId;
                                }
                            });
                            return;
                        }
                    }
                } catch (err) {
                    console.warn("check-plan API error", err);
                }

                const modal = document.getElementById('custom-modal');
                const modalBox = document.getElementById('modal-box');
                modal.classList.remove('hidden');
                backToStep1();
                setTimeout(() => {
                    modalBox.classList.remove('scale-95', 'opacity-0');
                    modalBox.classList.add('scale-100', 'opacity-100');
                }, 10);
            }

            function goToStep2() {
                document.getElementById('step-1').classList.add('hidden');
                document.getElementById('step-2').classList.remove('hidden');
            }

            function backToStep1() {
                document.getElementById('step-2').classList.add('hidden');
                document.getElementById('step-1').classList.remove('hidden');
            }

            function closeModal() {
                const modalBox = document.getElementById('modal-box');
                const modal = document.getElementById('custom-modal');
                modalBox.classList.add('scale-95', 'opacity-0');
                setTimeout(() => modal.classList.add('hidden'), 300);
            }

            async function finalConfirm(platform) {
                closeModal();

                const {value: times} = await Swal.fire({
                    title: 'Chọn 3 khung giờ đăng',
                    html: `
                         <label class="block mt-2">Sáng</label>
                         <input id="t1" type="time" value="08:00" class="swal2-input mt-0">
                         <label class="block mt-2">Trưa</label>
                         <input id="t2" type="time" value="12:00" class="swal2-input mt-0">
                         <label class="block mt-2">Tối</label>
                         <input id="t3" type="time" value="19:00" class="swal2-input mt-0">
                     `,
                    focusConfirm: false,
                    preConfirm: () => {
                        return {
                            morning: document.getElementById('t1').value,
                            noon: document.getElementById('t2').value,
                            evening: document.getElementById('t3').value
                        };
                    }
                });

                if (!times)
                    return;

                const webUrl = reportData.url || "";
                if (!currentId) {
                    Swal.fire("Lỗi", "Không có ID dự án.", "error");
                    return;
                }

                Swal.fire({
                    title: 'Hệ thống AI đang viết bài...',
                    html: 'Quá trình này có thể mất <b>1 - 2 phút</b>.<br>Vui lòng không đóng trình duyệt!',
                    allowOutsideClick: false,
                    didOpen: () => Swal.showLoading()
                });

                try {
                    const response = await fetch('<%= request.getContextPath()%>/api/create-plan', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json; charset=UTF-8',
                            'Accept': 'application/json'
                        },
                        body: JSON.stringify({
                            platform: platform,
                            url: webUrl,
                            PT_id: currentId,
                            schedule: times
                        })
                    });

                    if (!response.ok)
                        throw new Error(`HTTP ${response.status}`);

                    const data = await response.json();
                    if (data.status === "success") {
                        Swal.fire({
                            icon: 'success',
                            title: 'Hoàn tất! 🚀',
                            text: data.message || 'Đã tạo xong bài viết cho 30 ngày.'
                        }).then(() => {
                            const mainButton = document.getElementById('main-button');
                            const btnTitle = mainButton.querySelector('.text-blue-900');
                            const btnSub = mainButton.querySelector('.text-blue-500');
                            btnTitle.innerText = "View Created Posts";
                            btnSub.innerText = "Kế hoạch đã sẵn sàng";
                            mainButton.classList.replace('bg-white', 'bg-green-50');
                            mainButton.onclick = () => window.location.href = "<%= request.getContextPath()%>/View/created-posts.jsp?PT_id=" + currentId;
                        });
                    } else {
                        Swal.fire('Lỗi Sinh Bài', data.message || 'Có lỗi từ AI', 'error');
                    }
                } catch (err) {
                    console.error("Lỗi gọi API create-plan:", err);
                    Swal.fire('Lỗi Mạng', 'Không thể kết nối đến máy chủ Java. Vui lòng thử lại sau.', 'error');
                }
            }
        </script>
    </body>
</html>