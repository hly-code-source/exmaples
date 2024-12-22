const express = require('express');
const axios = require('axios');
require('dotenv').config();

const app = express();
const PORT = 3000

// GitHub OAuth 配置
const CLIENT_ID = process.env.CLIENT_ID;
const CLIENT_SECRET = process.env.CLIENT_SECRET;
const REDIRECT_URI = "http://localhost:3000/auth/github/callback";

// 首页路由
app.get('/', (req, res) => {
    res.send('<a href="/auth/github">使用 GitHub 登录</a>');
});

// 重定向用户到 GitHub 授权
app.get('/auth/github', (req, res) => {
    const githubAuthURL = `https://github.com/login/oauth/authorize?client_id=${CLIENT_ID}&redirect_uri=${REDIRECT_URI}&scope=read:user user:email`;
    res.redirect(githubAuthURL);
});

// GitHub 回调
app.get('/auth/github/callback', async (req, res) => {
    const code = req.query.code;

    if (!code) {
        return res.status(400).send("没有收到 GitHub 的授权码！");
    }

    try {
        // 用授权码换取访问令牌
        const tokenResponse = await axios.post(
            'https://github.com/login/oauth/access_token',
            {
                client_id: CLIENT_ID,
                client_secret: CLIENT_SECRET,
                code: code,
            },
            {
                headers: { Accept: 'application/json' },
            }
        );

        const accessToken = tokenResponse.data.access_token;

        // 用访问令牌获取用户信息
        const userResponse = await axios.get('https://api.github.com/user', {
            headers: { Authorization: `Bearer ${accessToken}` },
        });

        const userData = userResponse.data;

        res.send(`
            <h1>GitHub 登录成功</h1>
            <p>用户名：${userData.login}</p>
            <img src="${userData.avatar_url}" alt="avatar" width="100">
        `);
    } catch (error) {
        console.error(error);
        res.status(500).send("登录过程出错！");
    }
});

// 启动服务器
app.listen(PORT, () => {
    console.log(`服务器已启动：http://localhost:${PORT}`);
});
