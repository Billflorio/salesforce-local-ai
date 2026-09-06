try {
    String res = GeminiCalloutService.generateResponse('Reply with exactly one word: SUCCESS', '{}');
    System.debug('GEMINI_TEST_RESULT: ' + res);
} catch (Exception e) {
    System.debug('GEMINI_TEST_ERROR: ' + e.getMessage());
}
