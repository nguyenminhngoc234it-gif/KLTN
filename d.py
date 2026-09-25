

# import asyncio
# from google import genai
# from crawl4ai import AsyncWebCrawler
# from bs4 import BeautifulSoup
# import re
# from urllib.parse import urljoin

# # ===============================
# # CONFIG
# # ===============================

# GEMINI_API_KEY = "AIzaSyD-oxnR1ajJxgpFFsWcpEHdgy8l-Ugoxhw"

# client = genai.Client(api_key=GEMINI_API_KEY)

# MODEL_NAME = "gemini-2.5-flash"

# MAX_CONTENT_LENGTH = 20000


# # ===============================
# # UTILS
# # ===============================

# def clean_text(text):
#     text = re.sub(r"\s+", " ", text)
#     return text.strip()


# def extract_links(html, base_url):

#     soup = BeautifulSoup(html, "html.parser")

#     links = set()

#     for a in soup.find_all("a", href=True):

#         link = urljoin(base_url, a["href"])

#         if base_url in link:
#             links.add(link)

#     return list(links)


# # ===============================
# # CRAWL WEBSITE
# # ===============================

# async def crawl_website(start_url, max_pages=5):

#     pages = []

#     async with AsyncWebCrawler(verbose=True) as crawler:

#         result = await crawler.arun(url=start_url)

#         pages.append({
#             "url": start_url,
#             "markdown": result.markdown,
#             "html": result.html
#         })

#         links = extract_links(result.html, start_url)

#         count = 0

#         for link in links:

#             if count >= max_pages:
#                 break

#             try:

#                 r = await crawler.arun(url=link)

#                 pages.append({
#                     "url": link,
#                     "markdown": r.markdown,
#                     "html": r.html
#                 })

#                 count += 1

#             except Exception:
#                 print("Skip:", link)

#     return pages


# # ===============================
# # BUILD WEBSITE CONTENT
# # ===============================

# def build_site_content(pages):

#     content = ""

#     for p in pages:

#         content += f"\n\nURL: {p['url']}\n"

#         text = clean_text(p["markdown"])

#         content += text

#     return content[:MAX_CONTENT_LENGTH]


# # ===============================
# # AI CALL
# # ===============================

# def ask_ai(prompt):

#     response = client.models.generate_content(
#         model=MODEL_NAME,
#         contents=prompt
#     )

#     return response.text


# # ===============================
# # AI ANALYSIS
# # ===============================

# def analyze_business(content):

#     prompt = f"""
# Bạn là chuyên gia phân tích doanh nghiệp.

# Hãy phân tích website sau:

# 1. Doanh nghiệp làm lĩnh vực gì
# 2. Sản phẩm / dịch vụ chính
# 3. Khách hàng mục tiêu
# 4. Giá trị nổi bật
# 5. Mô hình kinh doanh

# Website:

# {content}
# """

#     return ask_ai(prompt)


# def analyze_marketing(content):

#     prompt = f"""
# Phân tích marketing của website sau:

# 1. SEO hiện tại
# 2. Nội dung website
# 3. Social media
# 4. Điểm mạnh marketing
# 5. Điểm yếu marketing

# Website:

# {content}
# """

#     return ask_ai(prompt)


# def generate_marketing_strategy(content):

#     prompt = f"""
# Đề xuất chiến lược marketing cho website sau:

# 1. SEO strategy
# 2. Content marketing
# 3. Quảng cáo
# 4. Social media
# 5. Lead generation

# Website:

# {content}
# """

#     return ask_ai(prompt)


# def generate_content_plan(content):

#     prompt = f"""
# Tạo content plan 30 ngày cho website sau.

# Yêu cầu:

# - bảng
# - gồm: ngày, chủ đề, loại content

# Website:

# {content}
# """

#     return ask_ai(prompt)


# # ===============================
# # REPORT
# # ===============================

# def generate_full_report(business, marketing, strategy, content_plan):

#     report = f"""
# ===============================
# AI WEBSITE MARKETING ANALYSIS
# ===============================

# BUSINESS ANALYSIS
# -----------------

# {business}


# MARKETING ANALYSIS
# ------------------

# {marketing}


# MARKETING STRATEGY
# ------------------

# {strategy}


# CONTENT PLAN
# ------------

# {content_plan}

# """

#     return report


# # ===============================
# # MAIN
# # ===============================

# async def main():

#     print("\nAI WEBSITE ANALYZER\n")

#     url = input("Enter website URL: ")

#     print("\nCrawling website...\n")

#     pages = await crawl_website(url)

#     print("\nBuilding website content...\n")

#     content = build_site_content(pages)

#     print("\nAI analyzing business...\n")

#     business = analyze_business(content)

#     print("\nAI analyzing marketing...\n")

#     marketing = analyze_marketing(content)

#     print("\nAI generating strategy...\n")

#     strategy = generate_marketing_strategy(content)

#     print("\nAI generating content plan...\n")

#     content_plan = generate_content_plan(content)

#     report = generate_full_report(
#         business,
#         marketing,
#         strategy,
#         content_plan
#     )

#     print(report)

#     with open("report.txt", "w", encoding="utf-8") as f:
#         f.write(report)

#     print("\nReport saved to report.txt\n")


# # ===============================

# if __name__ == "__main__":
#     asyncio.run(main())


# import sys
# import json
# import asyncio
# from datetime import datetime
# from google import genai
# from crawl4ai import AsyncWebCrawler

# # =====================
# # CONFIG
# # =====================
# sys.stdout.reconfigure(encoding='utf-8', line_buffering=True)
# API_KEY = "AIzaSyCBzDl9x4_c1MqDElSF2sHw2lU3N5-jYiE"
# MODEL = "gemini-2.5-flash"
# client = genai.Client(api_key=API_KEY)

# # =====================
# # CLEAN JSON
# # =====================
# def clean_json(text):
#     text = text.replace("```json", "").replace("```", "")
#     s = text.find("{")
#     e = text.rfind("}")
#     if s == -1 or e == -1:
#         return "{}"
#     return text[s:e+1]

# # =====================
# # SIMPLE CRAWL (SAFE ALL WEBSITE)
# # =====================
# async def crawl(url):
#     try:
#         async with AsyncWebCrawler(verbose=False) as c:
#             r = await c.arun(
#                 url=url,
#                 simulate_user=True,
#                 bypass_cache=True,
#                 timeout=30000
#             )
#             if r and r.markdown:
#                 return r.markdown[:4000]
#     except:
#         pass
#     return f"Website: {url}"

# # =====================
# # MAIN
# # =====================
# async def main():
#     if len(sys.argv) < 3:
#         print(json.dumps({"error": "missing params"}))
#         return

#     url = sys.argv[1]
#     user_id = sys.argv[2]

#     text = await crawl(url)

#     # 👉 PROMPT GIỮ NGUYÊN LOGIC CỦA BẠN
#     prompt = f"""
# INPUT:
# Website URL: {url}

# Content:
# {text}

# ========================
# YÊU CẦU:
# - KHÔNG chung chung
# - dựa vào dữ liệu thật
# - trả JSON đúng format
# ========================

# OUTPUT JSON ONLY:
# {{
#   "business_analysis": {{}},
#   "marketing_strategy": {{}},
#   "content_generation": {{}},
#   "competitor_analysis": {{}},
#   "seo_analysis": {{}},
#   "landing_page": "",
#   "customer_insights": {{}},
#   "marketing_plan": {{}},
#   "recommendations": []
# }}
# """

#     try:
#         res = client.models.generate_content(
#             model=MODEL,
#             contents=prompt,
#             config={"temperature": 0.3}
#         )

#         data = json.loads(clean_json(res.text))

#         result = {
#             "user_id": user_id,
#             "id": datetime.now().strftime("%Y%m%d%H%M%S"),
#             "time": datetime.now().strftime("%Y%m%d%H%M%S"),
#             "url": url,
#             "result": data
#         }

#         # 👉 QUAN TRỌNG: chỉ print 1 lần
#         print(json.dumps(result, ensure_ascii=False))

#     except Exception as e:
#         print(json.dumps({"error": str(e)}))

# if __name__ == "__main__":
#     asyncio.run(main())