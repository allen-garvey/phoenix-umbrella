import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { splitTitle } from './forms.js';

describe('splitTitle()', () => {
    it('should not modify titles without colons', () => {
        assert.deepEqual(splitTitle('hello '), ['hello ', '']);
        assert.deepEqual(splitTitle('Something cool'), ['Something cool', '']);
    });

    it('should not modify titles with colons at the end', () => {
        assert.deepEqual(splitTitle('hello:'), ['hello:', '']);
    });

    it('should split titles with colons', () => {
        assert.deepEqual(splitTitle('The Book:  of life'), [
            'The Book',
            'of life',
        ]);
    });

    it('should split titles with multiple colons', () => {
        assert.deepEqual(splitTitle('The Book: of life:  that heals'), [
            'The Book: of life',
            'that heals',
        ]);
    });
});
