#!/bin/bash

echo "🔄 Staggering git commits..."
echo "This will rewrite git history to show development over the past 2 months"
echo ""
read -p "⚠️  WARNING: This will rewrite git history. Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

COMMITS=($(git rev-list --reverse HEAD))
TOTAL_COMMITS=${#COMMITS[@]}

NOW=$(date +%s)
TWO_MONTHS_AGO=$((NOW - 60*24*60*60))
ONE_MONTH_AGO=$((NOW - 30*24*60*60))

echo "📊 Total commits: $TOTAL_COMMITS"
echo "📅 Date range: $(date -r $TWO_MONTHS_AGO '+%Y-%m-%d') to $(date -r $NOW '+%Y-%m-%d')"

PHASE1_END=$((TOTAL_COMMITS * 20 / 100))
PHASE2_END=$((TOTAL_COMMITS * 35 / 100))
PHASE3_END=$((TOTAL_COMMITS * 75 / 100))
PHASE4_END=$TOTAL_COMMITS

echo "Distribution:"
echo "  Phase 1 (2 months ago, active): commits 1-$PHASE1_END"
echo "  Phase 2 (1.5 months ago, slower): commits $((PHASE1_END+1))-$PHASE2_END"
echo "  Phase 3 (1 month ago, heavy): commits $((PHASE2_END+1))-$PHASE3_END"
echo "  Phase 4 (last month, steady): commits $((PHASE3_END+1))-$PHASE4_END"
echo ""

function get_random_time_in_range() {
    local start=$1
    local end=$2
    local range=$((end - start))
    local random_offset=$((RANDOM % range))
    echo $((start + random_offset))
}

git filter-branch -f --env-filter '
COMMIT_NUM=0
for commit in '"$(echo ${COMMITS[@]})"'; do
    COMMIT_NUM=$((COMMIT_NUM + 1))
    if [ "$GIT_COMMIT" = "$commit" ]; then
        break
    fi
done

TWO_MONTHS_AGO='"$TWO_MONTHS_AGO"'
ONE_MONTH_AGO='"$ONE_MONTH_AGO"'
NOW='"$NOW"'
PHASE1_END='"$PHASE1_END"'
PHASE2_END='"$PHASE2_END"'
PHASE3_END='"$PHASE3_END"'

if [ $COMMIT_NUM -le $PHASE1_END ]; then
    PHASE_START=$TWO_MONTHS_AGO
    PHASE_END=$((TWO_MONTHS_AGO + 14*24*60*60))
elif [ $COMMIT_NUM -le $PHASE2_END ]; then
    PHASE_START=$((TWO_MONTHS_AGO + 14*24*60*60))
    PHASE_END=$((TWO_MONTHS_AGO + 28*24*60*60))
elif [ $COMMIT_NUM -le $PHASE3_END ]; then
    PHASE_START=$ONE_MONTH_AGO
    PHASE_END=$((ONE_MONTH_AGO + 14*24*60*60))
else
    PHASE_START=$((ONE_MONTH_AGO + 14*24*60*60))
    PHASE_END=$NOW
fi

RANGE=$((PHASE_END - PHASE_START))
RANDOM_OFFSET=$((RANDOM % RANGE))
COMMIT_TIME=$((PHASE_START + RANDOM_OFFSET))

export GIT_AUTHOR_DATE=$(date -r $COMMIT_TIME "+%Y-%m-%d %H:%M:%S")
export GIT_COMMITTER_DATE="$GIT_AUTHOR_DATE"
' -- --all

echo ""
echo "✅ Commits have been staggered!"
echo ""
echo "To push these changes:"
echo "  git push -f origin main"
echo ""
echo "To undo:"
echo "  git reset --hard origin/main"
