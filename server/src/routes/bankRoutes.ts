import { Router, Request, Response } from 'express';
import { db, UserAccount } from '../data/database';
import axios from 'axios';

const router = Router();

// 1. Регистрация: принимаем имя и телефон, генерируем карту
router.post('/register', (req: Request, res: Response) => {
    const { name, phone, passportNumber, cardNumber } = req.body;
    // Клиент сейчас шлёт телефон в passportNumber, поэтому берём любое из полей
    const userPhone = phone ?? passportNumber ?? cardNumber;

    if (!name || !userPhone) {
        res.status(400).json({
            success: false,
            message: 'Укажите имя и номер телефона',
        });
        return;
    }

    // Проверяем, есть ли пользователь с таким телефоном
    const existingUser = db.users.find((u) => u.phone === userPhone);

    if (existingUser) {
        res.json({
            success: true,
            message: 'Пользователь уже зарегистрирован!',
            account: existingUser,
        });
        return;
    }

    // Генерируем счёт и карту для переводов
    const newAccount: UserAccount = {
        id: String(Date.now()),
        name,
        phone: userPhone,
        balance: 5000.0,
        cardNumber: `4400-${Math.floor(1000 + Math.random() * 9000)}-${Math.floor(1000 + Math.random() * 9000)}-${Math.floor(1000 + Math.random() * 9000)}`,
    };

    db.users.push(newAccount);

    res.status(201).json({
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
        res.status(404).json({
            success: false,
            message: 'Счет с таким номером карты не найден',
        });
        return;
    }

    res.json({
        success: true,
        account,
    });
});

// 3. Курсы валют
router.get('/rates', async (req: Request, res: Response) => {
    try {
        const response = await axios.get('https://open.er-api.com/v6/latest/USD');
        res.json({
            success: true,
            base: response.data.base_code,
            rates: response.data.rates,
            date: response.data.time_last_update_utc,
        });
    } catch (error) {
        console.error('Ошибка при получении курсов валют:', error);
        res.status(500).json({
            success: false,
            message: 'Не удалось получить курсы валют',
        });
    }
});

// 4. Переводы СТРОГО по номерам карт
router.post('/transfer', (req: Request, res: Response) => {
    const { senderCardNumber, recipientCardNumber, amount } = req.body;

    if (!senderCardNumber || !recipientCardNumber || !amount) {
        res.status(400).json({
            success: false,
            message: 'Укажите карту отправителя, карту получателя и сумму перевода',
        });
        return;
    }

    const transferAmount = Number(amount);
    if (isNaN(transferAmount) || transferAmount < 100) {
        res.status(400).json({
            success: false,
            message: 'Минимальная сумма перевода — 100',
        });
        return;
    }

    const sender = db.users.find((u) => u.cardNumber === senderCardNumber);
    if (!sender) {
        res.status(404).json({
            success: false,
            message: 'Счет отправителя не найден',
        });
        return;
    }

    if (sender.balance < transferAmount) {
        res.status(400).json({
            success: false,
            message: 'Недостаточно средств на балансе',
        });
        return;
    }

    const recipient = db.users.find((u) => u.cardNumber === recipientCardNumber);
    if (!recipient) {
        // Номер в формате ####-####-####-#### считаем картой другого банка:
        // деньги списываются у отправителя, перевод проходит
        if (/^\d{4}-\d{4}-\d{4}-\d{4}$/.test(recipientCardNumber)) {
            sender.balance -= transferAmount;
            res.json({
                success: true,
                message: 'Перевод на карту другого банка выполнен!',
                senderNewBalance: sender.balance,
            });
            return;
        }

        res.status(404).json({
            success: false,
            message: 'Карта получателя не найдена',
        });
        return;
    }

    sender.balance -= transferAmount;
    recipient.balance += transferAmount;

    res.json({
        success: true,
        message: 'Перевод успешно выполнен!',
        senderNewBalance: sender.balance,
        recipientNewBalance: recipient.balance,
    });
});

export default router;