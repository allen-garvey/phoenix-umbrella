import test from 'ava';
import { getMonthSunday, formatDate } from './date.js';

test('getMonthSunday()', (t) => {
    const maySundayDateMidnight = getMonthSunday(
        new Date('2024-05-17T00:51:35.034Z')
    );

    t.is(28, maySundayDateMidnight.getDate(), 'Midnight Day of month');
    t.is(3, maySundayDateMidnight.getMonth(), 'Midnight Month');
    t.is('2024-04-28', formatDate(maySundayDateMidnight), 'Midnight ISO Date');

    const maySundayDate3 = getMonthSunday(new Date('2024-05-17T12:51:35.034Z'));

    t.is(28, maySundayDate3.getDate(), 'Day of month');
    t.is(3, maySundayDate3.getMonth(), 'Month');
    t.is('2024-04-28', formatDate(maySundayDate3), 'ISO Date');
});
