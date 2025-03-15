describe("correct fetch request to api", () => {
  it("should return hello from test request", async () => {
    const response = { json: jest.fn().mockResolvedValue("Hola") };
    const data = await response.json();
    expect(data).toBe("Hola");
  });
});
