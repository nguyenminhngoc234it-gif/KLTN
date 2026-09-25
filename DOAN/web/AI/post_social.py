# import sys
# import json
# import time
# import os
# from pathlib import Path
# import undetected_chromedriver as uc
# from selenium.webdriver.common.by import By
# from selenium.webdriver.support.ui import WebDriverWait
# from selenium.webdriver.support import expected_conditions as EC
# from selenium.webdriver.common.keys import Keys

# # Đường dẫn lưu Profile Chrome (Cookie) ngay tại thư mục chứa code
# BASE_DIR = Path(__file__).parent
# PROFILES_DIR = BASE_DIR / "chrome_profiles"
# PROFILES_DIR.mkdir(exist_ok=True)

# def wait_for_login(driver, platform, timeout=300):
#     """Đợi người dùng đăng nhập thủ công nếu chưa có session"""
#     print(json.dumps({"status": "waiting", "message": f"Hãy đăng nhập {platform} trên trình duyệt..."}))
#     sys.stdout.flush()
    
#     start = time.time()
#     while time.time() - start < timeout:
#         try:
#             if platform == "facebook":
#                 # Kiểm tra xem có thấy nút 'Bạn đang nghĩ gì' hoặc Avatar không
#                 if len(driver.find_elements(By.XPATH, "//div[@aria-label='Tạo bài viết công khai']")) > 0:
#                     return True
#             elif platform == "tiktok":
#                 if "upload" in driver.current_url and len(driver.find_elements(By.XPATH, "//div[@contenteditable='true']")) > 0:
#                     return True
#         except:
#             pass
#         time.sleep(3)
#     return False

# def post_to_facebook(content):
#     profile_path = PROFILES_DIR / "fb_user_data"
#     options = uc.ChromeOptions()
#     # LUÔN LUÔN dùng User Data Dir để lưu lại đăng nhập cho lần sau
#     options.add_argument(f"--user-data-dir={profile_path.absolute()}")
    
#     driver = uc.Chrome(options=options)
#     try:
#         driver.get("https://www.facebook.com/")
#         time.sleep(5)

#         # 1. Kiểm tra trạng thái đăng nhập
#         try:
#             # Tìm nút mở ô đăng bài
#             status_btn = WebDriverWait(driver, 15).until(
#                 EC.element_to_be_clickable((By.XPATH, "//div[@aria-label='Tạo bài viết công khai']"))
#             )
#         except:
#             # Nếu không thấy -> Bắt đầu đợi người dùng login
#             if not wait_for_login(driver, "facebook"):
#                 return {"success": False, "message": "Hết thời gian chờ đăng nhập Facebook."}
#             status_btn = driver.find_element(By.XPATH, "//div[@aria-label='Tạo bài viết công khai']")

#         # 2. Bắt đầu quy trình đăng bài
#         status_btn.click()
#         time.sleep(3)

#         # 3. Nhập nội dung (Dùng phím tắt để đảm bảo dán text an toàn)
#         # Tìm ô nhập liệu chính xác sau khi nhấn nút mở
#         active_element = driver.switch_to.active_element
#         active_element.send_keys(content)
#         time.sleep(2)

#         # 4. Nhấn nút Đăng (Thường là div có role=button và label là Đăng)
#         post_btn = WebDriverWait(driver, 10).until(
#             EC.element_to_be_clickable((By.XPATH, "//div[@aria-label='Đăng']"))
#         )
#         post_btn.click()
        
#         # Đợi 5 giây để tiến trình đăng bài hoàn tất trên server Facebook
#         time.sleep(5)
#         return {"success": True, "message": "Đã đăng bài lên Facebook thành công!"}

#     except Exception as e:
#         return {"success": False, "message": f"Lỗi Facebook: {str(e)}"}
#     finally:
#         driver.quit()

# def post_to_tiktok(content):
#     profile_path = PROFILES_DIR / "tiktok_user_data"
#     options = uc.ChromeOptions()
#     options.add_argument(f"--user-data-dir={profile_path.absolute()}")
    
#     driver = uc.Chrome(options=options)
#     try:
#         driver.get("https://www.tiktok.com/upload")
#         time.sleep(5)

#         # Kiểm tra login TikTok
#         if "login" in driver.current_url:
#             if not wait_for_login(driver, "tiktok"):
#                 return {"success": False, "message": "Hết thời gian chờ đăng nhập TikTok."}

#         # TikTok yêu cầu File Video (.mp4). Script này tạm thời chỉ nhập Caption.
#         desc_box = WebDriverWait(driver, 20).until(
#             EC.presence_of_element_located((By.XPATH, "//div[@contenteditable='true']"))
#         )
#         desc_box.send_keys(content)       
#         return {"success": True, "message": "Đã nhập Caption TikTok (Cần upload Video thủ công)"}

#     except Exception as e:
#         return {"success": False, "message": f"Lỗi TikTok: {str(e)}"}
#     finally:
#         driver.quit()

# def main():
#     # Nhận tham số từ Java: post_id, platform, content
#     if len(sys.argv) < 4:
#         print(json.dumps({"success": False, "message": "Thiếu tham số (id, platform, content)"}))
#         return

#     platform = sys.argv[2].lower()
#     content = sys.argv[3]

#     if platform == "facebook":
#         result = post_to_facebook(content)
#     elif platform == "tiktok":
#         result = post_to_tiktok(content)
#     else:
#         result = {"success": False, "message": f"Nền tảng {platform} chưa hỗ trợ."}

#     # In kết quả cuối cùng ra JSON để Servlet đọc được
#     print(json.dumps(result))

# if __name__ == "__main__":
#     main()

import time
from selenium import webdriver
from selenium.webdriver.common.by import By

def get_driver():
    options = webdriver.ChromeOptions()
    options.add_argument("user-data-dir=C:/chrome-profile")  # giữ login
    options.add_argument("--start-maximized")
    return webdriver.Chrome(options=options)

# ===== FACEBOOK =====
def post_facebook(content):
    driver = get_driver()
    driver.get("https://www.facebook.com/")
    time.sleep(5)

    try:
        driver.find_element(By.XPATH, "//span[contains(text(),'Bạn đang nghĩ gì')]").click()
        time.sleep(3)

        box = driver.find_element(By.XPATH, "//div[@role='textbox']")
        box.send_keys(content)

        time.sleep(2)

        driver.find_element(By.XPATH, "//div[@aria-label='Đăng']").click()
        print("✅ Facebook posted")

    except Exception as e:
        print("❌ FB lỗi:", e)

    time.sleep(5)
    driver.quit()


# ===== TIKTOK =====
def post_tiktok(content):
    driver = get_driver()
    driver.get("https://www.tiktok.com/upload")

    print("⚠ TikTok cần video → cần thêm upload file")

    time.sleep(10)
    driver.quit()