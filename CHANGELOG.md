# Changelog - TermiKAZ

Todas as alterações notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado no [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/)
e este projeto adere ao [Versionamento Semântico](https://semver.org/lang/pt-BR/).

---

## [1.2.0] - 2026-09-25

### 🛡️ Segurança (Security Hardening)
- **Mitigação de Command Injection via Process Command API (`src/shell/evaluator.rs`):**
  - Implementada a função de sanitização e validação prévia de comandos `sanitize_and_prepare_command`.
  - Rejeição estrita de bytes nulos (`\0`) no executável e em todos os argumentos, prevenindo ataques de truncamento de strings na Win32 API.
  - Rejeição estrita de caracteres de controle ASCII não-imprimíveis (`< 0x20`, exceto tabulação).
  - **Proteção contra CVE-2024-24576 (RUSTSEC-2024-0019) no Windows:** Ao executar scripts batch (`.bat` ou `.cmd`), argumentos contendo metacaracteres perigosos de interpolação (`&`, `|`, `<`, `>`, `^`, `%`, `\n`, `\r`) são bloqueados e rejeitados.
  - Sanitização de variáveis de ambiente passadas para subprocessos (rejeição de chaves com bytes nulos ou caractere `=`).
  - Prevenção de bloqueio/hang por `stdin`: subprocessos sem dados de entrada via pipe agora usam `Stdio::null()` em vez de herdar `stdin`.
- **Auditoria de Dependências (`cargo audit`):**
  - Atualizado `rustls` para `0.23.45` em todo o workspace, fechando a advisory RUSTSEC-2026-0285.
  - Removidas dependências vulneráveis `rand` e `paste` desativando `accesskit` desnecessário em `eframe`.
  - Pinned `quick-xml` `>= 0.41.0`, mitigando vulnerabilidades de complexidade algorítmica e DoS (RUSTSEC-2026-0194 e RUSTSEC-2026-0195).
  - **Auditoria 100% limpa:** 0 vulnerabilidades em 408 crates analisadas.

### 🌐 Codificação & Caracteres (UTF-8 / OEM / ASCII)
- **Página de Código UTF-8 no Windows:** Inicialização forçada do console Windows para **Code Page 65001 (UTF-8)** na inicialização via Win32 API (`SetConsoleOutputCP` e `SetConsoleCP`).
- **Decodificador Híbrido de Processos (`decode_process_output`):**
  - Decodificação inteligente de saída de processos e sessões PTY.
  - Tenta UTF-8 estrito; caso falhe, decodifica a partir da página de código OEM da máquina (CP850 em PT-BR / CP437 em US) via `MultiByteToWideChar(CP_OEMCP)`.
  - Elimina substituição de acentos (`ã`, `é`, `ç`, `ó`) por caracteres substitutos `` (`\u{FFFD}`) em comandos nativos do Windows (`dir`, `ipconfig`, etc.).
- **Adoção de Caracteres Universais:**
  - Substituído glifo de Nerd Font / PUA (`` U+E0A0) por badge universal `git:` (evita retângulos vazios `□` em terminais e na GUI).
  - Substituição de emojis e pontas de seta (`🦅`, `╭─`, `╰─❯`, `❯`, `✔`, `✖`, `●`) por caracteres de caixa e setas padrão (`┌─`, `└─>`, `>`, `[OK]`, `[ERRO]`, `[PRONTO]`, `x`).
  - Aprimorado `strip_ansi_or_clean` para descartar com segurança sequências CSI, sequências OSC de título e códigos de controle como `\x07` (BEL) e `\r`.

### 🦅 Linguagem Kaz
- Sincronização direta com a biblioteca e runtime da linguagem Kaz v1.1.0 (`kaz = { path = "../kaz" }`).
- Suporte a tagged unions, pattern matching (`match`), operadores bitwise (`&`, `|`, `^`, `<<`, `>>`) e operador null-coalescing (`??`).
- Novos testes automatizados de integração Kaz e sanitização de comandos (totalizando 21 testes com 100% de aprovação).

### 📦 Empacotamento
- Atualizados scripts de instalação Inno Setup 7 (`TermiKAZ_Setup_v1.2.0.exe`) e NSIS (`TermiKAZ_NSIS_Setup_v1.2.0.exe`).
- Removidos binários obsoletos v1.1.0 da pasta `dist/`.

---

## [1.1.0] - 2026-09-24

### Adicionado
- **Motor de Autocomplete Rápido com `[TAB]`:**
  - Implementado `TermiKazCompleter` integrado ao `reedline` com menu colunar `ColumnarMenu`.
  - Suporte a preenchimento instantâneo de comandos nativos Linux, binários do sistema e subcomandos Kaz.
  - Navegação de diretórios com filtro automático em `cd` (adicionando `/` ao final de pastas).
  - Autocomplete interativo na interface gráfica com chips de sugestões flutuantes.
- **Integração Profunda com a Linguagem Kaz:**
  - Suporte aos subcomandos nativos: `kaz <file.kaz>`, `kaz run`, `kaz jit`, `kaz build`, `kaz fmt`, `kaz test`, `kaz trace`, `kaz debug`, `kaz db-cli`, `kaz vm`, `kaz check`, `kaz repl`, `kaz audit`.
- **4 Temas Visuais para a GUI:**
  - Kaz Neon (Padrão), Catppuccin Mocha, Dracula e Matrix Neon.
- **Atalhos Rápidos na Interface Gráfica:**
  - Botões para `tree`, `ls -la`, `Audit`, `Test`, `Fmt`, `JIT` e controle de zoom (`A+` / `A-`).

---

## [1.0.0] - 2026-08-28

### Adicionado
- Versão inicial do **TermiKAZ**, emulador de terminal e shell Linux nativo para Windows.
- Mais de 35 comandos Linux embutidos em Rust (`ls`, `cd`, `pwd`, `mkdir`, `rm`, `cp`, `mv`, `touch`, `tree`, `cat`, `grep`, `wc`, `find`, `sort`, `uniq`, `echo`, `uname`, `whoami`, `hostname`, `date`, `ps`, `kill`, `env`, `which`, `curl`, `fetch`, etc.).
- Suporte a sintaxe POSIX com pipes (`|`), redirecionamentos (`>`, `>>`, `<`), operadores lógicos (`&&`, `||`, `;`) e expansão de variáveis de ambiente.
- Tradutor transparente de caminhos POSIX (`/c/...`, `~`) para Windows (`C:\...`).
- Interface gráfica multi-abas com renderização acelerada por GPU (`egui` / `eframe`).
- Integração ConPTY (`portable-pty`) para suporte a pseudoterminais nativos do Windows.
- Scripts de empacotamento com Inno Setup e NSIS.
