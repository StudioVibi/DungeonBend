declare module "bun:test" {
  export function describe(name: string, fn: () => void): void;
  export function test(name: string, fn: () => void | Promise<void>): void;
  export function expect(value: unknown): {
    toBe(expected: unknown): void;
    toEqual(expected: unknown): void;
    toHaveLength(expected: number): void;
    toThrow(expected?: unknown): void;
  };
}

declare var Bun: {
  file(path: string | URL): {
    json(): Promise<unknown>;
    text(): Promise<string>;
  };
};

interface ImportMeta {
  dirname: string;
}
