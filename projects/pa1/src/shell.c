#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <assert.h>
#include <sys/types.h>
#include <sys/stat.h>

// Simplifed xv6 shell.

#define MAXARGS 10

// All commands have at least a type. Have looked at the type, the code
// typically casts the *cmd to some specific cmd type.
struct cmd {
  int type;          //  ' ' (exec), | (pipe), '<' or '>' for redirection
};

struct execcmd {
  int type;              // ' '
  char *argv[MAXARGS];   // arguments to the command to be exec-ed
};

struct redircmd {
  int type;          // < or > 
  struct cmd *cmd;   // the command to be run (e.g., an execcmd)
  char *file;        // the input/output file
  int mode;          // the mode to open the file with
  int fd;            // the file descriptor number to use for the file
};

struct pipecmd {
  int type;          // |
  struct cmd *left;  // left side of pipe
  struct cmd *right; // right side of pipe
};

struct listcmd {
  int type; // ';'
  struct cmd *left;
  struct cmd *right;
};

int fork1(void);  // Fork but exits on failure.
struct cmd *parsecmd(char*);


// Execute cmd.  Never returns.
void runcmd(struct cmd *cmd) {
  int p[2], r;
  struct execcmd *ecmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;
  struct listcmd *listcmd;

  if(cmd == 0)
    exit(0);

  switch(cmd->type){
    case ' ':
      ecmd = (struct execcmd*)cmd;
      if(ecmd->argv[0] == 0)
        exit(0);
      execvp(ecmd->argv[0], ecmd->argv);
      break;

    case '>':
    case '<':
      rcmd = (struct redircmd*)cmd;
      fprintf(stderr, "redeir not implemented\n");
      // Your code here ...
      runcmd(rcmd->cmd);
      break;

    case ';':
      listcmd = (struct listcmd*)cmd;
      if(fork1() == 0) {
        runcmd(listcmd->left);
      }
      wait(NULL);
      runcmd(listcmd->right);
      break;

    case '|':
      pcmd = (struct pipecmd*)cmd;
      fprintf(stderr, "pipe not implemented\n");
      // Your code here ...
      break;

    default:
      printf("{{%c}} caused unkown cmd.....\n", cmd->type );
      fprintf(stderr, "unknown runcmd\n");
      exit(-1); 
  }
  exit(0);
}

int getcmd(char *buf, int nbuf) {
  if (isatty(fileno(stdin)))
    fprintf(stdout, "$ ");
  memset(buf, 0, nbuf);
  fgets(buf, nbuf, stdin);
  if(buf[0] == 0) // EOF
    return -1;
  return 0;
}

int main(void) {
  static char buf[100];
  int fd, r;

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0) // check if its a child directory
        fprintf(stderr, "cannot cd %s\n", buf+3);
      continue;
    }
    if(fork1() == 0) {
      runcmd(parsecmd(buf));
    }
    wait(&r);
  }
  exit(0);
}

int fork1(void) {
  int pid;
  
  pid = fork();
  if(pid == -1)
    perror("fork");
  return pid;
}

struct cmd* execcmd(void) {
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = ' ';
  return (struct cmd*)cmd;
}

struct cmd* redircmd(struct cmd *subcmd, char *file, int type) {
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = type;
  cmd->cmd = subcmd;
  cmd->file = file;
  cmd->mode = (type == '<') ?  O_RDONLY : O_WRONLY|O_CREAT|O_TRUNC;
  cmd->fd = (type == '<') ? 0 : 1;
  return (struct cmd*)cmd;
}

struct cmd* pipecmd(struct cmd *left, struct cmd *right) {
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = '|';
  cmd->left = left;
  cmd->right = right;
  return (struct cmd*)cmd;
}

struct cmd* listcmd(struct cmd *left, struct cmd *right) {
  struct listcmd *listcmd;

  listcmd = malloc(sizeof(*listcmd));
  memset(listcmd, 0, sizeof(*listcmd));
  listcmd->type = ';';
  listcmd->left = left;
  listcmd->right = right;
  return (struct cmd*)listcmd;
}

// Parsing

char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>;()";

//ps is advanced past any whitespace, past first token, and up to the next token
//es points to end of string
//q is trimmed original string (trimmed version inital string ps points to)
//eq is advanced past first token (but not passed the whitespace)
//returns: ret, an int that points 
int gettoken(char **ps, char *es, char **q, char **eq) {
  char *s;
  int ret;
  s = *ps;

  while(s < es && strchr(whitespace, *s))
    s++;

  if(q)
    *q = s;

  ret = *s;

  switch(*s) {
    case 0:
      break;
    case '|': 
    case '<':
    case '>':
    case ';':
    case '(':
    case ')':
      s++;
      break;
    default:
      ret = 'a';
      while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
        s++;
      break;
  }

  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;

  return ret;
}

//advances ps to next non-whitespace char or up to es
//return true if the current char s is not null 
// and if toks contains the char ps now points to
//else return false
int peek(char **ps, char *es, char *toks) {
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return *s && strchr(toks, *s);
}

struct cmd *parseline(char**, char*);
struct cmd *parsepipe(char**, char*);
struct cmd *parseexec(char**, char*);
struct cmd* parseredirs(struct cmd *, char**, char*);
struct cmd *parseparens(char**, char *);

// make a copy of the characters in the input buffer, starting from s through es.
// null-terminate the copy to make it a string.
char *mkcopy(char *s, char *es) {
  int n = es - s;
  char *c = malloc(n+1);
  assert(c);
  strncpy(c, s, n);
  c[n] = 0;
  return c;
}

struct cmd* parsecmd(char *s) {
  char *es;
  struct cmd *cmd;
  es = s + strlen(s);
  cmd = parseline(&s, es);
  peek(&s, es, "");
  if(s != es){
    fprintf(stderr, "leftovers: %s\n", s);
    exit(-1);
  }
  return cmd;
}

//i need to trim the first part of string for preparens
struct cmd* parseline(char **ps, char *es) {
  printf("Currently inside parseline, ps is {{%s}}, es is {{%s}}\n", *ps, es);
  struct cmd *cmd;
  cmd = parsepipe(ps, es); //ls
  if (peek(ps, es, ";")) {
    gettoken(ps, es, 0, 0);

    //check if any open parens exist, make sure it runs first
    char *openparens;
    if ((openparens = strchr(*ps, '('))) {
      printf("Currently inside parseline, found openparens at {{%s}}\n", openparens);

      //check if there is stuff before the open parens, THIS IS NICE
      struct cmd *preparens;
      if (*ps != openparens) {
        printf("STARTING PREPARENS\n");
        char *pps = mkcopy(*ps, openparens);
        char *ppes = pps + strlen(pps);
        printf("Currently inside parseline, made a preparens string {{%s}} ending at {{%c}}\n", pps, *ppes);
        preparens = parseline(&pps, ppes);
        *ps = openparens;
        printf("FINISHED PREPARENS\n");
      }

      // char *lastclosing = strrchr(*ps, ')');
      // printf("Currently inside parseline, found lastclosing parens at {{%s}}, parsing parens\n", lastclosing);

      // while(*openparens != ';')
      //     openparens--;
      // gettoken(&lastclosing, es, 0, 0);
      printf("STARTING PARENS\n");
      struct cmd *parenscmd = parseparens(ps, es);
      // gettoken(ps, es, 0, 0);

      printf("FINISHED PARENS, ps is now {{%s}}", *ps);
      //get the post parens!!
      struct cmd *postparens;
      if (*ps != es) {
        printf("STARTING POSTPARENS, ps is now {{%s}}", *ps);
        postparens = parseline(ps, es);
        printf("FINISHED POSTPARENS, ps is now {{%s}}", *ps);
      }



      if (preparens && postparens) {
        printf("BOTH WOW AND PARENS\n");
        cmd = listcmd(parenscmd, listcmd(listcmd(cmd, preparens), postparens));
      } else if (preparens && !postparens) {
        printf("ONLY PREPARENS AND PARENS\n");
        cmd = listcmd(parenscmd, listcmd(cmd, preparens));
      } else if (postparens && !preparens) {
        printf("ONLY POSTPARENS AND PARENS\n");
        cmd = listcmd(parenscmd, listcmd(cmd, postparens));
      } else {
        printf("ONLY PARENS AND CMD\n");
        cmd = listcmd(parenscmd, cmd);
      }
  
    } 
    else {
      printf("ONLY CMD and REGULAR PARSELINE, parsing line with ps at {{%s}}\n", *ps);
      cmd = listcmd(cmd, parseline(ps, es));
    }
  }
  return cmd;
}


 
//parse everything between parens, including nested parens.
struct cmd* parseparens(char **ps, char *es) {
  printf("Currently inside parseparens, ps is {{%s}}, es is {{%s}}\n", *ps, es);
  struct cmd *cmd;

  if (!peek(ps, es, "(")) {
    printf("not a parenthesized command.");
  }

  gettoken(ps, es, 0, 0);
  cmd = parseline(ps, es);

  if (!peek(ps, es, ")")) {
    printf("no closing parenthesis");
  }

  gettoken(ps,es, 0, 0);
  cmd = parseredirs(cmd, ps, es);
  return cmd;
}


struct cmd* parsepipe(char **ps, char *es) {
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
  }
  return cmd;
}

struct cmd* parseredirs(struct cmd *cmd, char **ps, char *es) {
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a') {
      fprintf(stderr, "missing file for redirection\n");
      exit(-1);
    }
    switch(tok){
      case '<':
      cmd = redircmd(cmd, mkcopy(q, eq), '<');
      break;
      case '>':
      cmd = redircmd(cmd, mkcopy(q, eq), '>');
      break;
    }
  }
  return cmd;
}

struct cmd* parseexec(char **ps, char *es) {
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  printf("Currently inside parseexec, ps is {{%s}}, es is {{%s}}\n", *ps, es);
  
  if (peek(ps, es, "(")) {
     return parseparens(ps, es);
  }

  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while (!peek(ps, es, "|);")) {
    printf("Currently inside parseexec while loop, ps is {{%s}}, es is {{%s}}\n", *ps, es);
    if ((tok=gettoken(ps, es, &q, &eq)) == 0) {
      break;
    }
    if (tok != 'a') {
      fprintf(stderr, "syntax error\n");
      exit(-1);
    }
    cmd->argv[argc] = mkcopy(q, eq);
    argc++;
    if(argc >= MAXARGS) {
      fprintf(stderr, "too many args\n");
      exit(-1);
    }
    ret = parseredirs(ret, ps, es);
  }

  cmd->argv[argc] = 0;
  return ret;
}


