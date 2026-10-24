// Описываем структуру пользователя (наш аналог Model во Flutter)
export interface UserAccount {
id: string;
name: string;
phone: string;
passportNumber?: string;
balance: number;
cardNumber: string;
}

// Создаем начальную базу данных прямо в памяти (массив)
export const db: { users: UserAccount[] } = {
users: [
    {
        id: '1',
        name: 'Александра Прохорова',
        passportNumber: 'AN1234567',
        phone: '+7 (999) 123-45-67',
        balance: 15000.00,
        cardNumber: '4400-1111-2222-3333',
    },
{
id: '2',
name: 'Алекс Шварц',
    passportNumber: 'AN1234568',
    phone: '+7 (999) 987-65-43',
        balance: 30000.00,
            cardNumber: '4400-9999-8888-7777',
},
],
};