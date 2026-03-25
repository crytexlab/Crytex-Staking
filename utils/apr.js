function calculateAPR(amount, rate, days) {
  return (amount * rate * days) / (365 * 100);
}

module.exports = { calculateAPR };
