#!/usr/bin/env sh

_() {
  ANO="2017"
  echo "Nome de usuário no GitHub: "
  read -r NOME_USUARIO
  echo "Token de acesso do GitHub: "
  read -r TOKEN_ACESSO

  [ -z "$NOME_USUARIO" ] && exit 1
  [ -z "$TOKEN_ACESSO" ] && exit 1
  [ ! -d $ANO ] && mkdir $ANO

  cd "${ANO}" || exit
  git init
  git config core.autocrlf false  # Desativa a conversão automática de CRLF no Windows
  echo "**${ANO}** - Gerado por Erick" \
    >README.md
  git add README.md

  # Commit para os dias do mês
  for MES in {01..12}
  do
    for DIA in {01..31}
    do
      # Verifica se o dia é válido para o mês
      if [ $MES -eq 02 ] && [ $DIA -ge 29 ]; then
        continue
      elif [ $MES -eq 04 ] && [ $DIA -eq 31 ]; then
        continue
      elif [ $MES -eq 06 ] && [ $DIA -eq 31 ]; then
        continue
      elif [ $MES -eq 09 ] && [ $DIA -eq 31 ]; then
        continue
      elif [ $MES -eq 11 ] && [ $DIA -eq 31 ]; then
        continue
      fi

      echo "Conteúdo para ${ANO}-${MES}-${DIA}" > "dia${DIA}.txt"
      git add "dia${DIA}.txt"
      GIT_AUTHOR_DATE="${ANO}-${MES}-${DIA}T18:00:00" \
        GIT_COMMITTER_DATE="${ANO}-${MES}-${DIA}T18:00:00" \
        git commit -m "Commit para ${ANO}-${MES}-${DIA}"
    done
  done

  git remote add origin "https://${TOKEN_ACESSO}@github.com/${NOME_USUARIO}/${ANO}.git"
  git branch -M main
  git push -u origin main -f
  cd ..
  rm -rf "${ANO}"

  echo
  echo "Legal, esqueça tudo, parceiro! https://github.com/${NOME_USUARIO}"
} && _

unset -f _
