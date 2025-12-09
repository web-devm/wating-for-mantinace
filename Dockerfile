# ----------------------------------------------------
# المرحلة الأولى: البناء (Builder Stage) - لتثبيت جميع الاعتمادات وبناء المشروع
# ----------------------------------------------------
FROM node:22-alpine AS builder 

WORKDIR /app

# نسخ ملفات الحزم أولاً للاستفادة من ذاكرة التخزين المؤقت (Caching) 
COPY package.json package-lock.json ./ 

# تثبيت الاعتمادات الكاملة
RUN npm install

# نسخ بقية ملفات المشروع
COPY . .

# تشغيل عملية بناء Next.js
RUN npm run build

# ----------------------------------------------------
# المرحلة الثانية: التشغيل (Runner Stage) - لتشغيل التطبيق بأقل حجم ممكن وأمان أعلى
# ----------------------------------------------------
FROM node:22-alpine

WORKDIR /app

# إنشاء مستخدم غير جذري (nextjs) لأغراض أمنية
RUN addgroup --system nextjs
RUN adduser --system --ingroup nextjs nextjs

# تعيين المنفذ الذي سيعمل عليه Next.js داخل الحاوية
ENV PORT 3000
EXPOSE 3000

# نسخ المخرجات النهائية من مرحلة البناء
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# *تم التعديل*: نستخدم 'next.config.ts' لأنه الاسم الصحيح في مستودعك.
COPY --from=builder /app/next.config.ts ./
COPY --from=builder /app/package.json ./

# *تم التعديل*: نقوم بنسخ ملفات العقد (node_modules) اللازمة للتشغيل فقط
# بما أنك تستخدم وضع 'standalone' و Node:22-alpine، فالطريقة الأكثر كفاءة هي تثبيت اعتمادات الإنتاج فقط:
RUN npm install --omit=dev

# تعيين أذونات التشغيل للمستخدم غير الجذري
RUN chown -R nextjs:nextjs /app

# التحويل إلى المستخدم غير الجذري قبل تشغيل التطبيق (أمر ضروري للأمان)
USER nextjs

# الأمر الافتراضي لتشغيل التطبيق
CMD ["npm", "start"]