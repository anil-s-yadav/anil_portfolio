# anil_portfolio
## My Portfolio URL
(firebase hosted) https://anil-portfolio-388df.web.app/
<br><br>
(Inactive - Render hosted) - https://anil-portfolio-o2q9.onrender.com/

# 🚀 Flutter Web Portfolio – Render Deployment Guide

This project contains a complete Flutter app (Android, iOS, Web).
Only the **web build (`build/web`)** is deployed to Render.<br>
resume is uploaded on "anilyadav44x@gmail.com" drive.

---

## 📌 Deployment Strategy

We use **local build + GitHub + Render static hosting**.

Render does NOT build Flutter.
Instead, we:

✅ Build Flutter Web locally  
✅ Push only `build/web` to GitHub  
✅ Let Render serve `build/web`

This makes deployment fast and reliable.

---

## 📁 Git Ignore Configuration

In `.gitignore`, we ignore all build files except web:

```gitignore
/build/*
!/build/web/
!/build/web/**
