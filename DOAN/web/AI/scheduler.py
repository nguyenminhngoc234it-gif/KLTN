import sqlite3
import time
from datetime import datetime
from post_social import post_facebook, post_tiktok

DB_PATH = "posts.db"

def get_pending_posts():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    now = datetime.now().strftime("%Y-%m-%d %H:%M")

    cursor.execute("""
        SELECT id, content, platform, scheduled_time 
        FROM posts 
        WHERE status = 'pending'
          AND approved = 1
          AND scheduled_time <= ?
    """, (now,))

    rows = cursor.fetchall()
    conn.close()
    return rows


def mark_done(post_id):
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    cursor.execute("""
        UPDATE posts 
        SET status='done' 
        WHERE id=?
    """, (post_id,))

    conn.commit()
    conn.close()


def mark_error(post_id, error_msg):
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    cursor.execute("""
        UPDATE posts 
        SET status='error' 
        WHERE id=?
    """, (post_id,))

    conn.commit()
    conn.close()


def run_scheduler():
    print("🚀 Scheduler started...")

    while True:
        posts = get_pending_posts()

        for post in posts:
            post_id, content, platform, scheduled_time = post

            print(f"👉 Đang đăng ID={post_id} | {platform} | {scheduled_time}")

            try:
                if platform == "facebook":
                    post_facebook(content)

                elif platform == "tiktok":
                    post_tiktok(content)

                mark_done(post_id)
                print(f"✅ Done {post_id}")

            except Exception as e:
                print(f"❌ Lỗi post {post_id}:", e)
                mark_error(post_id, str(e))

        time.sleep(60)


if __name__ == "__main__":
    run_scheduler()