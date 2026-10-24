import express, { Request, Response } from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import bankRoutes from './routes/bankRoutes'; // Импортируем наши роуты

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Проверочный эндпоинт
app.get('/', (req: Request, res: Response) => {
    res.json({
        message: 'Привет от бэкенда банковского приложения! 🚀',
        status: 'Server is running successfully',
    });
});

// Подключаем наши банковские роуты с префиксом /api
app.use('/api', bankRoutes);

app.listen(PORT, () => {
    console.log(`✨ Сервер успешно запущен на http://localhost:${PORT}`);
});