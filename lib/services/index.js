const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.kirimNotifikasiKeAdmin = functions.firestore
  .document('tagihan_user/{userId}/items/{itemId}')
  .onUpdate(async (change, context) => {
    const after = change.after.data();
    const before = change.before.data();

    // Cek apakah status berubah ke 'menunggu_konfirmasi'
    if (before.status !== 'menunggu_konfirmasi' && after.status === 'menunggu_konfirmasi') {
      // Ambil semua admin
      const adminSnapshot = await admin.firestore()
        .collection('users')
        .where('role', '==', 'admin')
        .get();

      const tokens = adminSnapshot.docs
        .map(doc => doc.data().fcmToken)
        .filter(token => token); // buang null/undefined

      if (tokens.length === 0) {
        console.log('Tidak ada admin dengan token FCM');
        return;
      }

      const payload = {
        notification: {
          title: 'Konfirmasi Pembayaran Diperlukan',
          body: 'Ada pembayaran dari warga yang perlu dikonfirmasi.',
        },
      };

      const response = await admin.messaging().sendMulticast({
        tokens: tokens,
        ...payload,
      });

      console.log(`${response.successCount} notifikasi berhasil dikirim.`);
    }
  });
