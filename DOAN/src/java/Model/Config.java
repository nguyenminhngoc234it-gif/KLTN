package Model;

public class Config {
    
    // Thư mục gốc chứa script Python (dùng dấu \\ hoặc /)
    public static final String PYTHON_SCRIPTS_DIR = "E:/UNETI_FINAL/HK2-FINAL/KLTN/KLTH_AI_Marketing/DOAN/web/AI";

    // File database SQLite
    public static final String POSTS_DB_PATH = PYTHON_SCRIPTS_DIR + "/posts.db";

    // Các script riêng biệt
    public static final String CREATE_PLAN_SCRIPT = PYTHON_SCRIPTS_DIR + "/create_plan.py";
    public static final String POST_SOCIAL_SCRIPT = PYTHON_SCRIPTS_DIR + "/post_social.py";

    // Môi trường Python (trên Windows thường là "python", có thể là "python3" nếu cài Python 3 riêng)
    public static final String PYTHON_EXEC = "python";
}