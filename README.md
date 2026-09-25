<div align="center">

# 🦅 TermiKAZ

### Emulador de Terminal & Shell Linux/POSIX Nativo para Windows com Integração à Linguagem Kaz

[![Rust](https://img.shields.io/badge/Rust-1.80%2B-orange.svg?style=flat&logo=rust)](https://www.rust-lang.org)
[![Platform](https://img.shields.io/badge/Platform-Windows%20(x64)-blue.svg?style=flat&logo=windows)](https://microsoft.com/windows)
[![TermiKAZ](https://img.shields.io/badge/TermiKAZ-1.2.0-red.svg?style=flat)](https://github.com/armandosds/TermiKAZ)
[![Kaz Language](https://img.shields.io/badge/Language-Kaz%201.1.0-purple.svg?style=flat)](https://github.com/armandosds/Kaz)
[![License](https://img.shields.io/badge/License-MIT%20%2F%20Apache--2.0-green.svg)](LICENSE)

**TermiKAZ** é um emulador de terminal e ambiente shell POSIX de altíssimo desempenho desenvolvido em **Rust**. Projetado especificamente para desenvolvedores no Windows, ele oferece um ecossistema completo de comandos Linux nativos (sem necessidade de WSL, Cygwin ou máquinas virtuais), experiência rica de autocompletion com **`[TAB]`**, interface gráfica moderna acelerada por GPU e integração in-process com o ecossistema da linguagem de programação **Kaz v1.1.0** (`kaz.exe`).

</div>

---

## 📑 Sumário

- [Visão Geral](#-visão-geral)
- [Principais Recursos](#-principais-recursos)
- [Integração com a Linguagem Kaz](#-integração-com-a-linguagem-kaz)
- [Autocomplete Rápido com TAB](#-autocomplete-rápido-com-tab)
- [Interface Gráfica & ConPTY](#-interface-gráfica--conpty)
- [Instalação](#-instalação)
  - [Instaladores Oficiais Windows](#instaladores-oficiais-windows)
  - [Compilação a partir do Código-Fonte](#compilação-a-partir-do-código-fonte)
- [Guia de Uso](#-guia-de-uso)
  - [1. Shell Interativo (CLI)](#1-shell-interativo-cli)
  - [2. Emulador de Terminal Gráfico (GUI)](#2-emulador-de-terminal-gráfico-gui)
  - [3. Modo de Comando Único (`-c`)](#3-modo-de-comando-único--c)
  - [4. Execução Direta de Scripts Kaz](#4-execução-direta-de-scripts-kaz)
- [Comandos Linux Nativos Suportados](#-comandos-linux-nativos-suportados)
- [Arquitetura do Projeto](#-arquitetura-do-projeto)
- [Segurança & Auditoria](#-segurança--auditoria)
- [Changelog](#-changelog)
- [Licença](#-licença)

---

## 🌟 Visão Geral

O TermiKAZ resolve o clássico atrito de desenvolvimento no Windows: a necessidade de comandos Linux ágeis (`ls`, `grep`, `cat`, `curl`, `tree`, pipes, etc.) sem o overhead de inicialização de subsistemas pesados como o WSL. 

Tudo é compilado em código de máquina nativo x64, com tradução bidirecional transparente entre caminhos POSIX (`/c/ProjetosAM/...`, `~`) e caminhos Windows (`C:\ProjetosAM\...`), suporte a drives (`c:`, `d:`, `e:`) e atalhos rápidos (`cd..`, `cd ~`, `clear`, `cls`).

---

## ✨ Principais Recursos

- ⚡ **Comandos Linux Embutidos em Rust**: Mais de 35 utilitários essenciais reimplementados nativamente com suporte a cores ANSI, flags humanas e expressões regulares.
- 🔀 **Sintaxe POSIX Completa**:
  - **Pipelines ilimitados**: `cat logs.txt | grep 'ERRO' | sort | uniq -c`
  - **Redirecionamento de I/O**: `>` (sobrescrever), `>>` (anexar), `<` (redirecionar stdin), `2>&1` (stderr para stdout)
  - **Operadores lógicos e encadeamento**: `&&` (AND), `||` (OR), `;` (sequencial)
  - **Expansão de variáveis**: `$VAR`, `${VAR}`, `$?` (código de saída do último comando), `$HOME`, `$USER`, `$PWD`, `$PID`
  - **Histórico Persistente**: Salvo automaticamente em `~/.termikaz_history`
- 📁 **Tradutor de Caminhos Transparente**:
  - Aceita `/c/Users/Nome`, `C:\Users\Nome`, `~` (home), `..`, `./` e troca de unidades (`c:`, `d:`).
  - Preserva barras invertidas nativas do Windows sem corromper caminhos.
  - Sincronização em tempo real entre o processo e o prompt visual.
- ⚡ **Ergonomia Windows**:
  - Atalhos sem espaço: `cd..`, `cd...`, `cd\`, `cd/`, `cd~`.
  - Limpeza de tela profunda com `clear` e `cls` purgam o buffer do console Windows.

---

## 🦅 Integração com a Linguagem Kaz (v1.1.0)

O TermiKAZ possui comunicação in-process direta com a crate da linguagem de programação **Kaz v1.1.0**, aproveitando todas as inovações recentes da linguagem:

- 🏷️ **Tagged Unions / Enums com Dados**: Suporte total a tipos algébricos com dados associados (`enum Status { Pendente, Processada(int), Falha(string) }`).
- 🎯 **Pattern Matching (`match`)**: Desestruturação exaustiva de variantes e valores com wildcard (`_`).
- 🔢 **Operadores Bitwise**: Operações binárias completas (`&`, `|`, `^`, `~`, `<<`, `>>`).
- 🏛️ **4 Pilares da Biblioteca Padrão Expandida**:
  - **Math**: Funções matemáticas ampliadas (trigonometria, exponenciais, arredondamentos).
  - **Slicing & Arrays**: Fatiamento seguro e manipulação dinâmica de listas.
  - **String Transformations**: Transformações eficientes e codificação de strings.
  - **Search & Filter**: Busca, filtragem e predicados de alta performance.
- ⚡ **JIT ARC & Cranelift**: Suporte a contagem de referências atômicas e slab allocator em compilações nativas JIT.

| Comando | Descrição |
| :--- | :--- |
| `kaz <arquivo.kaz>` | Executa diretamente na **Kaz Stack Bytecode VM** |
| `kaz run <arquivo.kaz>` | Executa arquivo com resolução automática de entrypoint (`main.kaz` / `src/main.kaz`) |
| `kaz jit <arquivo.kaz>` | Compila e executa diretamente via **Cranelift JIT** em código de máquina nativo x86_64 |
| `kaz build <arquivo.kaz> [-o saida]` | Gera executável autônomo (.exe) sem dependências ou objeto nativo (`--emit-obj`) |
| `kaz fmt [caminho] [--check]` | Formata o código Kaz no padrão canônico com validação AST de segurança |
| `kaz test [caminho]` | Executa a suíte de testes unitários nativos da Kaz |
| `kaz trace <arquivo.kaz>` | Rastreia a Stack VM instrução por instrução em tempo real |
| `kaz debug <arquivo.kaz>` | Desmonta o bytecode e inspeciona a tabela de constantes |
| `kaz db-cli <banco.db>` | Console interativo embutido para bancos de dados SQLite |
| `kaz check <arquivo.kaz>` | Valida a sintaxe e integridade léxica sem executar |
| `kaz audit [diretório]` | Varre o projeto emitindo relatório de conformidade, contagem de linhas e tipos |
| `kaz repl` | Inicia o console REPL interativo Kaz |
| `kaz shell` / `kaz term` | Inicia o Kaz Terminal Shell nativo |

Você também pode executar qualquer arquivo `.kaz` diretamente como um binário:
```bash
./meu_script.kaz
termikaz meu_script.kaz
```

---

## 🎨 Temas e Janela Personalizada

Para fugir da aparência padrão do console do Windows, o TermiKAZ oferece uma interface moderna e customizável:

### 1. Temas Exclusivos Selecionáveis:
- 🦅 **Kaz Neon (Padrão)**: Fundo obsidian profundo (`#0b0d14`), acentos em violeta Kaz (`#cba6f7`), ciano (`#89dceb`) e menta neon.
- ☕ **Catppuccin Mocha**: Paleta pastel aveludada com tons lavanda, pêssego e safira.
- 🧛 **Dracula**: Tons clássicos de roxo Drácula, rosa choque e ciano elétrico.
- 📟 **Matrix Retro**: Tema hacker OLED com verde fósforo fosforescente (`#00ff66`).

### 2. Recursos Visuais da Janela:
- **Ícone Nativo Oficial**: Ícone `flux.ico` embutido na barra de título, barra de tarefas e instaladores.
- **Breadcrumb & Git Branch Ativo**: Identificação automática do branch git (` main`) e caminho POSIX no cabeçalho.
- **Prompt Starship / Powerline em TrueColor**:
  ```text
  ┌─ [kaz] armando@termikaz [/c/ProjetosAM/TermiKAZ] ─[git:main]
  └─> 
  ```
- **Chips de Sugestão Flutuantes**: Visualização instantânea de termos que serão completados ao teclar `[TAB]`.

---

## ⚡ Autocomplete Rápido com [TAB]

Para fluxos de trabalho rápidos, o TermiKAZ integra um motor contextual de autocompletion:

1. **Auto-preenchimento de Comandos**:
   - Digite `k` + `[TAB]` $\rightarrow$ completa `kaz `.
   - Digite `c` + `[TAB]` $\rightarrow$ lista `cd`, `cat`, `clear`, `cls`, `curl`, `cp`, etc.
2. **Subcomandos Kaz Sensíveis ao Contexto**:
   - `kaz ` + `[TAB]` $\rightarrow$ exibe todos os subcomandos Kaz (`fmt`, `test`, `run`, `jit`, `build`, `trace`, `debug`, `db-cli`, `check`, `vm`, `repl`, etc.) com descrições detalhadas.
   - `kaz j` + `[TAB]` $\rightarrow$ completa `kaz jit `.
   - `kaz b` + `[TAB]` $\rightarrow$ completa `kaz build `.
   - `kaz build -` + `[TAB]` $\rightarrow$ lista flags como `--emit-obj`, `--jit`, `--vm`, `-o`.
3. **Navegação Inteligente de Pastas e Arquivos**:
   - `cd ` filtra **apenas diretórios** e adiciona a barra `/` automaticamente, permitindo encadear `[TAB]` para navegar em pastas profundas (`cd s` + `[TAB]` $\rightarrow$ `cd src/` + `s` + `[TAB]` $\rightarrow$ `cd src/shell/`).
   - Autocomplete de caminhos com suporte a POSIX (`/c/...`), Windows (`C:\...`), relativos (`../`, `./`) e home (`~/`).
4. **Navegação por Menu Colunar**:
   - Use `[TAB]` para avançar e `[Shift+Tab]` para voltar entre as sugestões.

---

## 🖥️ Interface Gráfica & ConPTY

O TermiKAZ inclui um emulador de terminal gráfico com abas via `--gui`:

- **Multi-abas**: Crie e feche abas (`TermiKAZ #1`, `TermiKAZ #2`, etc.) para múltiplos fluxos de trabalho.
- **Renderização por GPU**: Construído sobre `egui` e `eframe` com seletor de temas em tempo real.
- **Botões de Ação Rápida**:
  - `JIT`: Execução de alto desempenho via Cranelift JIT.
  - `Fmt`: Formatação canônica do diretório.
  - `Test`: Execução dos testes Kaz.
  - `Audit`: Auditoria estrutural e sintática do projeto.
  - `ls -la`: Listagem detalhada com cores.
  - `tree`: Árvore visual de arquivos.
  - `A+` / `A-`: Ajuste de tamanho de fonte em tempo real.
- **Suporte ConPTY**: Integração opcional com o subsistema de pseudoterminal nativo do Windows.

---

## 📦 Instalação

### Instaladores Oficiais Windows

Na pasta `dist/`, você encontra instaladores prontos para Windows:

1. **Inno Setup 7 (Recomendado)**: `dist/TermiKAZ_Setup_v1.2.0.exe`
   - Adiciona automaticamente o TermiKAZ ao `PATH` do sistema.
   - Adiciona a opção **"Abrir TermiKAZ Aqui"** no menu de contexto do Windows Explorer (ao clicar com o botão direito em pastas ou no fundo de diretórios).
   - Cria atalhos no Menu Iniciar e na Área de Trabalho com o ícone oficial `flux.ico`.
   - Inclui desinstalador completo.
2. **NSIS**: `dist/TermiKAZ_NSIS_Setup_v1.2.0.exe`
   - Instalador portátil alternativo em formato compacto.

### Compilação a partir do Código-Fonte

Pré-requisitos:
- [Rust & Cargo](https://rustup.rs/) (versão 1.80 ou superior)
- Repositório da linguagem Kaz no diretório adjacente (`../kaz`)

```powershell
# 1. Clonar o repositório
git clone https://github.com/armandosds/TermiKAZ.git
cd TermiKAZ

# 2. Executar a suíte de testes (21 testes automatizados)
cargo test

# 3. Compilar em modo release com otimizações máximas (LTO)
cargo build --release
```

O binário final estará em `target/release/termikaz.exe`.

---

## 🚀 Guia de Uso

### 1. Shell Interativo (CLI)
Inicie o shell no terminal:
```powershell
termikaz
# ou
.\target\release\termikaz.exe
```

### 2. Emulador de Terminal Gráfico (GUI)
Abra a interface com abas acelerada por GPU:
```powershell
termikaz --gui
```

### 3. Modo de Comando Único (`-c`)
Execute comandos diretamente a partir de scripts, PowerShell ou prompt do Windows:
```powershell
termikaz -c "ls -la | grep kaz"
termikaz -c "kaz fmt . --check && kaz test"
termikaz -c "curl -s https://api.github.com | head -n 15"
```

### 4. Execução Direta de Scripts Kaz
```powershell
termikaz caminho/para/script.kaz
```

---

## 🐧 Comandos Linux Nativos Suportados

| Categoria | Comandos |
| :--- | :--- |
| **Navegação & Pastas** | `ls`, `cd`, `pwd`, `mkdir`, `rm`, `rmdir`, `cp`, `mv`, `touch`, `tree`, `stat`, `df` |
| **Troca de Unidades** | `c:`, `d:`, `e:`, `cd c:`, `cd /c`, `cd ~` |
| **Texto & Filtros** | `cat`, `head`, `tail`, `grep`, `wc`, `find`, `sort`, `uniq`, `echo`, `printf` |
| **Sistema & Processos** | `uname`, `whoami`, `hostname`, `date`, `ps`, `kill`, `env`, `which`, `clear`, `cls` |
| **Rede & Downloads** | `curl`, `wget`, `fetch` |
| **Ferramentas Kaz** | `kaz`, `kaz run`, `kaz fmt`, `kaz test`, `kaz trace`, `kaz debug`, `kaz db-cli`, `kaz check`, `kaz audit`, `kaz repl`, `kaz shell` |

---

## 🏗️ Arquitetura do Projeto

```text
TermiKAZ/
├── assets/                  # Identidade visual, ícones (flux.ico) e logos
├── installer/               # Scripts de empacotamento Inno Setup 7 e NSIS
│   ├── termikaz_setup.iss   # Script Inno Setup 7 com integração ao Explorer
│   └── termikaz_setup.nsi   # Script NSIS portátil
├── dist/                    # Instaladores compilados prontos para distribuição
├── src/
│   ├── app/                 # Interface gráfica egui/eframe e ConPTY
│   │   ├── terminal_window.rs  # Janela de abas com TAB completion e botões Kaz
│   │   └── pty_session.rs      # Gerenciamento de processos PTY
│   ├── commands/            # Implementação em Rust dos utilitários Linux
│   │   ├── fs_ops.rs        # ls, cd, pwd, mkdir, rm, cp, mv, touch, tree, stat, df
│   │   ├── text_ops.rs      # cat, head, tail, grep, wc, find, sort, uniq, echo
│   │   ├── sys_ops.rs       # uname, whoami, hostname, date, ps, kill, env, which
│   │   ├── net_ops.rs       # curl, wget, fetch
│   │   └── mod.rs           # Despachante de comandos built-in
│   ├── kaz_interop/         # Integração profunda com o ecossistema Kaz
│   │   └── runner.rs        # Invocação da VM, AST, Formatter, Test Runner, Audit
│   ├── shell/               # Núcleo do emulador e shell POSIX
│   │   ├── path_translator.rs # Tradução POSIX (/c/...) <-> Windows (C:\...)
│   │   ├── parser.rs        # Parser de pipes, redirecionamentos e variáveis
│   │   ├── evaluator.rs     # Motor de execução e encadeamento lógico
│   │   ├── prompt.rs        # Renderizador de prompt POSIX estilizado
│   │   ├── completer.rs     # Motor inteligente de Autocomplete com [TAB]
│   │   └── readline.rs      # Linha de comando com reedline e ColumnarMenu
│   ├── lib.rs               # Biblioteca central exportada
│   └── main.rs              # Ponto de entrada CLI e GUI
├── tests/                   # Suíte de testes automatizados
│   ├── command_tests.rs     # Testes de comandos do sistema de arquivos e pipes
│   ├── completer_tests.rs   # Testes do motor de autocompletion [TAB]
│   ├── kaz_tests.rs         # Testes de integração com a linguagem Kaz
│   └── parser_tests.rs      # Testes de parsing e expansão de variáveis
├── build.rs                 # Vinculação de ícones nativos do Windows (.ico)
└── Cargo.toml               # Dependências e perfis de otimização
```

---

## 🛡️ Segurança & Auditoria

O TermiKAZ passa por auditorias contínuas de segurança (`cargo audit`). Todas as políticas de divulgação responsável, proteções ativas contra injeção de comandos (CVE-2024-24576) e histórico de mitigação de vulnerabilidades estão documentados em:
👉 **[SECURITY.md](SECURITY.md)**

---

## 📋 Changelog

Para conferir o histórico detalhado de todas as alterações, novos recursos e correções entre versões:
👉 **[CHANGELOG.md](CHANGELOG.md)**

---

## 📜 Licença

Distribuído sob as licenças **MIT** ou **Apache-2.0**. Consulte os arquivos de licença para mais informações.
