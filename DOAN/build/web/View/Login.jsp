<%-- 
    Document   : login
    Created on : 10 thg 6, 2025, 15:43:47
    Author     : pvbmi
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>

<html class="dark" lang="en"><head>
        <meta charset="utf-8"/>
        <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&amp;family=Manrope:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/>
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <script id="tailwind-config">
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        colors: {
                            "error-dim": "#d73357",
                            "secondary": "#00e3fd",
                            "tertiary-dim": "#ff6c95",
                            "on-primary-fixed": "#000000",
                            "surface-bright": "#282c36",
                            "surface-container-high": "#1c2028",
                            "on-tertiary-fixed-variant": "#770033",
                            "tertiary-container": "#fd3e80",
                            "secondary-dim": "#00d4ec",
                            "primary-fixed-dim": "#9c7eff",
                            "surface-container-highest": "#22262f",
                            "secondary-fixed-dim": "#00d7f0",
                            "inverse-primary": "#6834eb",
                            "on-tertiary-fixed": "#380014",
                            "surface-tint": "#b6a0ff",
                            "error-container": "#a70138",
                            "primary-dim": "#7e51ff",
                            "primary-fixed": "#a98fff",
                            "surface-container-low": "#10131a",
                            "on-surface-variant": "#a9abb3",
                            "background": "#0b0e14",
                            "on-error": "#490013",
                            "surface": "#0b0e14",
                            "surface-dim": "#0b0e14",
                            "tertiary-fixed-dim": "#ff769b",
                            "secondary-container": "#006875",
                            "tertiary": "#ff6c95",
                            "surface-container": "#161a21",
                            "on-background": "#ecedf6",
                            "inverse-surface": "#f9f9ff",
                            "on-surface": "#ecedf6",
                            "tertiary-fixed": "#ff8fa9",
                            "surface-container-lowest": "#000000",
                            "on-primary": "#340090",
                            "on-secondary": "#004d57",
                            "on-primary-container": "#280072",
                            "inverse-on-surface": "#52555c",
                            "on-secondary-fixed-variant": "#005964",
                            "on-error-container": "#ffb2b9",
                            "on-secondary-fixed": "#003a42",
                            "outline": "#73757d",
                            "secondary-fixed": "#26e6ff",
                            "primary-container": "#a98fff",
                            "outline-variant": "#45484f",
                            "on-tertiary-container": "#100003",
                            "primary": "#b6a0ff",
                            "on-tertiary": "#48001c",
                            "surface-variant": "#22262f",
                            "on-secondary-container": "#e8fbff",
                            "error": "#ff6e84",
                            "on-primary-fixed-variant": "#32008a"
                        },
                        borderRadius: {
                            "DEFAULT": "0.25rem",
                            "lg": "0.5rem",
                            "xl": "1.5rem",
                            "full": "9999px"
                        },
                        fontFamily: {
                            "headline": ["Plus Jakarta Sans"],
                            "body": ["Manrope"],
                            "label": ["Manrope"]
                        }
                    },
                },
            }
        </script>
        <style>
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            }
            .glow-radial {
                background: radial-gradient(circle at 0% 0%, rgba(182, 160, 255, 0.12) 0%, transparent 50%);
            }
            .primary-gradient {
                background: linear-gradient(135deg, #b6a0ff 0%, #7e51ff 100%);
            }
            .ghost-border:focus-within {
                box-shadow: 0 0 0 1px rgba(0, 227, 253, 0.4);
            }
        </style>
    </head>
    <body class="bg-surface text-on-surface font-body selection:bg-secondary/30">
        <!-- TopNavBar (Shared Component) -->
        <nav class="fixed top-0 w-full z-50 flex justify-between items-center px-10 py-6 bg-[#0b0e14]/60 backdrop-blur-xl">
            <div class="text-2xl font-black tracking-tighter text-[#ecedf6] font-headline">Nocturne</div>
            <div class="flex items-center gap-8">
                <div class="hidden md:flex gap-6 font-manrope font-medium text-sm">
                    <a class="text-[#00e3fd] font-bold border-b-2 border-[#00e3fd] pb-1" href="#">Login</a>
                    <a class="text-[#ecedf6]/70 hover:text-[#ecedf6] transition-colors" href="#">Signup</a>
                </div>
                <button class="text-[#b6a0ff] hover:bg-[#1c2028]/50 transition-all duration-300 p-2 rounded-full active:scale-95">
                    <span class="material-symbols-outlined" data-icon="dark_mode">dark_mode</span>
                </button>
            </div>
        </nav>
        <main class="min-h-screen flex glow-radial">
            <!-- Left Side: Abstract Luminary Art -->
            <section class="hidden lg:flex w-1/2 relative items-center justify-center overflow-hidden bg-surface-container-lowest">
                <div class="absolute inset-0 z-0">
                    <div class="w-full h-full opacity-40 bg-cover bg-center" data-alt="Abstract 3D digital art of flowing silk-like neon violet and cyan ribbons against a deep void, cinematic lighting, ethereal glow" style="background-image: url('https://lh3.googleusercontent.com/aida-public/AB6AXuA4eYQNSVHJ8N8F4rxbQk0gvpQCypDZGyozF9fzrcQdtqbxKwX9_P8L4Ln-TFBy_xmApRRl7m4RKwzX8N1F-Afts7Sm4B7y5ikOkYlXny5jmW5FJIlaZFEoO2Z7ZQ3xP2rs88TCHm8fCQZ7OeJ0Xr0wX3kIVzUw4Ro9VWlr7uC6EsCt9sWiyuezmuJQlDN-cY0gXSDE-9wnjYS80EgBiSKljCvpgb7_gaqHCU7O8gINjvhgH1Zh6UgolGoICg5yyxlUD-qPWgAXADE6');"></div>
                </div>
                <!-- Glass Overlay Card -->
                <div class="relative z-10 p-12 max-w-xl">
                    <h1 class="font-headline text-6xl font-extrabold tracking-tight mb-6 leading-tight">
                        Beyond the <span class="text-transparent bg-clip-text primary-gradient">Standard</span> Horizon.
                    </h1>
                    <p class="text-on-surface-variant text-lg max-w-md font-medium leading-relaxed">
                        Step into an ecosystem designed for high-end digital experiences. Nocturne transforms the mundane into the extraordinary.
                    </p>
                    <!-- Decorative Element -->
                    <div class="mt-12 h-1 w-24 primary-gradient rounded-full"></div>
                </div>
                <!-- Ambient Glows -->
                <div class="absolute -bottom-24 -left-24 w-96 h-96 bg-primary/20 rounded-full blur-[100px]"></div>
                <div class="absolute -top-24 -right-24 w-96 h-96 bg-secondary/10 rounded-full blur-[100px]"></div>
            </section>
            <!-- Right Side: Login Form -->
            <section class="w-full lg:w-1/2 flex items-center justify-center p-8 md:p-16 lg:p-24 bg-surface">
                <div class="w-full max-w-md flex flex-col">
                    <header class="mb-10 text-left">
                        <h2 class="font-headline text-4xl font-bold text-on-surface mb-2">Welcome Back</h2>
                        <p class="text-on-surface-variant font-medium">Continue your journey in the Nocturne.</p>
                    </header>
                    <form class="space-y-6" action="${pageContext.request.contextPath}/LoginServlet" method="post">
                        <!-- Email Field -->
                        <div class="space-y-2">
                            <label class="block text-sm font-bold text-on-surface font-label ml-1">Email Address</label>
                            <div class="ghost-border relative bg-surface-container-highest rounded-xl transition-all duration-300">
                                <input class="w-full bg-transparent border-none focus:ring-0 px-5 py-4 text-on-surface placeholder:text-on-surface-variant/40 font-body" placeholder="name@domain.com" type="email" value="${sessionScope.registeredEmail}" name="email" id ="email" required/>
                            </div>
                        </div>
                        <!-- Password Field -->
                        <div class="space-y-2">
                            <div class="flex justify-between items-center px-1">
                                <label class="block text-sm font-bold text-on-surface font-label">Password</label>
                                <a class="text-xs font-bold text-secondary hover:text-secondary-dim transition-colors uppercase tracking-wider" href="#">Forgot Password?</a>
                            </div>
                            <div class="ghost-border relative bg-surface-container-highest rounded-xl transition-all duration-300">
                                <input class="w-full bg-transparent border-none focus:ring-0 px-5 py-4 text-on-surface placeholder:text-on-surface-variant/40 font-body" placeholder="••••••••" type="password" value="${sessionScope.registeredPass}" name="password" required/>
                            </div>
                        </div>
                        <!-- CTA Button -->
                        <button class="w-full primary-gradient text-on-primary-fixed font-bold py-4 rounded-xl shadow-xl shadow-primary/20 hover:scale-[1.02] active:scale-98 transition-all duration-200 text-base font-label mt-4" type="submit">
                            Login to Nocturne
                        </button>
                    </form>                 
                    <p class="mt-12 text-center text-on-surface-variant text-sm font-medium">
                        New here? <a class="text-secondary font-bold hover:underline decoration-secondary/30 underline-offset-4" href="Register.jsp">Create an account</a>
                    </p>
                </div>
            </section>
        </main>       
    </body>
    
</html>