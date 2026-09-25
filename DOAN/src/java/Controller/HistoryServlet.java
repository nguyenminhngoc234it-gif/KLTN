package Controller;

import com.google.gson.Gson;
import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "HistoryServlet", urlPatterns = {"/HistoryServlet"})
public class HistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        Gson gson = new Gson();

        // 1. Lấy user_id từ cookie (nếu có)
        Cookie[] cookies = request.getCookies();
        String userId = null;
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("user_id".equals(c.getName())) {
                    userId = c.getValue();
                }
            }
        }

        // 2. Đọc file history.json (BẮT BUỘC dùng UTF-8 để không lỗi tiếng Việt)
        File file = new File("E:\\UNETI_FINAL\\HK2-FINAL\\KLTN\\KLTH_AI_Marketing\\DOAN\\web\\AI\\history.json");
        if (!file.exists()) {
            response.getWriter().write("{\"error\":\"History file not found\"}");
            return;
        }
        
        String content = new String(Files.readAllBytes(file.toPath()), StandardCharsets.UTF_8);
        List<Map<String, Object>> data = gson.fromJson(content, List.class);
        
        if (data == null) {
            data = new ArrayList<>();
        }

        String idParam = request.getParameter("id");

        // ================= TRƯỜNG HỢP LẤY DANH SÁCH =================
        if (idParam == null) {
            List<Map<String, Object>> list = new ArrayList<>();
            for (Map<String, Object> obj : data) {
                // Ép kiểu an toàn cho user_id (tránh lỗi ClassCastException)
                if (userId != null && obj.get("user_id") != null) {
                    try {
                        int uid = (int) Double.parseDouble(obj.get("user_id").toString());
                        if (uid != Integer.parseInt(userId)) continue;
                    } catch (NumberFormatException e) {
                        continue; // Bỏ qua bản ghi lỗi
                    }
                }
                
                Map<String, Object> item = new HashMap<>();
                item.put("user_id", obj.get("user_id"));
                item.put("id", obj.get("id"));
                item.put("time", obj.get("time"));
                item.put("url", obj.get("url"));
                list.add(item);
            }
            
            // Sắp xếp mới nhất lên đầu
            list.sort((a, b) -> b.get("id").toString().compareTo(a.get("id").toString()));
            gson.toJson(list, response.getWriter());
            return;
        }

        // ================= TRƯỜNG HỢP LẤY CHI TIẾT =================
        for (Map<String, Object> obj : data) {
            boolean matchUser = true;
            
            // Ép kiểu an toàn
            if (userId != null && obj.get("user_id") != null) {
                try {
                    int uid = (int) Double.parseDouble(obj.get("user_id").toString());
                    matchUser = (uid == Integer.parseInt(userId));
                } catch (NumberFormatException e) {
                    matchUser = false;
                }
            }
            
            if (matchUser && idParam.equals(obj.get("id"))) {
                normalizeLegacyResult(obj);
                gson.toJson(obj, response.getWriter());
                return;
            }
        }
        
        response.getWriter().write("{\"error\":\"Not found\"}");
    }

    @SuppressWarnings("unchecked")
    private void normalizeLegacyResult(Map<String, Object> record) {
        if (record == null) {
            return;
        }

        Object rawResult = record.get("result");
        if (!(rawResult instanceof Map)) {
            return;
        }

        Map<String, Object> result = (Map<String, Object>) rawResult;
        Map<String, Object> customerInsights = getMap(result.get("customer_insights"));
        Map<String, Object> marketingPlan = getMap(result.get("marketing_plan"));
        Map<String, Object> scores = getMap(result.get("scores"));
        List<Object> recommendations = getList(result.get("recommendations"));
        List<Object> planItems = extractPlanItems(marketingPlan);
        List<Object> seoTasks = new ArrayList<>();

        for (Object item : planItems) {
            String text = stringValue(item).toLowerCase(Locale.ROOT);
            if (text.contains("seo") || text.contains("keyword") || text.contains("organic") || text.contains("blog")) {
                seoTasks.add(item);
            }
        }

        if (!hasContent(result.get("business_analysis"))) {
            Map<String, Object> businessAnalysis = new LinkedHashMap<>();
            businessAnalysis.put("summary", firstNonBlank(stringValue(result.get("summary")), "Chua co ban tom tat chi tiet."));
            businessAnalysis.put("customer_behavior", stringValue(customerInsights.get("behavior")));
            businessAnalysis.put("customer_needs", stringValue(customerInsights.get("needs")));
            businessAnalysis.put("pain_points", stringValue(customerInsights.get("pain")));
            businessAnalysis.put("top_recommendations", firstItems(recommendations, 3));
            result.put("business_analysis", businessAnalysis);
        }

        if (!hasContent(result.get("marketing_strategy"))) {
            Map<String, Object> marketingStrategy = new LinkedHashMap<>();
            marketingStrategy.put("primary_goal", "Tang truong traffic chat luong, chuyen doi va giu chan khach hang.");
            marketingStrategy.put("priority_actions", !planItems.isEmpty() ? firstItems(planItems, 5) : firstItems(recommendations, 5));
            marketingStrategy.put("channel_focus", Arrays.asList("SEO", "Social Media", "Remarketing"));
            marketingStrategy.put("conversion_notes", stringValue(customerInsights.get("conversion")));
            result.put("marketing_strategy", marketingStrategy);
        }

        if (!hasContent(result.get("content_generation"))) {
            Map<String, Object> contentGeneration = new LinkedHashMap<>();
            contentGeneration.put("content_angles", !recommendations.isEmpty() ? firstItems(recommendations, 3) : firstItems(planItems, 3));
            contentGeneration.put("blog_topics", firstItems(planItems, 5));
            contentGeneration.put("cta_suggestions", Arrays.asList(
                    "Kham pha uu dai hom nay",
                    "Dang ky nhan tu van",
                    "Xem san pham phu hop ngay"
            ));
            result.put("content_generation", contentGeneration);
        }

        if (!hasContent(result.get("competitor_analysis"))) {
            Map<String, Object> competitorAnalysis = new LinkedHashMap<>();
            competitorAnalysis.put("status", "Chua co du lieu doi thu truc tiep trong ban ghi nay.");
            competitorAnalysis.put("next_step", "Chay lai phan tich de AI sinh phan competitor chi tiet theo phien ban moi.");
            result.put("competitor_analysis", competitorAnalysis);
        }

        if (!hasContent(result.get("seo_analysis"))) {
            Map<String, Object> seoAnalysis = new LinkedHashMap<>();
            seoAnalysis.put("seo_score", scores.containsKey("seo") ? scores.get("seo") : scores.get("SEO"));
            seoAnalysis.put("priority_tasks", !seoTasks.isEmpty() ? firstItems(seoTasks, 5)
                    : (!planItems.isEmpty() ? firstItems(planItems, 3) : firstItems(recommendations, 3)));
            seoAnalysis.put("content_opportunities", firstItems(recommendations, 3));
            result.put("seo_analysis", seoAnalysis);
        }
    }

    @SuppressWarnings("unchecked")
    private Map<String, Object> getMap(Object value) {
        if (value instanceof Map) {
            return (Map<String, Object>) value;
        }
        return new LinkedHashMap<>();
    }

    @SuppressWarnings("unchecked")
    private List<Object> getList(Object value) {
        if (value instanceof List) {
            return (List<Object>) value;
        }
        return new ArrayList<>();
    }

    private List<Object> extractPlanItems(Map<String, Object> marketingPlan) {
        List<Object> result = new ArrayList<>();
        if (marketingPlan == null || marketingPlan.isEmpty()) {
            return result;
        }

        Object plan = marketingPlan.get("plan30");
        if (plan == null) {
            plan = marketingPlan.get("plan_30_days");
        }
        if (plan == null) {
            plan = marketingPlan.get("plan7");
        }
        if (plan == null) {
            plan = marketingPlan.get("plan_7_days");
        }

        if (plan instanceof Map) {
            result.addAll(((Map<?, ?>) plan).values());
            return result;
        }
        if (plan instanceof List) {
            result.addAll((List<?>) plan);
            return result;
        }
        if (plan instanceof String) {
            String[] parts = ((String) plan).split(";");
            for (String part : parts) {
                if (!part.trim().isEmpty()) {
                    result.add(part.trim());
                }
            }
        }
        return result;
    }

    private List<Object> firstItems(List<Object> source, int limit) {
        List<Object> result = new ArrayList<>();
        if (source == null || source.isEmpty() || limit <= 0) {
            return result;
        }
        for (int i = 0; i < source.size() && i < limit; i++) {
            result.add(source.get(i));
        }
        return result;
    }

    private boolean hasContent(Object value) {
        if (value == null) {
            return false;
        }
        if (value instanceof String) {
            return !((String) value).trim().isEmpty();
        }
        if (value instanceof Map) {
            return !((Map<?, ?>) value).isEmpty();
        }
        if (value instanceof List) {
            return !((List<?>) value).isEmpty();
        }
        return true;
    }

    private String stringValue(Object value) {
        return value == null ? "" : value.toString();
    }

    private String firstNonBlank(String value, String fallback) {
        return value != null && !value.trim().isEmpty() ? value : fallback;
    }
}
