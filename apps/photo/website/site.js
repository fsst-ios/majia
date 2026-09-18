(() => {
  "use strict";

  const languageKey = "jufu-site-language";
  const supportedLanguages = new Set(["zh", "en"]);
  const page = document.body.dataset.page || "home";

  const pageMetadata = {
    home: {
      zh: {
        title: "Jufu — 轻量照片编辑工具",
        description:
          "Jufu 是一款轻量照片编辑工具：调整构图与比例，添加柔和效果和文字水印，再由你决定是否保存到系统相册。",
      },
      en: {
        title: "Jufu — A Focused Photo Finishing App",
        description:
          "Refine a crop, add a soft effect and a personal text watermark, then decide whether to save the result to Photos.",
      },
    },
    privacy: {
      zh: {
        title: "Jufu 隐私政策",
        description:
          "了解 Jufu 如何在设备本地处理照片、编辑内容、生成图片和语言偏好。",
      },
      en: {
        title: "Jufu Privacy Policy",
        description:
          "Learn how Jufu handles selected photos, edits, generated images, and language preferences on device.",
      },
    },
    terms: {
      zh: {
        title: "Jufu 用户协议",
        description:
          "了解使用 Jufu 照片编辑功能时适用的权利、责任与服务规则。",
      },
      en: {
        title: "Jufu Terms of Use",
        description:
          "Review the rights, responsibilities, and service rules that apply when using Jufu.",
      },
    },
  };

  function resolveInitialLanguage() {
    const queryLanguage = new URLSearchParams(window.location.search).get("lang");
    if (supportedLanguages.has(queryLanguage)) return queryLanguage;

    try {
      const savedLanguage = window.localStorage.getItem(languageKey);
      if (supportedLanguages.has(savedLanguage)) return savedLanguage;
    } catch (_) {
      // Language selection still works for the current page without storage.
    }

    return navigator.language.toLowerCase().startsWith("zh") ? "zh" : "en";
  }

  function updateInternalLinks(language) {
    document.querySelectorAll("[data-language-link]").forEach((link) => {
      const href = link.getAttribute("href");
      if (!href || href.startsWith("#") || href.startsWith("mailto:")) return;

      try {
        const url = new URL(href, window.location.href);
        const isLocalFile = url.protocol === "file:";
        const isSameOrigin = url.origin === window.location.origin;
        if (!isLocalFile && !isSameOrigin) return;
        url.searchParams.set("lang", language);
        link.href = url.href;
      } catch (_) {
        // Keep the original link if the browser cannot resolve it.
      }
    });
  }

  function setLanguage(language, persist = true) {
    if (!supportedLanguages.has(language)) return;

    document.documentElement.lang = language === "zh" ? "zh-CN" : "en";

    document.querySelectorAll("[data-zh][data-en]").forEach((element) => {
      element.textContent = element.dataset[language];
    });

    document.querySelectorAll("[data-lang-choice]").forEach((button) => {
      button.setAttribute(
        "aria-pressed",
        String(button.dataset.langChoice === language),
      );
    });

    document.querySelectorAll("[data-policy-language]").forEach((block) => {
      block.hidden = block.dataset.policyLanguage !== language;
    });

    const metadata = pageMetadata[page]?.[language];
    if (metadata) {
      document.title = metadata.title;
      const description = document.querySelector('meta[name="description"]');
      if (description) description.content = metadata.description;
    }

    updateInternalLinks(language);

    if (persist) {
      try {
        window.localStorage.setItem(languageKey, language);
      } catch (_) {
        // Keep the language active for this page even if storage is unavailable.
      }
    }
  }

  setLanguage(resolveInitialLanguage(), false);

  document.querySelectorAll("[data-lang-choice]").forEach((button) => {
    button.addEventListener("click", () => {
      setLanguage(button.dataset.langChoice);
    });
  });

  const header = document.querySelector("[data-header]");
  const updateHeader = () => {
    header?.classList.toggle("is-scrolled", window.scrollY > 18);
  };
  updateHeader();
  window.addEventListener("scroll", updateHeader, { passive: true });

  const menuButton = document.querySelector("[data-menu-button]");
  const navigation = document.querySelector("[data-nav]");

  function closeMenu() {
    menuButton?.setAttribute("aria-expanded", "false");
    navigation?.classList.remove("is-open");
    document.body.classList.remove("menu-open");
  }

  menuButton?.addEventListener("click", () => {
    const willOpen = menuButton.getAttribute("aria-expanded") !== "true";
    menuButton.setAttribute("aria-expanded", String(willOpen));
    navigation?.classList.toggle("is-open", willOpen);
    document.body.classList.toggle("menu-open", willOpen);
  });

  navigation?.querySelectorAll("a").forEach((link) => {
    link.addEventListener("click", closeMenu);
  });

  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") closeMenu();
  });

  document.querySelectorAll("[data-current-year]").forEach((element) => {
    element.textContent = String(new Date().getFullYear());
  });
})();
