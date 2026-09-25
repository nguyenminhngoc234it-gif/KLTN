<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, Model.Config" %>
<%
    request.setCharacterEncoding("UTF-8");
    String action = request.getParameter("action");
    
    // XỬ LÝ CẬP NHẬT DỮ LIỆU
    if ("update_post".equals(action)) {
        String postId = request.getParameter("post_id");
        String isPostNow = request.getParameter("post_now");
        String currentPlatform = request.getParameter("current_platform");
        String currentStatus = request.getParameter("current_status");
        String imageUrl = request.getParameter("image_url"); 
        String content = request.getParameter("content");

        Connection connUpdate = null;
        try {
            Class.forName("org.sqlite.JDBC");
            connUpdate = DriverManager.getConnection("jdbc:sqlite:" + Model.Config.POSTS_DB_PATH);
            String newStatus = currentStatus;
            int approved = 0;
            
            if ("true".equals(isPostNow)) {
                approved = 1;
                // Logic gộp trạng thái posted
                if (currentStatus.equals("posted_" + (currentPlatform.equals("facebook") ? "tiktok" : "facebook"))) {
                    newStatus = "posted_both";
                } else {
                    newStatus = "posted_" + currentPlatform;
                }
            } else { 
                newStatus = "draft"; 
            }

            String sqlUpdate = "UPDATE posts SET content = ?, image_url = ?, approved = ?, status = ? WHERE id = ?";
            PreparedStatement pstmt = connUpdate.prepareStatement(sqlUpdate);
            pstmt.setString(1, content);
            pstmt.setString(2, imageUrl);
            pstmt.setInt(3, approved);
            pstmt.setString(4, newStatus);
            pstmt.setInt(5, Integer.parseInt(postId));
            pstmt.executeUpdate();
        } catch (Exception e) { 
            out.print("<script>console.error('Lỗi DB: " + e.getMessage() + "');</script>"); 
        } finally { 
            if (connUpdate != null) connUpdate.close(); 
        }
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SME Growth Engine - Content Manager</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;14..32,400;14..32,500;14..32,600;14..32,700;14..32,800&display=swap');
        body {
            background: #f0f2f5;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        }
        /* Facebook Card Styles */
        .fb-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 1px 2px rgba(0,0,0,0.1), 0 0 0 1px rgba(0,0,0,0.05);
            transition: transform 0.2s, box-shadow 0.2s;
            width: 100%;
            max-width: 500px;
        }
        .fb-card:hover {
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
        }
        /* TikTok Card Styles */
        .tt-card {
            background: #000;
            border-radius: 20px;
            width: 100%;
            max-width: 320px;
            aspect-ratio: 9 / 16;
            position: relative;
            overflow: hidden;
            box-shadow: 0 12px 28px rgba(0,0,0,0.3);
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .tt-card:hover {
            transform: scale(1.02);
            box-shadow: 0 20px 35px rgba(0,0,0,0.4);
        }
        .tt-gradient {
            background: linear-gradient(to top, rgba(0,0,0,0.85) 0%, rgba(0,0,0,0) 40%, rgba(0,0,0,0) 100%);
        }
        .like-btn:hover { background-color: #f0f2f5; border-radius: 8px; }
        .comment-btn:hover { background-color: #f0f2f5; border-radius: 8px; }
        .share-btn:hover { background-color: #f0f2f5; border-radius: 8px; }
        /* TikTok right action icons */
        .tt-action-icon {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 4px;
            cursor: pointer;
            transition: transform 0.1s;
        }
        .tt-action-icon:active { transform: scale(0.92); }
        /* file input overlay */
        .image-overlay {
            transition: opacity 0.2s;
        }
        textarea:focus {
            outline: none;
            ring: none;
        }
    </style>
</head>
<body class="p-4 md:p-10">

<div class="max-w-7xl mx-auto">
    <!-- Header -->
    <div class="flex flex-col md:flex-row justify-between items-center mb-12 gap-5">
        <div class="text-center md:text-left">
            <h1 class="text-3xl md:text-4xl font-extrabold bg-gradient-to-r from-gray-900 to-gray-600 bg-clip-text text-transparent">📱 Social Media Hub</h1>
            <p class="text-gray-500 font-medium mt-1">Quản lý nội dung đa nền tảng – Chuẩn bài post Facebook & TikTok</p>
        </div>
        <div class="flex gap-3 text-sm">
            <div class="px-5 py-2.5 bg-white rounded-full shadow-sm border border-gray-200 font-semibold text-gray-700 flex items-center gap-2">
                <i class="fab fa-facebook text-blue-600 text-base"></i> <span>Facebook Feed</span>
            </div>
            <div class="px-5 py-2.5 bg-white rounded-full shadow-sm border border-gray-200 font-semibold text-gray-700 flex items-center gap-2">
                <i class="fab fa-tiktok text-black text-base"></i> <span>TikTok Video</span>
            </div>
        </div>
    </div>

    <div class="space-y-14">
    <%
        String ptId = request.getParameter("id");
        if (ptId == null) ptId = request.getParameter("PT_id");

        if (ptId != null) {
            Connection conn = null;
            try {
                Class.forName("org.sqlite.JDBC");
                conn = DriverManager.getConnection("jdbc:sqlite:" + Model.Config.POSTS_DB_PATH);
                String sql = "SELECT * FROM posts WHERE PT_id = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, ptId);
                ResultSet rs = pstmt.executeQuery();
                int count = 1;

                while (rs.next()) {
                    int id = rs.getInt("id");
                    String platform = (rs.getString("platform") != null) ? rs.getString("platform").trim().toLowerCase() : "";
                    String status = rs.getString("status");
                    String imgUrl = rs.getString("image_url");
                    if (imgUrl == null || imgUrl.isEmpty()) imgUrl = "https://placehold.co/800x800?text=SME+Engine";
                    String contentText = rs.getString("content");
                    
                    boolean isFBPosted = status.contains("facebook") || status.equals("posted_both");
                    boolean isTTPosted = status.contains("tiktok") || status.equals("posted_both");

                    // Dummy social stats để giống thật
                    int fbLikeCount = (id * 17) % 890 + 110;
                    int fbCommentCount = (id * 13) % 45 + 8;
                    int fbShareCount = (id * 9) % 32 + 5;
                    int ttLikeCount = (id * 37) % 12500 + 2400;
                    int ttCommentCount = (id * 23) % 680 + 120;
                    
                    // Grid layout cho both
                    String gridClass = "flex flex-wrap justify-center gap-10";
                    if (platform.equals("both")) {
                        gridClass = "grid grid-cols-1 lg:grid-cols-2 gap-10 justify-items-center items-start";
                    }
    %>
        <!-- Content Pack Wrapper -->
        <div class="bg-white/80 backdrop-blur-sm rounded-3xl shadow-md border border-gray-200 overflow-hidden transition-all">
            <!-- Header của pack -->
            <div class="px-6 py-4 border-b border-gray-100 flex flex-wrap items-center justify-between gap-3">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-full bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center text-white font-bold shadow-sm"><%= count++ %></div>
                    <div>
                        <h3 class="font-bold text-lg text-gray-800">Content Pack #<%= id %></h3>
                        <p class="text-xs text-gray-400 flex items-center gap-1"><i class="fas fa-chart-simple"></i> Platform: <span class="font-mono font-semibold text-indigo-600"><%= platform.toUpperCase() %></span> • Status: <span class="<%= (isFBPosted || isTTPosted) ? "text-green-600" : "text-amber-600" %>"><%= status %></span></p>
                    </div>
                </div>
                <div class="flex gap-2">
                    <% if (platform.equals("both") && (isFBPosted || isTTPosted)) { %>
                        <span class="bg-green-100 text-green-700 px-3 py-1 rounded-full text-xs font-bold"><i class="fas fa-check-circle mr-1"></i> Đã duyệt một phần</span>
                    <% } else if (isFBPosted || isTTPosted) { %>
                        <span class="bg-green-100 text-green-700 px-3 py-1 rounded-full text-xs font-bold"><i class="fas fa-check-circle mr-1"></i> Đã đăng</span>
                    <% } else { %>
                        <span class="bg-amber-100 text-amber-700 px-3 py-1 rounded-full text-xs font-bold"><i class="fas fa-pen-fancy mr-1"></i> Bản nháp</span>
                    <% } %>
                </div>
            </div>

            <div class="p-6 <%= gridClass %>">
                
                <!-- ==================== FACEBOOK CARD ==================== -->
                <% if (platform.equals("facebook") || platform.equals("both")) { %>
                <div class="w-full max-w-[500px] <%= isFBPosted ? "opacity-60 pointer-events-none" : "" %> transition duration-300">
                    <form method="POST" class="fb-card overflow-hidden">
                        <input type="hidden" name="action" value="update_post">
                        <input type="hidden" name="post_id" value="<%= id %>">
                        <input type="hidden" name="current_platform" value="facebook">
                        <input type="hidden" name="current_status" value="<%= status %>">
                        <input type="hidden" name="post_now" id="fb_now_<%= id %>" value="false">

                        <!-- Header: Avatar + Name + Time -->
                        <div class="p-4 flex items-center justify-between">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded-full bg-blue-600 flex items-center justify-center text-white shadow-md"><i class="fab fa-facebook-f text-lg"></i></div>
                                <div>
                                    <div class="font-bold text-sm text-gray-800">SME Growth Engine</div>
                                    <div class="flex items-center gap-1 text-[11px] text-gray-500">
                                        <span>1 giờ trước</span>
                                        <span>•</span>
                                        <i class="fas fa-globe-asia text-[10px]"></i>
                                    </div>
                                </div>
                            </div>
                            <i class="fas fa-ellipsis-h text-gray-500 cursor-pointer hover:bg-gray-100 p-2 rounded-full"></i>
                        </div>

                        <!-- Nội dung có thể sửa (giống caption Facebook) -->
                        <div class="px-4 pb-2">
                            <textarea name="content" class="w-full text-gray-700 text-sm border-none focus:ring-0 p-0 resize-none leading-relaxed" rows="3" placeholder="Viết nội dung bài viết..."><%= contentText %></textarea>
                        </div>

                        <!-- Ảnh / Video (click để đổi) -->
                        <div class="relative group cursor-pointer bg-gray-100" onclick="document.getElementById('fb_file_<%= id %>').click()">
                            <img id="fb_preview_<%= id %>" src="<%= imgUrl %>" class="w-full object-cover max-h-[450px]">
                            <div class="absolute inset-0 bg-black/30 opacity-0 group-hover:opacity-100 flex items-center justify-center text-white text-sm gap-2 transition-all">
                                <i class="fas fa-camera text-xl"></i> <span class="font-semibold">Đổi ảnh</span>
                            </div>
                            <input type="file" id="fb_file_<%= id %>" accept="image/*" class="hidden" onchange="previewMedia(this, 'fb_preview_<%= id %>', 'fb_url_<%= id %>')">
                            <input type="hidden" name="image_url" id="fb_url_<%= id %>" value="<%= imgUrl %>">
                        </div>

                        <!-- Cảm xúc, bình luận, lượt chia sẻ (fake) -->
                        <div class="px-4 pt-3 pb-1 flex justify-between text-xs text-gray-500 border-b border-gray-100">
                            <div class="flex items-center gap-1"><i class="fas fa-thumbs-up text-blue-500"></i> <span><%= fbLikeCount %></span></div>
                            <div><%= fbCommentCount %> bình luận</div>
                            <div><%= fbShareCount %> chia sẻ</div>
                        </div>

                        <!-- Hàng nút Like, Comment, Share -->
                        <div class="flex justify-around py-2">
                            <div class="flex items-center gap-2 text-gray-600 text-sm font-semibold py-1 px-6 rounded-lg hover:bg-gray-100 transition cursor-pointer like-btn"><i class="far fa-thumbs-up text-lg"></i> Thích</div>
                            <div class="flex items-center gap-2 text-gray-600 text-sm font-semibold py-1 px-6 rounded-lg hover:bg-gray-100 transition cursor-pointer comment-btn"><i class="far fa-comment text-lg"></i> Bình luận</div>
                            <div class="flex items-center gap-2 text-gray-600 text-sm font-semibold py-1 px-6 rounded-lg hover:bg-gray-100 transition cursor-pointer share-btn"><i class="fas fa-share-alt text-lg"></i> Chia sẻ</div>
                        </div>

                        <!-- Nút hành động: Lưu nháp & Đăng -->
                        <div class="p-3 bg-gray-50 rounded-b-xl grid grid-cols-2 gap-3">
                            <button type="submit" class="bg-white border border-gray-300 text-gray-700 font-bold py-2 rounded-xl text-xs hover:bg-gray-100 transition flex items-center justify-center gap-1"><i class="fas fa-save"></i> Lưu nháp</button>
                            <button type="submit" onclick="document.getElementById('fb_now_<%= id %>').value='true'" 
                                    class="<%= isFBPosted ? "bg-emerald-500" : "bg-[#1877f2]" %> text-white font-bold py-2 rounded-xl text-xs flex items-center justify-center gap-1 hover:brightness-105 transition shadow-md">
                                <i class="fab fa-facebook-f"></i> <%= isFBPosted ? "Đã đăng" : "Đăng Facebook" %>
                            </button>
                        </div>
                    </form>
                </div>
                <% } %>

                <!-- ==================== TIKTOK CARD ==================== -->
                <% if (platform.equals("tiktok") || platform.equals("both")) { %>
                <div class="w-full max-w-[320px] mx-auto <%= isTTPosted ? "opacity-60 pointer-events-none" : "" %>">
                    <form method="POST" class="tt-card">
                        <input type="hidden" name="action" value="update_post">
                        <input type="hidden" name="post_id" value="<%= id %>">
                        <input type="hidden" name="current_platform" value="tiktok">
                        <input type="hidden" name="current_status" value="<%= status %>">
                        <input type="hidden" name="post_now" id="tt_now_<%= id %>" value="false">

                        <!-- Ảnh nền (có thể đổi) -->
                        <div class="absolute inset-0 cursor-pointer z-0" onclick="document.getElementById('tt_file_<%= id %>').click()">
                            <img id="tt_preview_<%= id %>" src="<%= imgUrl %>" class="w-full h-full object-cover">
                            <div class="absolute inset-0 bg-black/20 group-hover:bg-black/40 transition"></div>
                            <div class="absolute inset-0 tt-gradient"></div>
                            <div class="absolute bottom-28 left-4 opacity-0 group-hover:opacity-100 bg-black/60 text-white text-[10px] px-2 py-1 rounded-full transition">Đổi ảnh</div>
                            <input type="file" id="tt_file_<%= id %>" accept="image/*" class="hidden" onchange="previewMedia(this, 'tt_preview_<%= id %>', 'tt_url_<%= id %>')">
                            <input type="hidden" name="image_url" id="tt_url_<%= id %>" value="<%= imgUrl %>">
                        </div>

                        <!-- Header: Avatar + Username -->
                        <div class="absolute top-4 left-4 right-4 flex justify-between items-center z-10">
                            <div class="flex items-center gap-2">
                                <div class="w-8 h-8 rounded-full bg-gradient-to-tr from-pink-500 to-red-500 flex items-center justify-center text-white text-xs font-bold shadow">SME</div>
                                <div class="text-white drop-shadow-md">
                                    <div class="text-xs font-bold leading-tight">sme_growth_engine</div>
                                    <div class="text-[9px] opacity-80">Đang hoạt động</div>
                                </div>
                            </div>
                            <i class="fas fa-ellipsis-h text-white drop-shadow-md"></i>
                        </div>

                        <!-- Nhạc nền (dummy) -->
                        <div class="absolute bottom-28 left-4 z-10 flex items-center gap-2 bg-black/40 backdrop-blur-sm px-2 py-1 rounded-full">
                            <i class="fas fa-music text-pink-400 text-[10px]"></i>
                            <span class="text-white text-[9px] font-medium">original sound - SME Engine</span>
                        </div>

                        <!-- Caption có thể chỉnh sửa -->
                        <div class="absolute bottom-28 left-4 right-12 z-10">
                            <textarea name="content" class="w-full bg-transparent text-white text-xs font-medium resize-none border-b border-white/30 focus:border-pink-500 outline-none" rows="2" placeholder="Viết chú thích..."><%= contentText %></textarea>
                            <div class="flex flex-wrap gap-1 mt-1 text-[9px] text-white/60">#SMEgrowth #Marketing #xuhuong</div>
                        </div>

                        <!-- Hàng icon tương tác bên phải -->
                        <div class="absolute right-3 bottom-32 flex flex-col gap-5 z-10">
                            <div class="tt-action-icon"><i class="far fa-heart text-2xl text-white hover:text-pink-500 transition"></i><span class="text-white text-[10px] font-bold"><%= ttLikeCount %></span></div>
                            <div class="tt-action-icon"><i class="far fa-comment-dots text-2xl text-white"></i><span class="text-white text-[10px] font-bold"><%= ttCommentCount %></span></div>
                            <div class="tt-action-icon"><i class="fas fa-share-alt text-2xl text-white"></i><span class="text-white text-[10px] font-bold">243</span></div>
                            <div class="tt-action-icon"><i class="fas fa-bookmark text-2xl text-white"></i></div>
                        </div>

                        <!-- Avatar nhỏ góc phải dưới (giống TikTok) -->
                        <div class="absolute bottom-36 right-3 z-10 w-8 h-8 rounded-full border-2 border-white bg-gray-800 flex items-center justify-center text-white text-[10px] font-bold">ME</div>

                        <!-- Nút hành động: Lưu nháp và Đăng TikTok -->
                        <div class="absolute bottom-3 left-3 right-3 flex gap-2 z-10">
                            <button type="submit" class="flex-1 bg-white/20 backdrop-blur-md text-white font-bold py-2 rounded-full text-[10px] uppercase tracking-wide hover:bg-white/30 transition"><i class="fas fa-pen"></i> Lưu nháp</button>
                            <button type="submit" onclick="document.getElementById('tt_now_<%= id %>').value='true'" 
                                    class="flex-1 bg-[#fe2c55] text-white font-bold py-2 rounded-full text-[10px] uppercase tracking-wide shadow-lg shadow-red-500/30 active:scale-95 transition">
                                <i class="fab fa-tiktok"></i> <%= isTTPosted ? "Đã đăng" : "Đăng TikTok" %>
                            </button>
                        </div>
                    </form>
                </div>
                <% } %>
            </div>
        </div>
    <% 
                } // end while
            } catch (Exception e) { 
                out.print("<div class='bg-red-50 border border-red-200 text-red-700 p-6 rounded-2xl'>Lỗi hệ thống: " + e.getMessage() + "</div>");
            } finally { 
                if (conn != null) conn.close(); 
            }
        } else {
            out.print("<div class='text-center p-16 bg-white rounded-3xl border border-dashed border-gray-300 shadow-sm'><i class='fas fa-link text-4xl text-gray-300 mb-3'></i><h2 class='text-2xl font-bold text-gray-400'>Thiếu tham số ID</h2><p class='text-gray-400 mt-1'>Vui lòng truyền ?id= hoặc ?PT_id= trên URL</p></div>");
        }
    %>
    </div>
</div>

<script>
function previewMedia(input, imgId, urlId) {
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function(e) {
            document.getElementById(imgId).src = e.target.result;
            document.getElementById(urlId).value = e.target.result;
        };
        reader.readAsDataURL(input.files[0]);
    }
}
</script>
</body>
</html>