<%-- 
    Document   : login
    Created on : 10 thg 6, 2025, 15:43:47
    Author     : pvbmi
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
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
                        "colors": {
                            "primary-container": "#a98fff",
                            "primary-fixed-dim": "#9c7eff",
                            "surface-bright": "#282c36",
                            "primary-fixed": "#a98fff",
                            "outline-variant": "#45484f",
                            "tertiary": "#ff6c95",
                            "error-container": "#a70138",
                            "inverse-primary": "#6834eb",
                            "on-tertiary": "#48001c",
                            "background": "#0b0e14",
                            "tertiary-fixed": "#ff8fa9",
                            "tertiary-fixed-dim": "#ff769b",
                            "surface-dim": "#0b0e14",
                            "surface-container-high": "#1c2028",
                            "inverse-on-surface": "#52555c",
                            "primary-dim": "#7e51ff",
                            "surface-container-lowest": "#000000",
                            "inverse-surface": "#f9f9ff",
                            "on-secondary-container": "#e8fbff",
                            "surface-container": "#161a21",
                            "on-primary-container": "#280072",
                            "on-surface": "#ecedf6",
                            "secondary": "#00e3fd",
                            "error": "#ff6e84",
                            "on-secondary": "#004d57",
                            "tertiary-dim": "#ff6c95",
                            "on-secondary-fixed": "#003a42",
                            "secondary-dim": "#00d4ec",
                            "on-surface-variant": "#a9abb3",
                            "on-background": "#ecedf6",
                            "on-primary": "#340090",
                            "secondary-fixed-dim": "#00d7f0",
                            "primary": "#b6a0ff",
                            "surface-tint": "#b6a0ff",
                            "surface-variant": "#22262f",
                            "outline": "#73757d",
                            "on-tertiary-container": "#100003",
                            "on-primary-fixed-variant": "#32008a",
                            "secondary-fixed": "#26e6ff",
                            "on-error": "#490013",
                            "secondary-container": "#006875",
                            "on-error-container": "#ffb2b9",
                            "tertiary-container": "#fd3e80",
                            "surface-container-low": "#10131a",
                            "on-tertiary-fixed": "#380014",
                            "surface-container-highest": "#22262f",
                            "on-primary-fixed": "#000000",
                            "error-dim": "#d73357",
                            "surface": "#0b0e14",
                            "on-secondary-fixed-variant": "#005964",
                            "on-tertiary-fixed-variant": "#770033"
                        },
                        "borderRadius": {
                            "DEFAULT": "0.25rem",
                            "lg": "0.5rem",
                            "xl": "1.5rem",
                            "full": "9999px"
                        },
                        "fontFamily": {
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
            .glass-panel {
                background: rgba(34, 38, 47, 0.4);
                backdrop-filter: blur(20px);
                -webkit-backdrop-filter: blur(20px);
            }
        </style>
    </head>
    <body class="bg-background text-on-surface font-body min-h-screen flex flex-col selection:bg-secondary/30 selection:text-secondary">
        <!-- TopNavBar -->
        <nav class="fixed top-0 w-full z-50 bg-slate-950/60 backdrop-blur-xl flex justify-between items-center px-8 h-20 w-full max-w-full">
            <div class="text-2xl font-bold tracking-tight text-violet-300 font-headline">BM APP MARKETTING</div>
            
            <div class="flex items-center gap-4">
                <button class="px-6 py-2 rounded-xl text-violet-400 font-bold hover:text-cyan-300 transition-all duration-300 scale-95 active:scale-90"><a href="Login.jsp">Sign In</a></button>
            </div>
        </nav>
        <!-- Main Content: Registration Split Layout -->
        <main class="flex-grow flex pt-20">
            <!-- Left Side: Cinematic Visual -->
            <section class="hidden lg:flex flex-1 relative overflow-hidden bg-surface-container-low">
                <div class="absolute inset-0 z-0">
                    <img alt="Abstract Background" class="w-full h-full object-cover grayscale opacity-40 mix-blend-luminosity" data-alt="Cinematic abstract 3D ribbons flowing in deep space with soft violet and cyan glowing edges against a pitch black background" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDiLAaEjM5V0nIB2CXGF_iatqWpnjiuRPibP_ipfV168xrXlpwWWYekl6mVD9rHUMKNQqIhm78KvVRJ_vMcqQInzkSkzbWrB29X_w1v0VP_PcV0GsrppKpvLDmIOvdmq_q-khXw8IhTUcQrxMQBHNRpvx_FgqFDFM3Uu7zNjhPn5xUalgKoIOnzYFpWYzOr2yLR4KfKxMCr9bp8wZeJI1fU2ZTfX47h1MQeRk_RGmKO4Kd8jiJZ1YPMX6hcRSK0kzdANwN5enRmOCIq"/>
                </div>
                <!-- Atmospheric Wash -->
                <div class="absolute inset-0 bg-gradient-to-br from-primary-dim/20 via-transparent to-secondary/10 pointer-events-none"></div>
                <div class="relative z-10 p-20 flex flex-col justify-end max-w-2xl">
                    <h1 class="font-headline text-6xl font-extrabold tracking-tighter text-on-surface mb-6 leading-tight">
                        Enter the <span class="text-transparent bg-clip-text bg-gradient-to-r from-primary via-primary-container to-secondary">Digital Luminary</span>.
                    </h1>
                    <p class="text-on-surface-variant text-xl leading-relaxed font-body">
                        Experience a high-end interface illuminated from within. Nocturne brings depth and vibrancy to your daily workflow.
                    </p>
                    <div class="mt-12 flex gap-8 items-center">
                        <div class="flex -space-x-3">
                            <div class="w-10 h-10 rounded-full border-2 border-surface-container-high bg-surface-container"></div>
                            <div class="w-10 h-10 rounded-full border-2 border-surface-container-high bg-surface-container"></div>
                            <div class="w-10 h-10 rounded-full border-2 border-surface-container-high bg-surface-container"></div>
                        </div>
                        <span class="text-sm font-label text-on-surface-variant">Joined by 10k+ early luminaries</span>
                    </div>
                </div>
            </section>
            <!-- Right Side: Registration Form -->
            <section class="flex-1 flex items-center justify-center p-8 md:p-16 lg:p-24 bg-surface">
                <!-- Background Radial Wash -->
                <div class="absolute top-0 right-0 w-[500px] h-[500px] bg-primary-container/5 rounded-full blur-[120px] -z-10"></div>
                <div class="w-full max-w-md space-y-10">
                    <header class="space-y-2">
                        <h2 class="font-headline text-4xl font-bold text-on-surface">Create Account</h2>
                        <p class="font-body text-on-surface-variant">Join the nocturne and start your journey today.</p>
                    </header>
                    <form class="space-y-6" action="${pageContext.request.contextPath}/RegisterServlet" method="post" >
                        <!-- Full Name -->
                        <div class="space-y-2">
                            <label class="font-label text-sm font-semibold text-on-surface ml-1">Full Name</label>
                            <div class="relative group">
                                <input class="w-full bg-surface-container-highest border-none rounded-xl px-4 py-4 text-on-surface placeholder:text-on-surface-variant/40 focus:ring-0 focus:outline-none transition-all duration-300" placeholder="Alex Nocturne" name ="fullName" type="text"/>
                                <div class="absolute inset-0 border border-secondary/0 group-focus-within:border-secondary/40 rounded-xl pointer-events-none transition-all"></div>
                            </div>
                        </div>
                        <!-- Email Address -->
                        <div class="space-y-2">
                            <label class="font-label text-sm font-semibold text-on-surface ml-1">Email Address</label>
                            <div class="relative group">
                                <input class="w-full bg-surface-container-highest border-none rounded-xl px-4 py-4 text-on-surface placeholder:text-on-surface-variant/40 focus:ring-0 focus:outline-none transition-all duration-300" placeholder="alex@nocturne.io" name ="email" type="email"/>
                                <div class="absolute inset-0 border border-secondary/0 group-focus-within:border-secondary/40 rounded-xl pointer-events-none transition-all"></div>
                            </div>
                        </div>
                        <!-- Password Fields Group -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div class="space-y-2">
                                <label class="font-label text-sm font-semibold text-on-surface ml-1">Password</label>
                                <div class="relative group">
                                    <input class="w-full bg-surface-container-highest border-none rounded-xl px-4 py-4 text-on-surface placeholder:text-on-surface-variant/40 focus:ring-0 focus:outline-none transition-all duration-300" placeholder="••••••••" name ="password" type="password"/>
                                    <div class="absolute inset-0 border border-secondary/0 group-focus-within:border-secondary/40 rounded-xl pointer-events-none transition-all"></div>
                                </div>
                            </div>
                            <div class="space-y-2">
                                <label class="font-label text-sm font-semibold text-on-surface ml-1">Confirm Password</label>
                                <div class="relative group">
                                    <input class="w-full bg-surface-container-highest border-none rounded-xl px-4 py-4 text-on-surface placeholder:text-on-surface-variant/40 focus:ring-0 focus:outline-none transition-all duration-300" placeholder="••••••••" name ="confirmPassword" type="password"/>
                                    <div class="absolute inset-0 border border-secondary/0 group-focus-within:border-secondary/40 rounded-xl pointer-events-none transition-all"></div>
                                </div>
                            </div>
                        </div>
                        
                        <button type="submit" class="w-full py-4 bg-gradient-to-r from-primary to-primary-dim text-on-primary font-headline font-bold text-lg rounded-xl shadow-lg shadow-primary/20 hover:scale-[1.02] active:scale-[0.98] transition-all duration-200">
                            Complete Registration
                        </button>
                    </form>
                    <div class="relative flex items-center gap-4 py-4">
                        <div class="flex-grow h-[1px] bg-outline-variant/20"></div>
                        <div class="flex-grow h-[1px] bg-outline-variant/20"></div>
                    </div>
                    
                    <p class="text-center font-body text-on-surface-variant">
                        Already a member? <a class="text-secondary font-bold hover:text-secondary-dim transition-colors" href="Login.jsp">Sign in here</a>
                    </p>
                </div>
            </section>
        </main>
       
    </body>
</html>