if [ $# -ne 2 ]; then
    echo "Le script attend exactement deux arguments: le chemin vers le fichier d'URL et le chemin vers le fichier sortie"
    exit
fi

FICHIER_URL=$1
FICHIER_SORTIE=$2
lineno=1

echo "<!DOCTYPE html>" > "$FICHIER_SORTIE"
echo "<html>" >> "$FICHIER_SORTIE"
echo "<head>" >> "$FICHIER_SORTIE"
echo "    <title>Tableau des résultats</title>" >> "$FICHIER_SORTIE"
echo "    <link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css\">" >> "$FICHIER_SORTIE"
echo "</head>" >> "$FICHIER_SORTIE"
echo "<body>" >> "$FICHIER_SORTIE"
echo "    <section class=\"section\">" >> "$FICHIER_SORTIE"
echo "        <div class=\"container\">" >> "$FICHIER_SORTIE"
echo "            <a class=\"button\" href=\"index.html\">← Retour</a>" >> "$FICHIER_SORTIE"
echo "            <h1 class=\"title\">Tableau des résultats</h1>" >> "$FICHIER_SORTIE"
echo "            <table class=\"table is-bordered is-striped\">" >> "$FICHIER_SORTIE"
echo "                <thead>" >> "$FICHIER_SORTIE"
echo "                    <tr><th>Numéro</th><th>URL</th><th>Code HTTP</th><th>Encodage</th><th>Nb mots</th></tr>" >> "$FICHIER_SORTIE"
echo "                </thead>" >> "$FICHIER_SORTIE"
echo "                <tbody>" >> "$FICHIER_SORTIE"

while read -r line; do
    if [ "$line" != "" ]; then
        code=$(curl -s -o /dev/null -w "%{http_code}" "$line")
        content=$(curl -s "$line")
        encodage=$(echo "$content" | grep -i "charset=" | head -n1 | grep -E -o "charset=.*" | cut -d= -f2 | tr -d '>"')
        if [ -z "$encodage" ]; then
            encodage="Non spécifié"
        fi
        nb_mots=$(echo "$content" | wc -w)

        echo "                    <tr><td>$lineno</td><td><a href=\"$line\">$line</a></td><td>$code</td><td>$encodage</td><td>$nb_mots</td></tr>" >> "$FICHIER_SORTIE"

        lineno=$((lineno + 1))
    fi
done < "$FICHIER_URL"

echo "                </tbody>" >> "$FICHIER_SORTIE"
echo "            </table>" >> "$FICHIER_SORTIE"
echo "        </div>" >> "$FICHIER_SORTIE"
echo "    </section>" >> "$FICHIER_SORTIE"
echo "</body>" >> "$FICHIER_SORTIE"
echo "</html>" >> "$FICHIER_SORTIE"

echo "Page générée: $FICHIER_SORTIE"