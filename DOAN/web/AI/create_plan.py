# import sys
# import json
# import sqlite3
# import datetime
# import time
# from pathlib import Path
# from firecrawl import FirecrawlApp
# import google.generativeai as genai

# sys.stdout.reconfigure(encoding='utf-8')

# GEMINI_API_KEY = "AIzaSyCBzDl9x4_c1MqDElSF2sHw2lU3N5-jYiE"
# FIRECRAWL_API_KEY = "fc-2d5389aa143e4fe9a2e974f37ac1d650"
# MODEL_NAME = "gemini-2.5-flash"

# DB_PATH = Path(__file__).parent / "posts.db"


# def crawl(url):
#     try:
#         app = FirecrawlApp(api_key=FIRECRAWL_API_KEY)

#         res = app.scrape_url(url, params={
#             'formats': ['markdown'],
#             'onlyMainContent': False,   # 🔥 QUAN TRỌNG
#             'waitFor': 5500             # 🔥 tăng lên
#         })

#         data = res.get('markdown', '')

#         # fallback nếu data yếu
#         if not data or len(data) < 200:
#             return f"Website: {url}\nKhông crawl được nội dung chi tiết"

#         return data[:10000]  # tăng thêm

#     except Exception as e:
#         print("❌ Crawl error:", e)
#         return f"Website: {url}\nLỗi crawl"

# # ========= AI =========
# def call_ai(prompt, retry=2):
#     for i in range(retry):
#         try:
#             genai.configure(api_key=GEMINI_API_KEY)
#             model = genai.GenerativeModel(MODEL_NAME)

#             res = model.generate_content(prompt)

#             if res.text and len(res.text) > 50:
#                 return res.text

#         except Exception as e:
#             print(f"AI error lần {i+1}:", e)
#             time.sleep(2)

#     return None


# # ========= PROMPT (GIỮ NGUYÊN CỦA BẠN) =========
# def build_prompt(raw_data, platform):
#     return f"""
# Dữ liệu website:
# {raw_data}

# BẮT BUỘC:
# - Nội dung phải liên quan trực tiếp đến dữ liệu trên
# - Nếu không có thông tin rõ → suy luận dựa trên URL và dữ liệu
# - Mỗi bài phải chứa ít nhất 1 insight cụ thể (tips, số liệu, vấn đề thực tế)
# - Tránh câu kiểu: "sản phẩm chất lượng cao", "dịch vụ uy tín"
# - Phải bám vào sản phẩm / dịch vụ / ngành từ dữ liệu

# Bạn là chuyên gia Content Marketing 10 năm kinh nghiệm.

# Nhiệm vụ:
# Tạo kế hoạch content 30 ngày cho nền tảng {platform}

# =====================
# QUY TẮC VIẾT BÀI
# =====================

# Mỗi bài phải có 3 phần:

# 1. HTO (Hook - Trigger - Opening)
# - Câu đầu gây chú ý mạnh, Có thể là câu hỏi, pain point, lợi ích
# - Ngắn gọn, tự nhiên, giống người thật
# - Có thể dùng emoji nhẹ

# 2. JTO (Justification - Trust - Offer)
# - Nội dung chính: giá trị thực (tips, insight, giải pháp)
# - Không quảng cáo lộ liễu
# - Có CTA tự nhiên

# 3. HASHTAG
# - khoảng 3 hashtag

# =====================
# YÊU CẦU
# =====================

# - Tổng 90 bài (30 ngày × 3 bài)
# - Không trùng nội dung
# - Không lặp cấu trúc
# - Viết như người thật (KHÔNG robotic)
# - Không markdown
# - Không giải thích
# - Mỗi bài tối đa 3-4 dòng
# - Nội dung ngắn gọn

# =====================
# FORMAT OUTPUT (TỐI ƯU TOKEN)
# =====================
# - Không JSON
# - Mỗi bài viết đầy đủ (KHÔNG ghi HTO/JTO)
# - Ngăn cách mỗi bài bằng: [SEP]

# CHỈ TRẢ TEXT
# """


# # ========= PARSE =========
# def parse_output(text):
#     text = text.replace("\r", "\n")

#     parts = [p.strip() for p in text.split("[SEP]")]

#     clean = []
#     for p in parts:
#         if len(p) > 20 and "#" in p:
#             clean.append(p)

#     return clean


# # ========= FILL =========
# def fill_missing(plan, target=90):
#     if len(plan) >= target:
#         return plan[:target]

#     print(f"⚠ Thiếu {target - len(plan)} bài → auto fill")

#     base = plan if plan else ["Nội dung marketing #marketing #content"]

#     while len(plan) < target:
#         plan.append(base[len(plan) % len(base)])

#     return plan


# # ========= GENERATE =========
# def generate_plan(platform, url, user_id, PT_id, schedule_str):

#     raw_data = crawl(url)
#     prompt = build_prompt(raw_data, platform)

#     raw_output = call_ai(prompt)

#     if not raw_output:
#         return {"status": "error", "message": "AI failed"}

#     plan_list = parse_output(raw_output)
#     plan_list = fill_missing(plan_list, 90)


#     conn = sqlite3.connect(DB_PATH)
#     c = conn.cursor()

#     try:
#         sched = json.loads(schedule_str)
#     except:
#         sched = {}

#     times = sched.get("times", ["08:00", "12:00", "20:00"])
#     start_date = sched.get("start_date")

#     if start_date:
#         try:
#             base_date = datetime.datetime.strptime(start_date, "%Y-%m-%d")
#         except:
#             base_date = datetime.datetime.utcnow() + datetime.timedelta(hours=7)
#     else:
#         base_date = datetime.datetime.utcnow() + datetime.timedelta(hours=7)

#     saved = 0

#     for index, content in enumerate(plan_list):
#         day_offset = index // len(times)
#         date = base_date + datetime.timedelta(days=day_offset)
#         t = times[index % len(times)]

#         final_time = f"{date.strftime('%Y-%m-%d')} {t}:00"

#         try:
#             c.execute('''
#                 INSERT INTO posts (user_id, PT_id, platform, content, scheduled_time)
#                 VALUES (?, ?, ?, ?, ?)
#             ''', (user_id, PT_id, platform, content, final_time))
#             saved += 1
#         except Exception as e:
#             print("DB error:", e)

#     conn.commit()
#     conn.close()

#     return {"status": "success", "saved": saved}


# # ========= MAIN =========
# def main():
#     if len(sys.argv) < 5:
#         print(json.dumps({"status": "error"}))
#         return

#     platform = sys.argv[1]
#     url = sys.argv[2]
#     user_id = int(sys.argv[3])
#     PT_id = sys.argv[4]

#     schedule = sys.argv[5] if len(sys.argv) > 5 else "{}"

#     result = generate_plan(platform, url, user_id, PT_id, schedule)
#     print(json.dumps(result))


# if __name__ == "__main__":
#     main()
import os
import sys
import json
import sqlite3
import datetime
import time
import random
import re
import hashlib
from pathlib import Path
from firecrawl import FirecrawlApp
import google.generativeai as genai

sys.stdout.reconfigure(encoding='utf-8')

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
FIRECRAWL_API_KEY = os.getenv("FIRECRAWL_API_KEY")

if not GEMINI_API_KEY:
    raise RuntimeError("Missing GEMINI_API_KEY environment variable")

if not FIRECRAWL_API_KEY:
    raise RuntimeError("Missing FIRECRAWL_API_KEY environment variable")
MODEL_NAME = "gemini-2.5-flash"

DB_PATH = Path(__file__).parent / "posts.db"

genai.configure(api_key=GEMINI_API_KEY)

# 🔥 GLOBAL INSTANCE (tránh tạo lại nhiều lần)
firecrawl_app = FirecrawlApp(api_key=FIRECRAWL_API_KEY)

# =========================
# DB INIT + INDEX
# =========================

def init_db():
    conn = sqlite3.connect(DB_PATH, timeout=10)
    c = conn.cursor()

    c.execute("""
    CREATE TABLE IF NOT EXISTS posts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        PT_id TEXT,
        platform TEXT,
        content TEXT,
        image_url TEXT,
        scheduled_time TEXT,
        status TEXT DEFAULT 'pending'
    )
    """)

    c.execute("""
    CREATE TABLE IF NOT EXISTS ai_cache (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content_hash TEXT,
        platform TEXT,
        content TEXT,
        created_at TEXT
    )
    """)

    c.execute("""
    CREATE INDEX IF NOT EXISTS idx_cache 
    ON ai_cache(content_hash, platform)
    """)

    conn.commit()
    conn.close()

init_db()

# =========================
# HASH (ỔN ĐỊNH HƠN)
# =========================

def hash_content(text):
    return hashlib.md5(text.encode()).hexdigest()

# =========================
# CLEAN DATA (GIỮ CONTEXT)
# =========================

def clean_data(raw):
    lines = raw.split("\n")
    filtered = [l.strip() for l in lines if len(l.strip()) > 30]
    return "\n".join(filtered[:80])

# =========================
# CACHE (FIX TIMEZONE)
# =========================

def get_cached_plan(content_hash, platform):
    conn = sqlite3.connect(DB_PATH, timeout=10)
    c = conn.cursor()

    c.execute("""
        SELECT content FROM ai_cache
        WHERE content_hash=? AND platform=?
        AND created_at > datetime('now','-7 day')
        ORDER BY id DESC LIMIT 1
    """, (content_hash, platform))

    row = c.fetchone()
    conn.close()

    return row[0] if row else None


def save_cache(content_hash, platform, content):
    conn = sqlite3.connect(DB_PATH, timeout=10)
    c = conn.cursor()

    # 🔥 FIX TIMEZONE FORMAT
    now = datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")

    c.execute("""
        INSERT INTO ai_cache (content_hash, platform, content, created_at)
        VALUES (?, ?, ?, ?)
    """, (content_hash, platform, content, now))

    conn.commit()
    conn.close()

# =========================
# CRAWL (DÙNG GLOBAL)
# =========================

def crawl(url):
    try:
        res = firecrawl_app.scrape_url(url, params={
            'formats': ['markdown'],
            'onlyMainContent': True,
            'waitFor': 4000
        })

        data = res.get('markdown', '')

        if not data or len(data) < 200:
            return f"Website: {url}\nKhông crawl được nội dung chi tiết"

        return data

    except Exception as e:
        print("❌ Crawl error:", e)
        return f"Website: {url}\nLỗi crawl"

# =========================
# AI (ANTI 429 + SAFE LENGTH)
# =========================

def call_ai(prompt, retry=5):
    model = genai.GenerativeModel(MODEL_NAME)

    for i in range(retry):
        try:
            res = model.generate_content(prompt)

            if res.text and 50 < len(res.text) < 200000:
                return res.text

        except Exception as e:
            print(f"AI error {i+1}:", e)

            wait = (2 ** i) + random.uniform(0, 2)
            print(f"⏳ Retry sau {wait:.2f}s")
            time.sleep(wait)

    return None

# =========================
# PROMPT (GIỮ NGUYÊN 100%)
# =========================

def build_prompt(raw_data, platform):
    return f"""
Dữ liệu website:
{raw_data}

BẮT BUỘC:
- Nội dung phải liên quan trực tiếp đến dữ liệu trên
- Nếu không có thông tin rõ → suy luận dựa trên URL và dữ liệu
- Mỗi bài phải chứa ít nhất 1 insight cụ thể (tips, số liệu, vấn đề thực tế)
- Tránh câu kiểu: "sản phẩm chất lượng cao", "dịch vụ uy tín"
- Phải bám vào sản phẩm / dịch vụ / ngành từ dữ liệu

Bạn là chuyên gia Content Marketing 10 năm kinh nghiệm.

Nhiệm vụ:
Tạo kế hoạch content 30 ngày cho nền tảng {platform}

=====================
QUY TẮC VIẾT BÀI
=====================

Mỗi bài phải có 3 phần:

1. HTO (Hook - Trigger - Opening)
- Câu đầu gây chú ý mạnh, Có thể là câu hỏi, pain point, lợi ích
- Ngắn gọn, tự nhiên, giống người thật
- Có thể dùng emoji nhẹ

2. JTO (Justification - Trust - Offer)
- Nội dung chính: giá trị thực (tips, insight, giải pháp)
- Không quảng cáo lộ liễu
- Có CTA tự nhiên

3. HASHTAG
- khoảng 3 hashtag

=====================
YÊU CẦU
=====================

- Tổng 90 bài (30 ngày × 3 bài)
- Không trùng nội dung
- Không lặp cấu trúc
- Viết như người thật (KHÔNG robotic)
- Không markdown
- Không giải thích
- Mỗi bài tối đa 3-4 dòng
- Nội dung ngắn gọn

=====================
FORMAT OUTPUT (TỐI ƯU TOKEN)
=====================
- Không JSON
- Mỗi bài viết đầy đủ (KHÔNG ghi HTO/JTO)
- Ngăn cách mỗi bài bằng: [SEP]

CHỈ TRẢ TEXT
"""

# =========================
# PARSE (FIX MẤT BÀI)
# =========================

def parse_output(text):
    text = text.replace("\r", "\n")
    parts = [p.strip() for p in text.split("[SEP]")]
    return [p for p in parts if len(p) > 20]

# =========================
# FILL
# =========================

def fill_missing(plan, target=90):
    if len(plan) >= target:
        return plan[:target]

    base = plan if plan else ["Marketing content #marketing #content"]

    while len(plan) < target:
        plan.append(base[len(plan) % len(base)])

    return plan

# =========================
# IMAGE (STABLE)
# =========================

def extract_keywords(text):
    words = re.findall(r"[a-zA-ZÀ-ỹ0-9]{4,}", text.lower())

    stopwords = {
        "của","và","the","with","this","that",
        "http","https","marketing","content",
        "dịch","vụ","sản","phẩm","website"
    }

    keywords = [w for w in words if len(w) > 4 and w not in stopwords]
    return list(dict.fromkeys(keywords))[:5]


def generate_image(content):
    keywords = extract_keywords(content)

    if not keywords:
        return "https://source.unsplash.com/1200x800/?marketing"

    query = ",".join(keywords[:3])
    seed = int(hashlib.md5(content.encode()).hexdigest(), 16) % 1000000

    return f"https://source.unsplash.com/1200x800/?{query}&sig={seed}"

# =========================
# GENERATE PLAN (BATCH INSERT)
# =========================

def generate_plan(platform, url, user_id, PT_id, schedule_str):

    raw_data = crawl(url)
    cleaned_data = clean_data(raw_data)

    # 🔥 HASH ổn định hơn
    content_hash = hash_content(raw_data[:2000] + platform)

    cached = get_cached_plan(content_hash, platform)

    if cached:
        print(f"⚡ CACHE HIT: {url}")
        raw_output = cached
    else:
        print(f"🚀 AI CALL: {url}")

        prompt = build_prompt(cleaned_data, platform)
        raw_output = call_ai(prompt)

        if not raw_output:
            return {"status": "error", "message": "AI failed"}

        save_cache(content_hash, platform, raw_output)

    plan_list = fill_missing(parse_output(raw_output), 90)

    conn = sqlite3.connect(DB_PATH, timeout=10)
    c = conn.cursor()

    try:
        sched = json.loads(schedule_str)
    except:
        sched = {}

    times = sched.get("times", ["08:00", "12:00", "20:00"])
    base_date = datetime.datetime.utcnow() + datetime.timedelta(hours=7)

    rows = []

    for index, content in enumerate(plan_list):

        image_url = generate_image(content)

        day_offset = index // len(times)
        date = base_date + datetime.timedelta(days=day_offset)
        t = times[index % len(times)]

        final_time = f"{date.strftime('%Y-%m-%d')} {t}:00"

        rows.append((user_id, PT_id, platform, content, image_url, final_time))

    c.executemany('''
        INSERT INTO posts (
            user_id, PT_id, platform,
            content, image_url, scheduled_time
        )
        VALUES (?, ?, ?, ?, ?, ?)
    ''', rows)

    conn.commit()
    conn.close()

    return {"status": "success", "saved": len(rows)}

# =========================
# MAIN
# =========================

def main():
    if len(sys.argv) < 5:
        print(json.dumps({"status": "error"}))
        return

    platform = sys.argv[1]
    url = sys.argv[2]
    user_id = int(sys.argv[3])
    PT_id = sys.argv[4]

    schedule = sys.argv[5] if len(sys.argv) > 5 else "{}"

    result = generate_plan(platform, url, user_id, PT_id, schedule)

    print(json.dumps(result, ensure_ascii=False))


if __name__ == "__main__":
    main()