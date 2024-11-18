const express = require('express');
const jwt = require('jsonwebtoken');
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');

const app = express();
const PORT = 3000;

// 中间件
app.use(bodyParser.json());
app.use(cookieParser());

// 秘钥（实际项目中请使用环境变量）
const ACCESS_TOKEN_SECRET = 'your-access-token-secret';
const REFRESH_TOKEN_SECRET = 'your-refresh-token-secret';

// 模拟数据库
const users = [
  { id: 1, username: 'user1', password: 'pass1', role: 'user' },
  { id: 2, username: 'admin', password: 'pass2', role: 'admin' }
];
let refreshTokens = []; // 用于存储有效的刷新 Token

// 生成 Access Token
function generateAccessToken(user) {
  return jwt.sign({ id: user.id, username: user.username, role: user.role }, ACCESS_TOKEN_SECRET, { expiresIn: '15m' });
}

// 生成 Refresh Token
function generateRefreshToken(user) {
  const refreshToken = jwt.sign({ id: user.id }, REFRESH_TOKEN_SECRET, { expiresIn: '7d' });
  refreshTokens.push(refreshToken);
  return refreshToken;
}

// 登录接口
app.post('/login', (req, res) => {
  const { username, password } = req.body;

  // 验证用户名和密码
  const user = users.find(u => u.username === username && u.password === password);
  if (!user) return res.status(401).json({ message: 'Invalid credentials' });

  // 生成 Token
  const accessToken = generateAccessToken(user);
  const refreshToken = generateRefreshToken(user);

  // 将 Refresh Token 设置为 HttpOnly Cookie
  res.cookie('refreshToken', refreshToken, { httpOnly: true, secure: true });
  res.json({ accessToken });
});

// 受保护的路由
app.get('/protected', authenticateToken, (req, res) => {
  res.json({ message: `Hello, ${req.user.username}!`, user: req.user });
});

// 刷新 Token
app.post('/refresh', (req, res) => {
  const refreshToken = req.cookies.refreshToken;

  // 检查 Refresh Token 是否存在且合法
  if (!refreshToken || !refreshTokens.includes(refreshToken)) {
    return res.status(403).json({ message: 'Forbidden' });
  }

  jwt.verify(refreshToken, REFRESH_TOKEN_SECRET, (err, user) => {
    if (err) return res.status(403).json({ message: 'Forbidden' });

    // 生成新的 Access Token
    const accessToken = generateAccessToken({ id: user.id, username: user.username, role: user.role });
    res.json({ accessToken });
  });
});

// 注销接口
app.post('/logout', (req, res) => {
  const refreshToken = req.cookies.refreshToken;

  // 从存储中移除 Refresh Token
  refreshTokens = refreshTokens.filter(token => token !== refreshToken);

  res.clearCookie('refreshToken'); // 清除 Cookie
  res.json({ message: 'Logged out successfully' });
});

// 中间件：验证 Access Token
function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) return res.status(401).json({ message: 'Unauthorized' });

  jwt.verify(token, ACCESS_TOKEN_SECRET, (err, user) => {
    if (err) return res.status(403).json({ message: 'Forbidden' });

    req.user = user; // 将用户信息附加到请求对象
    next();
  });
}

// 启动服务器
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
