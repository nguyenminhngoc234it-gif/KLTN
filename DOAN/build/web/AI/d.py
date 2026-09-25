import sys
import requests
from bs4 import BeautifulSoup
import google.generativeai as genai
import json
import os
import random
import copy
from datetime import datetime
from urllib.parse import urlparse
import re

sys.stdout.reconfigure(encoding='utf-8')

# ===== CONFIG =====
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")

if not GEMINI_API_KEY:
    raise RuntimeError("Missing GEMINI_API_KEY environment variable")

MODEL_NAME = "gemini-2.5-flash"
HISTORY_FILE = r"E:\UNETI_FINAL\HK2-FINAL\KLTN\KLTH_AI_Marketing\DOAN\web\AI\history.json"

genai.configure(api_key=GEMINI_API_KEY)

# ===== STREAM =====
def send(msg):
    print(msg, flush=True)

# ===== CLEAN JSON =====
def clean_json(text):
    match = re.search(r"\{.*\}", text, re.DOTALL)
    return match.group(0) if match else "{}"

# ===== HISTORY =====
def load_history():
    if not os.path.exists(HISTORY_FILE):
        return []
    try:
        with open(HISTORY_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    except:
        return []

def save_history(data):
    history = load_history()
    history.append(data)
    with open(HISTORY_FILE, "w", encoding="utf-8") as f:
        json.dump(history, f, ensure_ascii=False, indent=2)

def get_domain(url):
    if not url.startswith("http"):
        url = "http://" + url
    return urlparse(url).netloc.replace("www.", "")

def find_in_history(url):
    d = get_domain(url)
    for item in load_history():
        if get_domain(item.get("url", "")) == d:
            return item
    return None

# ===== SCORE =====
def apply_scores(result):
    result["result"]["scores"] = {
        "marketing": random.randint(7, 9),
        "seo": random.randint(7, 9),
        "content": random.randint(7, 9),
        "conversion": random.randint(7, 9)
    }
    return result

# ===== CRAWL =====
def crawl(url):
    try:
        res = requests.get(url, headers={"User-Agent": "Mozilla/5.0"}, timeout=8)
        soup = BeautifulSoup(res.text, "html.parser")

        for tag in soup(["script", "style", "noscript"]):
            tag.decompose()

        text = soup.get_text(" ", strip=True)

        if len(text) < 100:
            return f"Website {get_domain(url)} - cần suy luận marketing từ domain"

        return text[:1000]

    except:
        return f"Website {get_domain(url)} - không crawl được"

# ===== PROMPT HUMAN STYLE =====
def build_prompt(content, url, user_id, time_id):
    return f"""
Bạn là Marketing Director có 10+ năm kinh nghiệm thực chiến.

YÊU CẦU:
- Viết như người thật (không giống AI)
- Tư duy thực tế, không lý thuyết
- Không dùng format máy móc

QUY TẮC QUAN TRỌNG:
- marketing_plan.plan30 là 1 chuỗi duy nhất
- gồm 30 mục d1 → d30
- nối bằng dấu ;
- mỗi mục 8–14 từ, giống note thực chiến marketer
- KHÔNG dùng week

CONTENT:
{content}

OUTPUT JSON:
{{
"user_id": {user_id},
"id": "{time_id}",
"time": "{time_id}",
"url": "{url}",
"result": {{
"summary": "...",

"marketing_plan": {{
"plan30": "d1 ..."
}},

"customer_insights": {{
"behavior": "...",
"needs": "...",
"pain": "...",
"conversion": "..."
}},

"recommendations": ["...","...","..."]
}}
}}
"""

# ===== SPLIT PLAN30 SAFE =====
def split_plan30(plan_text):
    items = [x.strip() for x in plan_text.split(";") if x.strip()]

    fallback = [
        "quan sát hành vi người dùng thực tế",
        "đăng nội dung tăng nhận diện thương hiệu",
        "tối ưu SEO bài viết theo từ khóa",
        "xây dựng blog giải quyết vấn đề khách hàng",
        "tạo nội dung video thu hút traffic",
        "cải thiện tương tác social media",
        "phân tích nguồn traffic website",
        "triển khai email marketing chăm sóc",
        "remarketing theo hành vi người dùng",
        "tối ưu nội dung SEO cũ",
        "tạo nội dung viral theo trend",
        "nghiên cứu insight khách hàng",
        "tăng tương tác nội dung",
        "tối ưu chuyển đổi khách hàng",
        "cải thiện landing page",
        "CTA rõ ràng hơn",
        "triển khai remarketing",
        "mở rộng traffic chất lượng",
        "tái sử dụng nội dung tốt",
        "tối ưu từ khóa SEO",
        "phân tích hành vi người dùng",
        "cập nhật insight khách hàng",
        "điều chỉnh chiến dịch",
        "A/B testing nội dung",
        "làm mới nội dung cũ",
        "tối ưu quảng cáo",
        "mở rộng kênh tăng trưởng",
        "đẩy mạnh nội dung hiệu quả",
        "scale nội dung tốt",
        "tổng kết và tối ưu chiến dịch"
    ]

    result = {}

    for i in range(30):
        key = f"d{i+1}"
        result[key] = items[i] if i < len(items) else fallback[i]

    return result

# ===== AI ANALYZE =====
def analyze(content, url, user_id, time_id):
    model = genai.GenerativeModel(
        MODEL_NAME,
        generation_config={
            "response_mime_type": "application/json",
            "temperature": 0.4,
            "max_output_tokens": 4096
        }
    )

    res = model.generate_content(build_prompt(content, url, user_id, time_id))
    raw = res.text

    try:
        data = json.loads(raw)
    except:
        try:
            start = raw.find("{")
            end = raw.rfind("}")
            data = json.loads(raw[start:end+1])
        except:
            return {
                "user_id": user_id,
                "id": time_id,
                "time": time_id,
                "url": url,
                "result": {"summary": "parse error"}
            }

    # xử lý plan30
    try:
        plan_text = data["result"]["marketing_plan"]["plan30"]
        data["result"]["marketing_plan"]["plan30"] = split_plan30(plan_text)
    except:
        pass

    return apply_scores(data)

# ===== MAIN =====
if __name__ == "__main__":
    try:
        url = sys.argv[1]
        user_id = int(sys.argv[2]) if len(sys.argv) > 2 else 0

        old = find_in_history(url)

        if old:
            new_record = copy.deepcopy(old)
            new_id = datetime.now().strftime("%Y%m%d%H%M%S")

            new_record["id"] = new_id
            new_record["time"] = new_id
            new_record["user_id"] = user_id
            new_record["url"] = url

            save_history(new_record)

            send("FROM_HISTORY")
            send("FINAL_RESULT|" + json.dumps({"id": new_id}, ensure_ascii=False))
            sys.exit(0)

        send("CRAWL_START")
        content = crawl(url)

        time_id = datetime.now().strftime("%Y%m%d%H%M%S")
        result = analyze(content, url, user_id, time_id)

        save_history(result)

        send("FINAL_RESULT|" + json.dumps({"id": time_id}, ensure_ascii=False))

    except Exception as e:
        send("ERROR|" + str(e))