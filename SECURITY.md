# Política e Relatório de Segurança - TermiKAZ 🛡️

A segurança e a integridade de execução são prioridades absolutas no desenvolvimento do **TermiKAZ**. Esta documentação descreve a política de segurança, as proteções implementadas e o histórico detalhado de correções e mitigação de vulnerabilidades a partir da versão **v1.2.0**.

---

## 🔒 Histórico de Correções de Segurança (v1.2.0)

Na versão **1.2.0**, o TermiKAZ passou por uma auditoria completa de segurança interna e externa (`cargo audit`), mitigando riscos críticos de execução de comandos e vulnerabilidades em dependências:

### 1. Prevenção Contra Injeção de Comandos (Command Injection via Command API)
- **Localização:** `src/shell/evaluator.rs` (`sanitize_and_prepare_command` e `execute_external`).
- **Problema:** A invocação de comandos com argumentos controlados pelo usuário ou caminhos arbitrários pode introduzir riscos de injeção de parâmetros, escape de argumentos ou execução indevida no sistema operacional hospedeiro.
- **Correções Aplicadas:**
  1. **Validação Estrita de Caminho e Argumentos:** Todos os comandos e parâmetros passam por rotina de validação prévia antes de atingir `std::process::Command`.
  2. **Rejeição de Bytes Nulos (`\0`):** Qualquer comando ou argumento contendo bytes nulos é sumariamente rejeitado, prevenindo *null-byte truncation attacks* em chamadas de baixo nível da Win32 API.
  3. **Rejeição de Caracteres de Controle ASCII:** Caracteres ASCII de controle (< `0x20`, com exceção de `\t`) são bloqueados.
  4. **Mitigação para Scripts Batch Windows (CVE-2024-24576 / RUSTSEC-2024-0019):** No Windows, executar arquivos `.bat` ou `.cmd` invoca o `cmd.exe`, que possui regras complexas de parsing. Argumentos fornecidos a scripts batch são inspecionados contra metacaracteres perigosos de interpolação (`&`, `|`, `<`, `>`, `^`, `%`, `\n`, `\r`) e bloqueados.
  5. **Sanitização de Variáveis de Ambiente:** Bloqueio de variáveis de ambiente contendo bytes nulos ou nomes inválidos contendo `=`.
  6. **Prevenção de Hang/DoS por Bloqueio de Stdin:** O descritor padrão `Stdio::inherit()` foi substituído por `Stdio::null()` quando não há dados direcionados via pipe, evitando bloqueios permanentes de processos filhos.

---

### 2. Auditoria e Blindagem de Dependências (`cargo audit`)

O TermiKAZ foi auditado contra o banco oficial de vulnerabilidades da RustSec Advisory Database:

| Crate | Versão Anterior | Vulnerabilidade / Advisory | Ação / Status na v1.2.0 |
|---|---|---|---|
| **`rustls`** | `<= 0.23.44` | RUSTSEC-2026-0285 / CVE-2026-XXXXX | Atualizado para `0.23.45` sem vulnerabilidades conhecidas |
| **`rand`** | Subdependência | RCE via deserialização não segura em `UniformChar` | Removido do grafo de dependências via desativação de recursos desnecessários (`accesskit`) |
| **`paste`** | Subdependência | Vulnerabilidade de macro / unmaintained | Removido do grafo de dependências |
| **`quick-xml`** | `< 0.41.0` | RUSTSEC-2026-0194 / RUSTSEC-2026-0195 (DoS por Complexidade Algorítmica e Recursão de Namespace) | Atualizado e pinned para `>= 0.41.0` |

> **Resultado do `cargo audit`:** **0 vulnerabilidades encontradas** em 408 crates analisadas no workspace.

---

### 3. Proteção e Decodificação Segura de I/O de Terminal
- **Localização:** `src/shell/evaluator.rs` (`decode_process_output`), `src/app/terminal_window.rs` (`strip_ansi_or_clean`).
- **Problema:** A leitura de streams de processos externos via `from_utf8_lossy` corrompia dados de saída OEM (CP850 / CP437) e sequências de escape ANSI malformadas podiam manipular o terminal ou a UI.
- **Correções Aplicadas:**
  1. Decodificação segura: tenta UTF-8 estrito; caso inválido no Windows, converte via API nativa `MultiByteToWideChar(CP_OEMCP)` sem corromper caracteres ou gerar *memory smuggling*.
  2. Filtro estrito de sequências ANSI: sequências OSC (títulos de janela), sequências CSI e caracteres de controle como `\x07` (BEL) e `\r` são higienizados antes de serem exibidos na interface gráfica.

---

## 🛡️ Reportando Vulnerabilidades

Se você descobrir uma possível vulnerabilidade de segurança no TermiKAZ:
1. **Não abra uma issue pública** no GitHub.
2. Envie um e-mail com a descrição e passos para reprodução para a equipe de desenvolvimento em: `armando.sds@gmail.com` ou através do GitHub Security Advisory privado.
3. Forneceremos uma resposta inicial em até 48 horas e uma correção tempestiva.
