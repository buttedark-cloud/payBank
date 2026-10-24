import { Router, Request, Response } from 'express';
import { db, UserAccount } from '../data/database';
import axios from 'axios';

const router = Router();

// 1. Регистрация (теперь принимаем телефон в поле cardNumber / phone и генерируем карту)
router.post('/register', (req: Request, res: Response) => {
    const { name, cardNumber } = req.body; // cardNumber здесь выступает переданным номером телефона

    if (!name || !cardNumber) {
        return res.status(400).json({
            success: false,
            message: 'Укажите имя и номер телефона',
        });
    }

    // Проверяем, есть ли пользователь с таким телефоном
    const existingUser = db.users.find((u) => u.phone === cardNumber || u.cardNumber === cardNumber);

    if (existingUser) {
        return res.json({
            success: true,
            message: 'Пользователь уже зарегистрирован!',
            account: existingUser,
        });
    }

    // Генерируем реальный банковский счет и карту для переводов
    const newAccount: UserAccount = {
        id: String(Date.now()),
        name,
        phone: cardNumber, // сохраняем телефон
        balance: 5000.0,
        cardNumber: `4400-${Math.floor(1000 + Math.random() * 9000)}-${Math.floor(1000 + Math.random() * 9000)}-${Math.floor(1000 + Math.random() * 9000)}`,
    };

    db.users.push(newAccount);

    return res.status(201).json({
        success: true,
        message: 'Заявка одобрена! Счет успешно создан.',
        account: newAccount,
    });
});

// 2. Получение аккаунта по номеру карты
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

// 3. Курсы валют
router.get('/rates', async (req: Request, res: Response) => {
    try {
        const response = await axios.get('https://open.er-api.com/v6/latest/USD');
        return res.json({
            success: true,
            base: response.data.base_code,
            rates: response.data.rates,
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

// 4. Переводы СТРОГО по номерам карт
router.post('/transfer', (req: Request, res: Response) => {
    const { senderCardNumber, recipientCardNumber, amount } = req.body;

    if (!senderCardNumber || !recipientCardNumber || !amount) {
        return res.status(400).json({
            success: false,
            message: 'Укажите карту отправителя, карту получателя и сумму перевода',
        });
    }

    const transferAmount = Number(amount);
    if (isNaN(transferAmount) || transferAmount < 100) {
        return res.status(400).json({
            success: false,
            message: 'Некорректная сумма перевода, она должна быть больше 100',
        });
    }

    const sender = db.users.find((u) => u.cardNumber === senderCardNumber);
    if (!sender) {
        return res.status(404).json({
            success: false,
            message: 'Счет отправителя не найден',
        });
    }

    if (sender.balance < transferAmount) {
        return res.status(400).json({
            success: false,
            message: 'Недостаточно средств на балансе',
        });
    }

    const recipient = db.users.find((u) => u.cardNumber === recipientCardNumber);
    if (!recipient) {
        return res.status(404).json({
            success: false,
            message: 'Карта получателя не найдена',
        });
    }

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