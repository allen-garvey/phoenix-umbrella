export const extractFileName = (filePath) => {
    const fileSplit = filePath.split('/');
    return fileSplit[fileSplit.length - 1];
};