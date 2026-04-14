{ lib, ... }:

{

  options.machine.kernel = {
    lts = lib.mkEnableOption "Use LTS kernel";

    cachyos = {
      enable = lib.mkEnableOption "Use CachyOS kernel";

      variant = lib.mkOption {
        type = lib.types.enum [
          # Base tracks
          "latest"
          "lts"
          # Scheduler / special variants
          "bmq"
          "bore"
          "eevdf"
          "hardened"
          "deckify"
          "rc"
          "rt-bore"
          "server"
        ];
        example = "bore";
        description = ''
          `"lts"` or `"latest"` by default, based on `config.machine.kernel.lts`

          - **latest** / **lts** — mainline / long-term support, full arch matrix available
          - **bore** / **bmq** / **eevdf** — alternative CPU schedulers
          - **rt-bore** — PREEMPT_RT + BORE scheduler
          - **hardened** — security-hardened config
          - **deckify** — Steam Deck-oriented patches
          - **server** — server-tuned config (no HZ_1000, etc.)
          - **rc** — release candidate, bleeding edge
        '';
      };

      lto = lib.mkEnableOption "Use LTO variant" // {
        description = "Should be slightly faster but will take a long time to compile.";
      };

      arch = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "x86_64-v2" # SSE4.2, POPCNT, …
            "x86_64-v3" # AVX, AVX2, BMI1/2, … (Haswell+, Zen 1+)
            "x86_64-v4" # AVX-512 (Skylake-SP+, Zen 4+)
            "zen4" # AVX-512 + AMD-specific tuning
          ]
        );
        default = null;
        example = "x86_64-v3";
        description = ''
          CPU micro-architecture optimisation level. Only applicable when
          `variant` is `"latest"` or `"lts"` — other variants ship a single
          generic build. Leave as `null` for the generic x86_64 build.

          Quick reference:
          - `x86_64-v3` — safe pick for any Haswell (2013+) / Zen 1 (2017+) CPU
          - `x86_64-v4` / `zen4` — Zen 4 (Ryzen 7000+) or recent Intel with AVX-512
        '';
      };
    };
  };
}
