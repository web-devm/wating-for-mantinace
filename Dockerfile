FROM node:22-alpine AS builder 

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

FROM node:22-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev

# نسخ مخرجات البناء من المرحلة الأولى (builder)
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/next.config.ts ./
COPY --from=builder /app/package.json ./

# تعيين المنفذ الذي سيعمل عليه Next.js داخل الحاوية (عادةً 3000)
ENV PORT 3000
EXPOSE 3000

# الأمر الافتراضي لتشغيل التطبيق
CMD ["npm", "start"]