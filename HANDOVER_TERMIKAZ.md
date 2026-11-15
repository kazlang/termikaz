# Handover & Contexto Operacional: TermiKAZ Terminal Emulator

> **Objetivo deste documento:** Servir como prompt inicial e contexto soberano ao abrir um **novo chat dedicado exclusivamente ao TermiKAZ**. Cole o conteúdo deste arquivo na primeira mensagem da nova sessão para garantir continuidade de desenvolvimento do terminal.

---

## 1. Identidade e Arquitetura do TermiKAZ
- **Projeto:** **TermiKAZ**
- **Tipo:** Emulador de terminal moderno, multiplataforma (Linux X11/Wayland, Windows), focado em alta fidelidade de renderização gráfica, suporte nativo ao ecossistema Kaz e integração PTY de alto desempenho.
- **Stack Tecnológica:**
  - Rust nativo (WGPU / Eframe / Egui ou backend customizado de terminal).
  - PTY / ConPTY (Windows) e Forkpty (Unix/Linux).
  - Parser ANSI / VT100 / Xterm com suporte a TrueColor (24-bit RGB) e SGR.
  - Arquitetura inspirada em Electerm/Warp: dock lateral moderno, abas dinâmicas, editor de temas integrado e atalhos customizáveis.
- **Diretrizes do Projeto:**
  - Código limpo e modular em Rust.
  - Comentários e documentação prioritariamente em inglês.
  - Compilação com `-j 2` no ambiente atual para preservar a estabilidade de recursos do sistema.

---

## 2. Repositórios e Pastas
- **Repositório Privado (Desenvolvimento):** `/home/armando/Projetos/TermiKAZ` (branch `main`)
- **Repositório Público (Distribuição):** `/home/armando/Projetos/TermiKAZ-Public` (branch `main`)

---

## 3. Estado Atual & Grande Decisão Arquitetural (Onde Paramos)
- **Diagnóstico Crítico:** O TermiKAZ está atualmente **desatualizado** em relação à maturidade atual do ecossistema Kaz 1.5.0 e das novas capacidades da linguagem.
- **A Decisão Central para o Novo Chat:**
  - **Opção A (Atualização Incremental em Rust):** Atualizar as dependências e amarrar com a nova VM.
  - **Opção B (Reescrever 100% em Kaz - RECOMENDADA):** Fazer a reescrita do TermiKAZ **diretamente em linguagem Kaz**. 
    - *Por que B é a escolha soberana?* Seria a vitrine máxima do ecossistema: um emulador de terminal moderno, de alta performance, construído com a própria linguagem Kaz. Com o compilador Cranelift JIT/AOT, bindings nativos de terminal e o novo runtime com zero-copy, um **TermiKAZ escrito em Kaz** fecha o ciclo de soberania do projeto (o terminal feito na linguagem que ele executa).

---

## 4. Roteiro de Trabalho para o Novo Chat (TermiKAZ)

1. **Definição da Arquitetura do TermiKAZ em Kaz Nativo:**
   - Avaliar a interface de renderização (GUI com canvas nativo ou TUI avançada estilo Alacritty/Ghostty).
   - Primitivas de I/O em Kaz: PTY, buffer circular de linhas, parser ANSI/VT100 escrito em Kaz.
2. **Setup do Projeto (`kaz new termikaz`):**
   - Estruturação do novo código fonte em Kaz (`src/main.kaz`, `src/pty.kaz`, `src/render.kaz`, `src/terminal.kaz`).
3. **Migração ou Substituição do Código Legado em Rust:**
   - Isolar apenas o que for estritamente intrínseco de SO (caso precise de alguma syscall de baixo nível de PTY via runtime do Kaz) e deixar 100% da lógica e UI no Kaz.
