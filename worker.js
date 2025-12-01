export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    // 정적 파일 제공
    try {
      return await env.MY_ASSETS.fetch(request);
    } catch (e) {
      return new Response('File not found', { status: 404 });
    }
  }
}
