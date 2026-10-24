import { Router, Request, Response } from 'express';
import { db, UserAccount } from '../data/database';
import axios from 'axios';

const router = Router();

// 1. Регистрация / проверка паспорта
// Эндпоинт: POST /api/register
router.post('/register', (req: Request, res: Response) => {
    const { name, passportNumber } = req.body;

    // Проверяем, прислал ли Flutter данные
    if (!name || !passportNumber) {
        return res.status(400).json({
            success: false,
            message: 'Укажите имя и номер паспорта',
        });
    }

    // Проверяем, есть ли уже такой пользователь
    const existingUser = db.users.find((u) => u.passportNumber === passportNumber);

    if (existingUser) {
        return res.json({
            success: true,
            message: 'Пользователь уже зарегистрирован!',
            account: existingUser,
        });
    }

    // Если пользователя нет — генерируем ему новый счет и карту
    const newAccount: UserAccount = {
        id: String(Date.now()), // уникальный id на основе времени
        name,
        passportNumber,
        balance: 5000.0, // Дарим стартовый бонус при регистрации!
        cardNumber: `4400-${Math.floor(1000 + Math.random() * 9000)}-${Math.floor(1000 + Math.random() * 9000)}-${Math.floor(1000 + Math.random() * 9000)}`,
    };

    // Сохраняем пользователя в нашу базу данных (массив)
    db.users.push(newAccount);

    // Отправляем ответ обратно во Flutter
    return res.status(201).json({
        success: true,
        message: 'Заявка одобрена! Счет успешно создан.',
        account: newAccount,
    });
});

// 2. Получение данных аккаунта по номеру карты
// Эндпоинт: GET /api/account/:cardNumber
router.get('/account/:cardNumber', (req: Request, res: Response) => {
    const { cardNumber } = req.params;

    const account = db.users.find((u) => u.cardNumber === cardNumber);

    if (!account) {
        return res.status(404).json({
            success: false,
            message: 'Счет с таким номером карты не найден',
        });
    }

    return res.json({
        success: true,
        account,
    });
});

// 3. Получение курсов валют через внешний API (используем axios)
// Эндпоинт: GET /api/rates
router.get('/rates', async (req: Request, res: Response) => {
    try {
        // Делаем запрос к бесплатному публичному API курсов валют
        const response = await axios.get('https://open.er-api.com/v6/latest/USD');

        return res.json({
            success: true,
            base: response.data.base_code,
            rates: response.data.rates, // Курсы валют относительно USD
            date: response.data.time_last_update_utc,
        });
    } catch (error) {
        console.error('Ошибка при получении курсов валют:', error);
        return res.status(500).json({
            success: false,
            message: 'Не удалось получить курсы валют',
        });
    }
});

// 4. Перевод средств с карты на карту
// Эндпоинт: POST /api/transfer
router.post('/transfer', (req: Request, res: Response) => {
    const { senderCardNumber, recipientCardNumber, amount } = req.body;

    // Проверяем, все ли данные переданы
    if (!senderCardNumber || !recipientCardNumber || !amount) {
        return res.status(400).json({
            success: false,
            message: 'Укажите карту отправителя, карту получателя и сумму перевода',
        });
    }

    // Сумма должна быть больше нуля
    const transferAmount = Number(amount);
    if (isNaN(transferAmount) || transferAmount < 100) {
        return res.status(400).json({
            success: false,
            message: 'Некорректная сумма перевода, она должна быть больше 100',
        });
    }

    // Ищем отправителя в нашей базе
    const sender = db.users.find((u) => u.cardNumber === senderCardNumber);
    if (!sender) {
        return res.status(404).json({
            success: false,
            message: 'Счет отправителя не найден',
        });
    }

    // Проверяем, достаточно ли денег на балансе
    if (sender.balance < transferAmount) {
        return res.status(400).json({
            success: false,
            message: 'Недостаточно средств на балансе',
        });
    }

    // Ищем получателя
    const recipient = db.users.find((u) => u.cardNumber === recipientCardNumber);
    if (!recipient) {
        return res.status(404).json({
            success: false,
            message: 'Карта получателя не найдена',
        });
    }

    // Выполняем транзакцию: списываем у одного, добавляем другому
    sender.balance -= transferAmount;
    recipient.balance += transferAmount;

    return res.json({
        success: true,
        message: 'Перевод успешно выполнен!',
        senderNewBalance: sender.balance,
        recipientNewBalance: recipient.balance,
    });
});

export default router;