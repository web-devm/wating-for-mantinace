

export default function MaintenancePage() {
  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-gray-50 px-6 text-center">
      <div className="bg-white p-8 rounded-2xl shadow-lg max-w-md w-full">
        <div className="flex justify-center mb-4 text-[#4F3130] text-6xl">
        </div>

        <h1 className="text-2xl font-bold text-gray-800 mb-2">الموقع تحت الصيانة</h1>
        <p className="text-gray-600 mb-6">
          نعمل حالياً على تحسين هذا الموقع لتقديم تجربة أفضل. <br />
          يرجى المحاولة لاحقاً.
        </p>

       
      </div>

      <p className="mt-8 text-sm text-gray-500">© {new Date().getFullYear()} جميع الحقوق محفوظة لوزارة المالية</p>
    </div>
  );
}
