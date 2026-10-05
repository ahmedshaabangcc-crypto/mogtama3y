FROM node:22-alpine
# ffmpeg converts uploaded report videos to H.264 MP4.
RUN apk add --no-cache ffmpeg
WORKDIR /app
CMD ["node", "server.mjs"]
