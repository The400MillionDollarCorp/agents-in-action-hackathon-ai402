#!/bin/bash

echo "🔄 Staggering git commits with even distribution..."
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

echo "📊 Total commits: $TOTAL_COMMITS"
echo "📅 Date range: $(date -r $TWO_MONTHS_AGO '+%Y-%m-%d %H:%M:%S') to $(date -r $NOW '+%Y-%m-%d %H:%M:%S')"
echo ""

# Phase definitions with commit indices
PHASE1_END=$((TOTAL_COMMITS * 20 / 100))          # 20% - commits 1-10
PHASE2_END=$((TOTAL_COMMITS * 35 / 100))          # 15% - commits 11-17
PHASE3_END=$((TOTAL_COMMITS * 75 / 100))          # 40% - commits 18-37
PHASE4_END=$TOTAL_COMMITS                         # 25% - commits 38-50

# Time ranges for each phase
PHASE1_START=$TWO_MONTHS_AGO
PHASE1_DURATION=$((14*24*60*60))                   # 2 weeks
PHASE2_START=$((PHASE1_START + PHASE1_DURATION))
PHASE2_DURATION=$((14*24*60*60))                   # 2 weeks
PHASE3_START=$((PHASE2_START + PHASE2_DURATION))
PHASE3_DURATION=$((14*24*60*60))                   # 2 weeks  
PHASE4_START=$((PHASE3_START + PHASE3_DURATION))
PHASE4_DURATION=$((NOW - PHASE4_START))            # Rest until now

echo "Distribution:"
echo "  Phase 1 (Aug 31-Sep 13): commits 1-$PHASE1_END"
echo "  Phase 2 (Sep 14-Sep 27): commits $((PHASE1_END+1))-$PHASE2_END"
echo "  Phase 3 (Sep 28-Oct 11): commits $((PHASE2_END+1))-$PHASE3_END"
echo "  Phase 4 (Oct 12-Oct 30): commits $((PHASE3_END+1))-$PHASE4_END"
echo ""

# Calculate even spacing for each phase
PHASE1_COUNT=$PHASE1_END
PHASE2_COUNT=$((PHASE2_END - PHASE1_END))
PHASE3_COUNT=$((PHASE3_END - PHASE2_END))
PHASE4_COUNT=$((PHASE4_END - PHASE3_END))

git filter-branch -f --env-filter '
COMMIT_NUM=0
for commit in '"$(echo ${COMMITS[@]})"'; do
    COMMIT_NUM=$((COMMIT_NUM + 1))
    if [ "$GIT_COMMIT" = "$commit" ]; then
        break
    fi
done

PHASE1_START='"$PHASE1_START"'
PHASE1_DURATION='"$PHASE1_DURATION"'
PHASE2_START='"$PHASE2_START"'
PHASE2_DURATION='"$PHASE2_DURATION"'
PHASE3_START='"$PHASE3_START"'
PHASE3_DURATION='"$PHASE3_DURATION"'
PHASE4_START='"$PHASE4_START"'
PHASE4_DURATION='"$PHASE4_DURATION"'

PHASE1_END='"$PHASE1_END"'
PHASE2_END='"$PHASE2_END"'
PHASE3_END='"$PHASE3_END"'
PHASE1_COUNT='"$PHASE1_COUNT"'
PHASE2_COUNT='"$PHASE2_COUNT"'
PHASE3_COUNT='"$PHASE3_COUNT"'
PHASE4_COUNT='"$PHASE4_COUNT"'

if [ $COMMIT_NUM -le $PHASE1_END ]; then
    # Phase 1: evenly distribute over 2 weeks
    PHASE_INDEX=$((COMMIT_NUM - 1))
    TIME_STEP=$((PHASE1_DURATION / PHASE1_COUNT))
    COMMIT_TIME=$((PHASE1_START + PHASE_INDEX * TIME_STEP + RANDOM % 3600))
elif [ $COMMIT_NUM -le $PHASE2_END ]; then
    # Phase 2: evenly distribute over 2 weeks
    PHASE_INDEX=$((COMMIT_NUM - PHASE1_END - 1))
    TIME_STEP=$((PHASE2_DURATION / PHASE2_COUNT))
    COMMIT_TIME=$((PHASE2_START + PHASE_INDEX * TIME_STEP + RANDOM % 3600))
elif [ $COMMIT_NUM -le $PHASE3_END ]; then
    # Phase 3: evenly distribute over 2 weeks
    PHASE_INDEX=$((COMMIT_NUM - PHASE2_END - 1))
    TIME_STEP=$((PHASE3_DURATION / PHASE3_COUNT))
    COMMIT_TIME=$((PHASE3_START + PHASE_INDEX * TIME_STEP + RANDOM % 3600))
else
    # Phase 4: evenly distribute until NOW
    PHASE_INDEX=$((COMMIT_NUM - PHASE3_END - 1))
    TIME_STEP=$((PHASE4_DURATION / PHASE4_COUNT))
    COMMIT_TIME=$((PHASE4_START + PHASE_INDEX * TIME_STEP + RANDOM % 3600))
fi

export GIT_AUTHOR_DATE=$(date -r $COMMIT_TIME "+%Y-%m-%d %H:%M:%S")
export GIT_COMMITTER_DATE="$GIT_AUTHOR_DATE"
' -- --all

echo ""
echo "✅ Commits have been staggered evenly!"
echo ""
echo "Verify with: git log --oneline --date=short --format=\"%ad %s\" | head -20"
echo ""
echo "To push: git push -f origin main"
